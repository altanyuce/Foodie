import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/macros.dart';
import '../models/food_item.dart';
import '../services/calorie_service.dart';
import '../services/storage_service.dart';
import '../services/exercise_service.dart';
import 'daily_stats_provider.dart';

class HomeProvider extends ChangeNotifier {
  double _targetKcal = 0.0;
  double _consumedKcal = 0.0;
  Macros _consumedMacros = const Macros(protein: 0, carbohydrate: 0, fat: 0);
  final Macros _targetMacros = CalorieService.getDefaultMacroTargets();
  
  // Exercise service for burned calories
  final _exerciseService = ExerciseService();

  // Food items for each meal
  final Map<MealType, List<FoodItem>> _mealItems = {
    MealType.breakfast: [],
    MealType.lunch: [],
    MealType.dinner: [],
    MealType.snacks: [],
  };

  double get targetKcal => _targetKcal;
  double get consumedKcal => _consumedKcal;
  Future<double> get burnedKcal => _exerciseService.getTotalCaloriesForDate(DateTime.now());
  Macros get consumedMacros => _consumedMacros;
  Macros get targetMacros => _targetMacros;

  List<FoodItem> getMealItems(MealType mealType) => _mealItems[mealType] ?? [];

  Future<double> get remainingKcal async {
    final burned = await burnedKcal;
    return (_targetKcal - (_consumedKcal - burned)).clamp(0.0, double.infinity);
  }

  Future<void> refresh() async {
    _consumedKcal = await StorageService.getConsumedKcal();
    _consumedMacros = await StorageService.getConsumedMacros();

    final userData = await StorageService.getUserData();
    if (userData != null) {
      _targetKcal = userData['dailyTargetKcal']!;
    }

    notifyListeners();
  }

  Future<void> initialize() async {
    await refresh();
  }

  Future<void> setHeightWeight(double heightCm, double weightKg) async {
    _targetKcal = CalorieService.getDailyTargetKgCm(weightKg, heightCm);
    await StorageService.saveUserData(
      heightCm: heightCm,
      weightKg: weightKg,
      dailyTargetKcal: _targetKcal,
    );
    notifyListeners();
  }

  Future<void> addDemoMeal() async {
    final demoMacros = CalorieService.getDemoMealMacros();
    const demoKcal = 100.0;

    _consumedKcal += demoKcal;
    _consumedMacros = _consumedMacros + demoMacros;

    await StorageService.saveConsumedMacros(_consumedMacros);
    await StorageService.saveConsumedKcal(_consumedKcal);

    notifyListeners();
  }

  Future<void> resetDailyData() async {
    _consumedKcal = 0.0;
    _consumedMacros = const Macros(protein: 0, carbohydrate: 0, fat: 0);

    // Clear all meal items
    for (final mealType in MealType.values) {
      _mealItems[mealType] = [];
    }

    // Reset exercise data
    await _exerciseService.resetDate(DateTime.now());

    await StorageService.saveConsumedKcal(_consumedKcal);
    await StorageService.saveConsumedMacros(_consumedMacros);

    notifyListeners();
  }

  void addFoodItem(MealType mealType, FoodItem foodItem) {
    _mealItems[mealType]?.add(foodItem);

    // Update consumed calories and macros
    _consumedKcal += foodItem.calories;
    _consumedMacros = _consumedMacros +
        Macros(
          protein: foodItem.protein,
          carbohydrate: foodItem.carbs,
          fat: foodItem.fat,
        );

    // Save to storage
    StorageService.saveConsumedKcal(_consumedKcal);
    StorageService.saveConsumedMacros(_consumedMacros);

    notifyListeners();
  }

  void removeFoodItem(MealType mealType, FoodItem foodItem) {
    final mealItems = _mealItems[mealType];
    if (mealItems != null && mealItems.remove(foodItem)) {
      // Update consumed calories and macros
      _consumedKcal -= foodItem.calories;
      _consumedMacros = _consumedMacros +
          Macros(
            protein: -foodItem.protein,
            carbohydrate: -foodItem.carbs,
            fat: -foodItem.fat,
          );

      // Save to storage
      StorageService.saveConsumedKcal(_consumedKcal);
      StorageService.saveConsumedMacros(_consumedMacros);

      notifyListeners();
    }
  }
}
