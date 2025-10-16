import 'package:flutter/foundation.dart';

enum ExerciseType {
  walking,
  running,
  cycling,
  swimming;

  double get met {
    switch (this) {
      case ExerciseType.walking:
        return 3.5;
      case ExerciseType.running:
        return 8.0;
      case ExerciseType.cycling:
        return 6.8;
      case ExerciseType.swimming:
        return 7.0;
    }
  }

  String getLocalizedName(bool isTurkish) {
    switch (this) {
      case ExerciseType.walking:
        return isTurkish ? 'Yürüyüş' : 'Walking';
      case ExerciseType.running:
        return isTurkish ? 'Koşu' : 'Running';
      case ExerciseType.cycling:
        return isTurkish ? 'Bisiklet' : 'Cycling';
      case ExerciseType.swimming:
        return isTurkish ? 'Yüzme' : 'Swimming';
    }
  }
}

@immutable
class ExerciseEntry {
  final String id;
  final ExerciseType type;
  final int durationMinutes;
  final double caloriesBurned;
  final DateTime timestamp;

  const ExerciseEntry({
    required this.id,
    required this.type,
    required this.durationMinutes,
    required this.caloriesBurned,
    required this.timestamp,
  });

  // For JSON serialization
  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.index,
    'durationMinutes': durationMinutes,
    'caloriesBurned': caloriesBurned,
    'timestamp': timestamp.toIso8601String(),
  };

  // For JSON deserialization
  factory ExerciseEntry.fromJson(Map<String, dynamic> json) => ExerciseEntry(
    id: json['id'] as String,
    type: ExerciseType.values[json['type'] as int],
    durationMinutes: json['durationMinutes'] as int,
    caloriesBurned: json['caloriesBurned'] as double,
    timestamp: DateTime.parse(json['timestamp'] as String),
  );

  // For creating new entries
  static double calculateCalories({
    required ExerciseType type,
    required int durationMinutes,
    required double weightKg,
  }) {
    return type.met * weightKg * durationMinutes / 60;
  }
}