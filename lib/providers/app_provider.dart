import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class AppProvider extends ChangeNotifier {
  String _language = 'en';
  bool _isOnboardingCompleted = false;

  String get language => _language;
  bool get isOnboardingCompleted => _isOnboardingCompleted;

  Future<void> initialize() async {
    _language = await StorageService.getLanguage();
    _isOnboardingCompleted = await StorageService.isOnboardingCompleted();
    notifyListeners();
  }

  Future<void> setLanguage(String languageCode) async {
    _language = languageCode;
    await StorageService.saveLanguage(languageCode);
    notifyListeners();
  }

  Future<void> setOnboardingCompleted() async {
    _isOnboardingCompleted = true;
    await StorageService.setOnboardingCompleted(true);
    notifyListeners();
  }

  Future<void> resetOnboarding() async {
    _isOnboardingCompleted = false;
    await StorageService.resetOnboarding();
    notifyListeners();
  }
}


