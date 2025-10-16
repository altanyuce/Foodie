import 'dart:async';
import 'dart:convert';
import 'dart:developer' as dev;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/food_item.dart';

// Turkish → English translation helpers
class _TrDict {
  static const hints = {
    // Basic ingredients
    'yumurta': 'egg',
    'elma': 'apple',
    'muz': 'banana',
    'çilek': 'strawberry',
    'portakal': 'orange',
    'domates': 'tomato',
    'salatalık': 'cucumber',
    'biber': 'pepper',
    'patates': 'potato',
    'soğan': 'onion',
    'sarımsak': 'garlic',
    'havuç': 'carrot',
    'ıspanak': 'spinach',
    'pirinç': 'rice',
    'ekmek': 'bread',
    'peynir': 'cheese',
    'yoğurt': 'yogurt',
    'süt': 'milk',
    'tavuk': 'chicken',
    'et': 'meat',
    'balık': 'fish',
    'nohut': 'chickpea',
    'mercimek': 'lentil',
    'fasulye': 'beans',

    // ASCII variants
    'cilek': 'strawberry',
    'salatalik': 'cucumber',
    'sogan': 'onion',
    'sarimsak': 'garlic',
    'havuc': 'carrot',
    'ispanak': 'spinach',
    'pirinc': 'rice',
    'yogurt': 'yogurt',
    'sut': 'milk',
    'balik': 'fish',
  };

  static String normalize(String s) {
    return s.trim().toLowerCase()
      .replaceAll('ö', 'o')
      .replaceAll('ü', 'u')
      .replaceAll('ğ', 'g')
      .replaceAll('ş', 's')
      .replaceAll('ı', 'i')
      .replaceAll('ç', 'c');
  }

  static String? getBaseWord(String word) {
    if (word.endsWith('lar') || word.endsWith('ler')) {
      return word.substring(0, word.length - 3);
    }
    return null;
  }

  static String translate(String query, {String? languageCode}) {
    if ((languageCode ?? '').toLowerCase() != 'tr') return query;

    final normalized = normalize(query);
    
    // Try exact match
    if (hints.containsKey(normalized)) {
      return hints[normalized]!;
    }

    // Try base word (remove plural suffix)
    final baseWord = getBaseWord(normalized);
    if (baseWord != null && hints.containsKey(baseWord)) {
      return hints[baseWord]! + 's'; // Add English plural
    }

    // Try word by word for compounds
    final words = normalized.split(RegExp(r'\s+')).where((w) => w.isNotEmpty);
    if (words.length > 1) {
      final translated = words.map((word) {
        final base = getBaseWord(word);
        return hints[word] ?? (base != null ? hints[base] : null) ?? word;
      }).toList();
      return translated.join(' ');
    }

    return query;
  }
}

class FoodSearchService {
  static const _spoonBase = 'https://api.spoonacular.com';
  static const _mealDB = 'https://www.themealdb.com/api/json/v1/1/search.php?s=';
  static const _off = 'https://world.openfoodfacts.org/cgi/search.pl';

  static const _spoonKey = String.fromEnvironment(
    'SPOONACULAR_KEY',
    defaultValue: 'e79b1d384c044462aaebf165b7eeef44',
  );

  final _cache = <String, List<FoodItem>>{};
  DateTime? _blockedUntil;
  VoidCallback? _touchUI;

  void registerUiTick(VoidCallback cb) => _touchUI = cb;

  // Note: Translation logic moved to _TrDict class

  Future<List<FoodItem>> search(String rawQuery, {String? localeCode}) async {
    final q = rawQuery.trim();
    if (q.length < 2) return [];

    // Check cache first (using original query)
    final cached = await _getFromCache(q);
    if (cached != null) return cached;

    // Translate query if needed
    final qForApi = _TrDict.translate(q, languageCode: localeCode);
    final normalizedQuery = _TrDict.normalize(q);

    List<FoodItem> items = [];

    // Try Spoonacular with translated query
    if (!await _isSpoonBlocked()) {
      items = await _spoonComplex(qForApi);
      if (items.isNotEmpty) {
        await _putCache(q, items); // Cache with original query
        return items;
      }

      // If translated query gave no results and was different, try original
      if (qForApi != normalizedQuery) {
        items = await _spoonComplex(normalizedQuery);
        if (items.isNotEmpty) {
          await _putCache(q, items);
          return items;
        }
      }
    }

    // Fallback to MealDB - try both translated and original
    items = await _mealDbSearch(qForApi);
    if (items.isEmpty && qForApi != normalizedQuery) {
      items = await _mealDbSearch(normalizedQuery);
    }

    if (items.isNotEmpty) {
      // Enrich with nutrition data in background
      unawaited(_enrichWithOFF(items).then((_) => _touchUI?.call()));
      await _putCache(q, items);
    }

    return items;
  }

  Future<List<FoodItem>> _spoonComplex(String q) async {
    try {
      final uri = Uri.parse('$_spoonBase/recipes/complexSearch').replace(queryParameters: {
        if (q.isNotEmpty) 'query': q,
        'number': '20',
        'addRecipeNutrition': 'true',
        'instructionsRequired': 'false',
        'apiKey': _spoonKey,
      });

      final r = await http.get(uri).timeout(const Duration(seconds: 10));
      
      if (r.statusCode == 402 || r.statusCode == 429) {
        await _blockSpoonUntilMidnight();
        return [];
      }
      
      if (r.statusCode != 200) {
        dev.log('Spoonacular error ${r.statusCode}: ${_truncateBody(r.body)}');
        return [];
      }

      final data = jsonDecode(r.body) as Map<String, dynamic>;
      final results = (data['results'] as List?) ?? [];
      
      return results.map<FoodItem>((m) {
        final nuts = ((m['nutrition'] ?? {})['nutrients'] as List?) ?? [];
        
        double getN(String name) {
          final n = nuts.firstWhere(
            (x) => ((x['name'] ?? '') as String).toLowerCase() == name.toLowerCase(),
            orElse: () => {'amount': 0},
          );
          return (n['amount'] as num?)?.toDouble() ?? 0;
        }

        return FoodItem(
          id: (m['id'] ?? '').toString(),
          name: (m['title'] ?? '').toString(),
          source: FoodSource.spoonacular,
          servingDesc: '1 serving',
          calories: getN('Calories'),
          protein: getN('Protein'),
          carbs: getN('Carbohydrates'),
          fat: getN('Fat'),
          nutritionStatus: NutritionStatus.ready,
        );
      }).toList();

    } catch (e) {
      dev.log('Spoonacular error: $e');
      return [];
    }
  }

  Future<bool> _isSpoonBlocked() async {
    if (_blockedUntil != null && _blockedUntil!.isAfter(DateTime.now())) {
      return true;
    }
    final prefs = await SharedPreferences.getInstance();
    final blocked = prefs.getString('spoon_blocked_until');
    if (blocked == null) return false;

    final until = DateTime.tryParse(blocked);
    if (until == null) return false;

    if (until.isAfter(DateTime.now())) {
      _blockedUntil = until;
      return true;
    }
    
    await prefs.remove('spoon_blocked_until');
    return false;
  }

  Future<void> _blockSpoonUntilMidnight() async {
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day).add(const Duration(days: 1));
    _blockedUntil = midnight;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('spoon_blocked_until', midnight.toIso8601String());
    
    dev.log('Spoonacular blocked until ${midnight.toIso8601String()}');
  }

  Future<List<FoodItem>> _mealDbSearch(String q) async {
    try {
      final uri = Uri.parse('$_mealDB${Uri.encodeComponent(q)}');
      final r = await http.get(uri).timeout(const Duration(seconds: 10));
      
      if (r.statusCode != 200) {
        dev.log('MealDB error ${r.statusCode}: ${_truncateBody(r.body)}');
        return [];
      }

      final data = jsonDecode(r.body) as Map<String, dynamic>;
      final meals = (data['meals'] as List?) ?? [];
      
      return meals.map((m) => FoodItem(
        id: (m['idMeal'] ?? '').toString(),
        name: (m['strMeal'] ?? '').toString(),
        source: FoodSource.mealdb,
        servingDesc: '1 serving',
        nutritionStatus: NutritionStatus.fetching,
      )).toList();

    } catch (e) {
      dev.log('MealDB error: $e');
      return [];
    }
  }

  Future<void> _enrichWithOFF(List<FoodItem> items) async {
    for (final it in items.where((x) => x.nutritionStatus == NutritionStatus.fetching)) {
      try {
        await Future.delayed(const Duration(milliseconds: 180)); // throttle

        final uri = Uri.parse(_off).replace(queryParameters: {
          'search_terms': it.name,
          'search_simple': '1',
          'action': 'process',
          'json': '1',
          'page_size': '1',
        });

        final r = await http.get(uri).timeout(const Duration(seconds: 10));
        if (r.statusCode != 200) {
          dev.log('OFF error ${r.statusCode}: ${_truncateBody(r.body)}');
          it.nutritionStatus = NutritionStatus.none;
          continue;
        }

        final json = jsonDecode(r.body) as Map<String, dynamic>;
        final prods = (json['products'] as List?) ?? [];
        if (prods.isEmpty) {
          it.nutritionStatus = NutritionStatus.none;
          continue;
        }

        final n = (prods.first['nutriments'] ?? {}) as Map<String, dynamic>;
        double _d(Object? v) => v is num ? v.toDouble() : 0.0;

        it.calories = _d(n['energy-kcal_100g'] ?? n['energy-kcal_serving'] ?? 0);
        it.protein = _d(n['proteins_100g'] ?? n['proteins_serving'] ?? 0);
        it.carbs = _d(n['carbohydrates_100g'] ?? n['carbohydrates_serving'] ?? 0);
        it.fat = _d(n['fat_100g'] ?? n['fat_serving'] ?? 0);
        
        it.nutritionStatus = (it.calories + it.protein + it.carbs + it.fat) > 0
            ? NutritionStatus.ready
            : NutritionStatus.none;

      } catch (e) {
        dev.log('OFF enrichment error: $e');
        it.nutritionStatus = NutritionStatus.none;
      }
    }
  }

  Future<List<FoodItem>?> _getFromCache(String q) async {
    final key = q.toLowerCase();
    if (_cache.containsKey(key)) return List.from(_cache[key]!);

    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('cache_$key');
    final ts = prefs.getInt('cache_${key}_ts') ?? 0;
    
    if (raw == null) return null;

    if (DateTime.now().millisecondsSinceEpoch - ts > const Duration(hours: 24).inMilliseconds) {
      await prefs.remove('cache_$key');
      await prefs.remove('cache_${key}_ts');
      return null;
    }

    final list = (jsonDecode(raw) as List)
        .map((e) => FoodItem.fromJson(e as Map<String, dynamic>))
        .toList();
    
    _cache[key] = list;
    return List.from(list);
  }

  Future<void> _putCache(String q, List<FoodItem> items) async {
    final key = q.toLowerCase();
    _cache[key] = List.from(items);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('cache_$key', jsonEncode(items.map((e) => e.toJson()).toList()));
    await prefs.setInt('cache_${key}_ts', DateTime.now().millisecondsSinceEpoch);
  }

  String _truncateBody(String body) {
    return body.length > 300 ? '${body.substring(0, 300)}...' : body;
  }
}

typedef VoidCallback = void Function();