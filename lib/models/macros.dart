class Macros {
  final double protein;
  final double carbohydrate;
  final double fat;

  const Macros({
    required this.protein,
    required this.carbohydrate,
    required this.fat,
  });

  Macros operator +(Macros other) {
    return Macros(
      protein: protein + other.protein,
      carbohydrate: carbohydrate + other.carbohydrate,
      fat: fat + other.fat,
    );
  }

  Macros copyWith({
    double? protein,
    double? carbohydrate,
    double? fat,
  }) {
    return Macros(
      protein: protein ?? this.protein,
      carbohydrate: carbohydrate ?? this.carbohydrate,
      fat: fat ?? this.fat,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'protein': protein,
      'carbohydrate': carbohydrate,
      'fat': fat,
    };
  }

  factory Macros.fromJson(Map<String, dynamic> json) {
    return Macros(
      protein: (json['protein'] ?? 0).toDouble(),
      carbohydrate: (json['carbohydrate'] ?? 0).toDouble(),
      fat: (json['fat'] ?? 0).toDouble(),
    );
  }
}

class UserData {
  final double heightCm;
  final double weightKg;
  final double dailyTargetKcal;

  const UserData({
    required this.heightCm,
    required this.weightKg,
    required this.dailyTargetKcal,
  });

  UserData copyWith({
    double? heightCm,
    double? weightKg,
    double? dailyTargetKcal,
  }) {
    return UserData(
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      dailyTargetKcal: dailyTargetKcal ?? this.dailyTargetKcal,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'heightCm': heightCm,
      'weightKg': weightKg,
      'dailyTargetKcal': dailyTargetKcal,
    };
  }

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      heightCm: (json['heightCm'] ?? 0).toDouble(),
      weightKg: (json['weightKg'] ?? 0).toDouble(),
      dailyTargetKcal: (json['dailyTargetKcal'] ?? 0).toDouble(),
    );
  }
}


