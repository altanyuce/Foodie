import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/macros.dart';

class StorageService {
  static const String _keyUserData = 'user_data';
  static const String _keyConsumedKcal = 'consumed_kcal';
  static const String _keyBurnedKcal = 'burned_kcal';
  static const String _keyConsumedMacros = 'consumed_macros';
  static const String _keyLanguage = 'language';
  static const String _keyOnboardingCompleted = 'onboarding_completed';

  static Future<void> saveUserData({
    required double heightCm,
    required double weightKg,
    required double dailyTargetKcal,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final userData = {
      'heightCm': heightCm,
      'weightKg': weightKg,
      'dailyTargetKcal': dailyTargetKcal,
    };
    await prefs.setString(_keyUserData, jsonEncode(userData));
  }

  static Future<Map<String, double>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString(_keyUserData);
    if (userDataString != null) {
      final userData = jsonDecode(userDataString) as Map<String, dynamic>;
      return {
        'heightCm': (userData['heightCm'] ?? 0).toDouble(),
        'weightKg': (userData['weightKg'] ?? 0).toDouble(),
        'dailyTargetKcal': (userData['dailyTargetKcal'] ?? 0).toDouble(),
      };
    }
    return null;
  }

  static Future<void> saveConsumedKcal(double kcal) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_keyConsumedKcal, kcal);
  }

  static Future<double> getConsumedKcal() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_keyConsumedKcal) ?? 0.0;
  }

  static Future<void> saveBurnedKcal(double kcal) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_keyBurnedKcal, kcal);
  }

  static Future<double> getBurnedKcal() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_keyBurnedKcal) ?? 0.0;
  }

  static Future<void> saveConsumedMacros(Macros macros) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyConsumedMacros, jsonEncode(macros.toJson()));
  }

  static Future<Macros> getConsumedMacros() async {
    final prefs = await SharedPreferences.getInstance();
    final macrosString = prefs.getString(_keyConsumedMacros);
    if (macrosString != null) {
      final macrosJson = jsonDecode(macrosString) as Map<String, dynamic>;
      return Macros.fromJson(macrosJson);
    }
    return const Macros(protein: 0, carbohydrate: 0, fat: 0);
  }

  static Future<void> saveLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLanguage, languageCode);
  }

  static Future<String> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyLanguage) ?? 'en';
  }

  static Future<void> setOnboardingCompleted(bool completed) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyOnboardingCompleted, completed);
  }

  static Future<bool> isOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyOnboardingCompleted) ?? false;
  }

  static Future<void> resetOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyOnboardingCompleted);
    await prefs.remove(_keyUserData);
  }
}


