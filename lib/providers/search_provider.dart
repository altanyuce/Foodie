import 'dart:async';
import 'package:flutter/material.dart';
import '../models/food_item.dart';
import '../services/food_search_service.dart';
import '../config/api_config.dart';

class SearchProvider extends ChangeNotifier {
  final FoodSearchService _service;
  final TextEditingController controller = TextEditingController();
  final FocusNode focusNode = FocusNode();

  List<FoodItem> _results = [];
  bool _loading = false;
  String? _error;
  Timer? _debounce;
  Timer? _debounceTimer;
  String _localeCode = 'en';
  String _activeQuery = '';
  String _activeQueryKey = '';
  bool _disposed = false;
  MealType? _selectedMealType;

  SearchProvider(this._service) {
    controller.addListener(_onSearchChanged);
    _service.registerUiTick(() {
      if (!_disposed) notifyListeners();
    });
  }

  // Public getters
  List<FoodItem> get results => _results;
  bool get loading => _loading;
  String? get error => _error;
  bool get hasResults => _results.isNotEmpty;
  bool get hasError => _error != null;

  void updateLocale(Locale locale) {
    final newCode = locale.languageCode.toLowerCase();
    if (_localeCode != newCode) {
      _localeCode = newCode;
      // Re-run search with new locale if there's an active query
      if (_activeQuery.isNotEmpty) {
        run(_activeQuery);
      }
    }
  }

  void _onSearchChanged() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      run(controller.text);
    });
  }

  Future<void> run(String query) async {
    final q = query.trim();
    if (q.length < 2) {
      clearResults();
      return;
    }

    _activeQuery = q;
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final results = await _service.search(q, localeCode: _localeCode);
      
      // Check if search is still relevant
      if (_activeQuery != q || _disposed) return;

      _results = results;
      if (results.isEmpty) {
        _error = _localeCode.toLowerCase() == 'tr'
            ? 'Sonuç bulunamadı. İngilizce aramayı deneyebilirsiniz (örn. \'yumurta\' yerine \'egg\')'
            : 'No results found';
      }
      
    } catch (e) {
      if (_activeQuery != q || _disposed) return;
      _error = _localeCode.toLowerCase() == 'tr'
          ? 'Arama yapılırken bir hata oluştu'
          : 'Error occurred during search';
      _results = [];
    } finally {
      if (_activeQuery == q && !_disposed) {
        _loading = false;
        notifyListeners();
      }
    }
  }

  void clearResults() {
    _debounceTimer?.cancel();
    _results = [];
    _error = null;
    _loading = false;
    _activeQueryKey = '';
    notifyListeners();
  }

  void clear({bool resetMealType = false}) {
    _debounceTimer?.cancel();
    _results = [];
    _error = null;
    _loading = false;
    _activeQueryKey = '';
    controller.clear();
    if (resetMealType) {
      _selectedMealType = null;
    }
    notifyListeners();
  }

  void retry() {
    run(controller.text);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    controller.dispose();
    focusNode.dispose();
    _disposed = true;
    super.dispose();
  }

  // Meal type management
  MealType? get selectedMealType => _selectedMealType;

  void setMealType(MealType? mealType) {
    if (_selectedMealType != mealType) {
      _selectedMealType = mealType;
      notifyListeners();
    }
  }

  void onArrivedFromPlus() {
    _debounceTimer?.cancel();
    _activeQueryKey = '';
    clearResults();
  }
}
