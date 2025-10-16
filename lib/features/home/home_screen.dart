import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/home_provider.dart';
import '../../providers/daily_stats_provider.dart';
import '../../widgets/donut_calories.dart';
import '../../widgets/macro_bar.dart';
import '../../widgets/meal_row.dart';
import '../../models/food_item.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/search_provider.dart';
import '../search/search_screen.dart';

class HomeScreen extends StatelessWidget {
  final Function(MealType)? onNavigateToSearch;

  const HomeScreen({super.key, this.onNavigateToSearch});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final stats = Provider.of<DailyStatsProvider>(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Consumer<HomeProvider>(
        builder: (context, homeProvider, child) {
          // Sync consumed calories with DailyStatsProvider
          WidgetsBinding.instance.addPostFrameCallback((_) {
            stats.setConsumed(homeProvider.consumedKcal.round());
          });
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Logo placeholder
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: const Icon(
                    Icons.restaurant,
                    size: 40,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 32),
                // Calorie tracking section
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Donut chart with consumed/burned labels
                      Consumer<DailyStatsProvider>(
                        builder: (context, stats, _) {
                          return DonutCalories(
                            radius: 80,
                            consumed: homeProvider.consumedKcal,
                            burned: stats.burned.toDouble(),
                            target: homeProvider.targetKcal,
                            remainingText: l10n.homeRemaining,
                            leftLabel: l10n.homeCaloriesConsumed,
                            rightLabel: l10n.homeCaloriesBurned,
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Macro bars
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      MacroBar(
                        label: l10n.homeProtein,
                        current: homeProvider.consumedMacros.protein,
                        target: homeProvider.targetMacros.protein,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 16),
                      MacroBar(
                        label: l10n.homeCarbohydrate,
                        current: homeProvider.consumedMacros.carbohydrate,
                        target: homeProvider.targetMacros.carbohydrate,
                        color: Colors.orange,
                      ),
                      const SizedBox(height: 16),
                      MacroBar(
                        label: l10n.homeFat,
                        current: homeProvider.consumedMacros.fat,
                        target: homeProvider.targetMacros.fat,
                        color: Colors.blue,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Meal rows
                MealRow(
                  icon: Icons.free_breakfast,
                  title: l10n.mealsBreakfast,
                  onAdd: () => _handleAddMeal(context, MealType.breakfast),
                ),
                MealRow(
                  icon: Icons.lunch_dining,
                  title: l10n.mealsLunch,
                  onAdd: () => _handleAddMeal(context, MealType.lunch),
                ),
                MealRow(
                  icon: Icons.dinner_dining,
                  title: l10n.mealsDinner,
                  onAdd: () => _handleAddMeal(context, MealType.dinner),
                ),
                MealRow(
                  icon: Icons.cookie,
                  title: l10n.mealsSnacks,
                  onAdd: () => _handleAddMeal(context, MealType.snacks),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  void _handleAddMeal(BuildContext context, MealType mealType) {
    final searchProvider = context.read<SearchProvider>();
    searchProvider.setMealType(mealType);

    if (onNavigateToSearch != null) {
      onNavigateToSearch!(mealType);
      searchProvider.onArrivedFromPlus();
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const SearchScreen(),
        ),
      );
    }
  }
}
