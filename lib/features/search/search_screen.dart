import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/search_provider.dart';
import '../../providers/home_provider.dart';
import '../../models/food_item.dart';
import '../../l10n/app_localizations.dart';

class SearchScreen extends StatefulWidget {
  /// Eğer alt barda “Home” sekmesine dönmek için dışarıdan bir callback
  /// geçiriyorsan, buradan çağrılır (örn. bottom-nav index = 0 yap).
  final VoidCallback? onNavigateToHome;

  const SearchScreen({super.key, this.onNavigateToHome});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  void initState() {
    super.initState();
    // Ekrana gelir gelmez arama kutusuna odaklan
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final sp = context.read<SearchProvider>();
      if (!sp.focusNode.hasFocus) {
        sp.focusNode.requestFocus();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    context.read<SearchProvider>().updateLocale(locale);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.grey[50],
      body: Consumer<SearchProvider>(
        builder: (context, searchProvider, _) {
          return Column(
            children: [
              // Header + Search
              Container(
                padding: const EdgeInsets.fromLTRB(16, 50, 16, 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: searchProvider.controller,
                      focusNode: searchProvider.focusNode,
                      autofocus: true,
                      readOnly: false,
                      enabled: true,
                      enableInteractiveSelection: true,
                      canRequestFocus: true,
                      textInputAction: TextInputAction.search,
                      keyboardType: TextInputType.text,
                      onTap: () {
                        if (!searchProvider.focusNode.hasFocus) {
                          searchProvider.focusNode.requestFocus();
                        }
                      },
                      decoration: InputDecoration(
                        hintText: l10n.searchHint,
                        prefixIcon: const Icon(Icons.search, color: Colors.grey),
                        suffixIcon: searchProvider.controller.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, color: Colors.grey),
                                onPressed: () {
                                  searchProvider.clear();
                                  searchProvider.focusNode.requestFocus();
                                  setState(() {});
                                },
                              )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      onChanged: (q) {
                        if (q.trim().length >= 2) {
                          searchProvider.run(q);
                        } else {
                          searchProvider.clearResults();
                        }
                      },
                      onSubmitted: (value) {
                        if (value.trim().length >= 2) {
                          searchProvider.run(value);
                        }
                      },
                    ),

                    // Seçili öğüne ekleme etiketi
                    if (searchProvider.selectedMealType != null) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          'Adding to ${_getMealTypeName(searchProvider.selectedMealType!, l10n)}',
                          style: const TextStyle(
                            color: Colors.green,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Sonuçlar
              Expanded(
                child: _buildSearchResults(context, searchProvider, l10n),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSearchResults(
    BuildContext context,
    SearchProvider searchProvider,
    AppLocalizations l10n,
  ) {
    if (searchProvider.loading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.green),
      );
    }

    if (searchProvider.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              l10n.searchError,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              searchProvider.error!,
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: searchProvider.retry,
              icon: const Icon(Icons.refresh),
              label: Text(l10n.searchRetry),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (searchProvider.controller.text.trim().isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 24),
            Text(
              l10n.searchHint,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    if (searchProvider.results.isEmpty) {
      return Center(
        child: Text(
          l10n.searchNoResults,
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
      );
    }

    return ListView.separated(
      itemCount: searchProvider.results.length,
      separatorBuilder: (_, __) => const Divider(height: 1, thickness: 0.5),
      itemBuilder: (context, index) {
        final item = searchProvider.results[index];
        return _FoodTile(
          item: item,
          onAdd: () => _addFoodItem(context, item),
          l10n: l10n,
        );
      },
    );
  }

  void _addFoodItem(BuildContext context, FoodItem foodItem) {
    final searchProvider = context.read<SearchProvider>();
    final homeProvider = context.read<HomeProvider>();

    if (searchProvider.selectedMealType != null) {
      // Seçili öğüne ekle
      homeProvider.addFoodItem(searchProvider.selectedMealType!, foodItem);

      // Bildirim
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Added ${foodItem.name} to ${_getMealTypeName(searchProvider.selectedMealType!, AppLocalizations.of(context)!)}',
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );

      // Aramayı temizle ve Home'a dön
      searchProvider.clear(resetMealType: true);
      if (widget.onNavigateToHome != null) {
        widget.onNavigateToHome!();
      } else {
        Navigator.of(context).pop();
      }
    } else {
      // Öğün seçilmemişse detay diyalogu göster
      _showFoodItemDetails(context, foodItem);
    }
  }

  void _showFoodItemDetails(BuildContext context, FoodItem foodItem) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(foodItem.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (foodItem.brand != null) ...[
              Text('Brand: ${foodItem.brand}'),
              const SizedBox(height: 8),
            ],
            Text('Serving: ${foodItem.servingDesc ?? '1 serving'}'),
            const SizedBox(height: 8),
            if (foodItem.calories > 0) ...[
              Text('Calories: ${foodItem.calories.round()} kcal'),
              const SizedBox(height: 4),
              Text('Protein: ${foodItem.protein.toStringAsFixed(1)}g'),
              const SizedBox(height: 4),
              Text('Carbs: ${foodItem.carbs.toStringAsFixed(1)}g'),
              const SizedBox(height: 4),
              Text('Fat: ${foodItem.fat.toStringAsFixed(1)}g'),
            ] else ...[
              const Text('Nutrition data not available'),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  String _getMealTypeName(MealType mealType, AppLocalizations l10n) {
    switch (mealType) {
      case MealType.breakfast:
        return l10n.mealsBreakfast;
      case MealType.lunch:
        return l10n.mealsLunch;
      case MealType.dinner:
        return l10n.mealsDinner;
      case MealType.snacks:
        return l10n.mealsSnacks;
    }
  }
}

class _FoodTile extends StatelessWidget {
  const _FoodTile({
    required this.item,
    required this.onAdd,
    required this.l10n,
  });

  final FoodItem item;
  final VoidCallback onAdd;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final status = item.nutritionStatus;
    final isFetching = status == NutritionStatus.fetching;
    final hasNutrition =
        status == NutritionStatus.ready && item.calories > 0;
    final sourceLabel =
        item.source == FoodSource.spoonacular ? "Spoonacular" : "MealDB";

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      onTap: onAdd,
      title: Text(
        item.name,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (item.brand != null) ...[
            const SizedBox(height: 4),
            Text(
              item.brand!,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
          const SizedBox(height: 4),
          Text(
            item.servingDesc ?? "1 serving",
            style: TextStyle(fontSize: 12, color: Colors.grey[500]),
          ),
          const SizedBox(height: 4),
          Text(
            "Source: $sourceLabel",
            style: TextStyle(fontSize: 11, color: Colors.grey[500]),
          ),
          const SizedBox(height: 4),
          if (isFetching) ...[
            Text(
              "Fetching nutrition...",
              style: TextStyle(fontSize: 11, color: Colors.grey[500]),
            ),
          ] else if (hasNutrition) ...[
            Row(
              children: [
                Text(
                  "${item.protein.toStringAsFixed(1)}g protein",
                  style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                ),
                const SizedBox(width: 8),
                Text(
                  "${item.carbs.toStringAsFixed(1)}g carbs",
                  style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                ),
                const SizedBox(width: 8),
                Text(
                  "${item.fat.toStringAsFixed(1)}g fat",
                  style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                ),
              ],
            ),
          ] else ...[
            Text(
              "Nutrition data not available",
              style: TextStyle(fontSize: 11, color: Colors.grey[500]),
            ),
          ],
        ],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            hasNutrition
                ? "${item.calories.round()} kcal"
                : isFetching
                    ? "..."
                    : "No data",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: hasNutrition ? Colors.green : Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              l10n.searchAdd,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
