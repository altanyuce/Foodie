import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DailyStatsProvider extends ChangeNotifier {
  static const _kBurnedKey = 'daily_burned_kcal';
  static const _kConsumedKey = 'daily_consumed_kcal';

  int _burned = 0;
  int _consumed = 0;

  int get burned => _burned;
  int get consumed => _consumed;

  Future<void> load() async {
    final p = await SharedPreferences.getInstance();
    _burned = p.getInt(_kBurnedKey) ?? 0;
    _consumed = p.getInt(_kConsumedKey) ?? 0;
    notifyListeners();
  }

  Future<void> setBurned(int kcal) async {
    _burned = kcal < 0 ? 0 : kcal;
    final p = await SharedPreferences.getInstance();
    await p.setInt(_kBurnedKey, _burned);
    notifyListeners();
  }

  Future<void> addBurned(int delta) => setBurned(_burned + delta);
  Future<void> subtractBurned(int delta) => setBurned(_burned - delta);

  Future<void> setConsumed(int kcal) async {
    _consumed = kcal < 0 ? 0 : kcal;
    final p = await SharedPreferences.getInstance();
    await p.setInt(_kConsumedKey, _consumed);
    notifyListeners();
  }

  Future<void> resetDay() async {
    final p = await SharedPreferences.getInstance();
    _burned = 0;
    _consumed = 0;
    await p.setInt(_kBurnedKey, 0);
    await p.setInt(_kConsumedKey, 0);
    notifyListeners();
  }
}