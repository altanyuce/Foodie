import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../models/exercise_entry.dart';

class ExerciseService {
  static const _keyEntries = 'exercise_entries';
  static const _keyUserWeight = 'user_weight_kg';
  static final _uuid = Uuid();

  // Cached entries
  List<ExerciseEntry>? _cachedEntries;
  
  // User weight in kg (default: 70kg)
  Future<double> getUserWeight() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_keyUserWeight) ?? 70.0;
  }

  Future<void> setUserWeight(double weightKg) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_keyUserWeight, weightKg);
  }

  // Add a new exercise entry
  Future<ExerciseEntry> addEntry({
    required ExerciseType type,
    required int durationMinutes,
  }) async {
    final weight = await getUserWeight();
    
    final entry = ExerciseEntry(
      id: _uuid.v4(),
      type: type,
      durationMinutes: durationMinutes,
      caloriesBurned: ExerciseEntry.calculateCalories(
        type: type,
        durationMinutes: durationMinutes,
        weightKg: weight,
      ),
      timestamp: DateTime.now(),
    );

    final entries = await _loadEntries();
    entries.add(entry);
    await _saveEntries(entries);
    
    return entry;
  }

  // Get all entries for a specific date
  Future<List<ExerciseEntry>> getEntriesForDate(DateTime date) async {
    final entries = await _loadEntries();
    
    return entries.where((e) {
      final entryDate = e.timestamp;
      return entryDate.year == date.year &&
             entryDate.month == date.month &&
             entryDate.day == date.day;
    }).toList();
  }

  // Get total calories burned for a specific date
  Future<double> getTotalCaloriesForDate(DateTime date) async {
    final entries = await getEntriesForDate(date);
    return entries.fold<double>(0.0, (sum, entry) => sum + entry.caloriesBurned);
  }

  // Reset all entries for a specific date
  Future<void> resetDate(DateTime date) async {
    final entries = await _loadEntries();
    
    entries.removeWhere((e) {
      final entryDate = e.timestamp;
      return entryDate.year == date.year &&
             entryDate.month == date.month &&
             entryDate.day == date.day;
    });
    
    await _saveEntries(entries);
    _cachedEntries = null;
  }

  // Load entries from SharedPreferences
  Future<List<ExerciseEntry>> _loadEntries() async {
    if (_cachedEntries != null) return List.from(_cachedEntries!);
    
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_keyEntries);
    
    if (jsonStr == null) return [];
    
    try {
      final jsonList = jsonDecode(jsonStr) as List;
      _cachedEntries = jsonList
          .map((json) => ExerciseEntry.fromJson(json))
          .toList();
      return List.from(_cachedEntries!);
    } catch (e) {
      return [];
    }
  }

  // Save entries to SharedPreferences
  Future<void> _saveEntries(List<ExerciseEntry> entries) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = entries.map((e) => e.toJson()).toList();
    await prefs.setString(_keyEntries, jsonEncode(jsonList));
    _cachedEntries = List.from(entries);
  }

  // Delete a specific entry
  Future<void> deleteEntry(String id) async {
    final entries = await _loadEntries();
    entries.removeWhere((e) => e.id == id);
    await _saveEntries(entries);
  }

  // Clear cache (useful when app goes to background)
  void clearCache() {
    _cachedEntries = null;
  }
}