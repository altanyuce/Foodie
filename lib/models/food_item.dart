enum NutritionStatus { none, fetching, ready }

enum FoodSource { spoonacular, mealdb, off }

class FoodItem {
  final String id;
  final String name;
  final FoodSource source;
  final String? servingDesc;
  final String? brand;
  double calories;
  double protein;
  double carbs;
  double fat;
  NutritionStatus nutritionStatus;

  FoodItem({
    required this.id,
    required this.name,
    required this.source,
    this.servingDesc,
    this.brand,
    this.calories = 0,
    this.protein = 0,
    this.carbs = 0,
    this.fat = 0,
    this.nutritionStatus = NutritionStatus.none,
  });

  FoodItem copyWith({
    String? id,
    String? name,
    FoodSource? source,
    String? servingDesc,
    String? brand,
    double? calories,
    double? protein,
    double? carbs,
    double? fat,
    NutritionStatus? nutritionStatus,
  }) {
    return FoodItem(
      id: id ?? this.id,
      name: name ?? this.name,
      source: source ?? this.source,
      servingDesc: servingDesc ?? this.servingDesc,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fat: fat ?? this.fat,
      nutritionStatus: nutritionStatus ?? this.nutritionStatus,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'source': source.name,
    'servingDesc': servingDesc,
    'brand': brand,
    'calories': calories,
    'protein': protein,
    'carbs': carbs,
    'fat': fat,
    'nutritionStatus': nutritionStatus.toString().split('.').last,
  };

  factory FoodItem.fromJson(Map<String, dynamic> m) => FoodItem(
    id: m['id'] ?? '',
    name: m['name'] ?? '',
    source: _parseFoodSource(m['source'] ?? 'spoonacular'),
    servingDesc: m['servingDesc'],
    brand: m['brand'],
    calories: (m['calories'] ?? 0).toDouble(),
    protein: (m['protein'] ?? 0).toDouble(),
    carbs: (m['carbs'] ?? 0).toDouble(),
    fat: (m['fat'] ?? 0).toDouble(),
    nutritionStatus: NutritionStatus.values.firstWhere(
      (e) => e.toString().split('.').last == (m['nutritionStatus'] ?? 'none'),
      orElse: () => NutritionStatus.none,
    ),
  );

    static FoodSource _parseFoodSource(String source) {
    final normalized = source.toLowerCase();
    return FoodSource.values.firstWhere(
      (e) => e.name == normalized || 
             (e == FoodSource.off && normalized == 'openfoodfacts'),
      orElse: () => FoodSource.spoonacular,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FoodItem && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'FoodItem(id: $id, name: $name, brand: $brand)';
  }
}

enum MealType {
  breakfast,
  lunch,
  dinner,
  snacks,
}

extension MealTypeExtension on MealType {
  String get displayName {
    switch (this) {
      case MealType.breakfast:
        return 'Breakfast';
      case MealType.lunch:
        return 'Lunch';
      case MealType.dinner:
        return 'Dinner';
      case MealType.snacks:
        return 'Snacks';
    }
  }
}
