import '../models/macros.dart';

class CalorieService {
  static const Macros defaultTargetMacros = Macros(
    protein: 120,
    carbohydrate: 250,
    fat: 70,
  );

  /// Calculate daily calorie target based on weight and height
  /// Using simple formula: weightKg * 24 * 1.3 (light activity)
  static double getDailyTargetKgCm(double weightKg, double heightCm) {
    return weightKg * 24 * 1.3;
  }

  /// Get default macro targets
  static Macros getDefaultMacroTargets() {
    return defaultTargetMacros;
  }

  /// Calculate calories from macros (simplified)
  /// Protein: 4 kcal/g, Carbs: 4 kcal/g, Fat: 9 kcal/g
  static double calculateCaloriesFromMacros(Macros macros) {
    return (macros.protein * 4) + (macros.carbohydrate * 4) + (macros.fat * 9);
  }

  /// Get demo meal macros (for the 100 kcal demo)
  static Macros getDemoMealMacros() {
    return const Macros(
      protein: 5,
      carbohydrate: 12,
      fat: 3,
    );
  }
}


