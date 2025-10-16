import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../models/exercise_entry.dart';
import '../../services/exercise_service.dart';
import '../../widgets/empty_state.dart';
import '../../providers/daily_stats_provider.dart';

class ExerciseScreen extends StatefulWidget {
  const ExerciseScreen({super.key});

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  final _exerciseService = ExerciseService();
  final _durationController = TextEditingController();
  
  DateTime _selectedDate = DateTime.now();
  ExerciseType? _selectedType;
  List<ExerciseEntry>? _todayEntries;
  double _todayCalories = 0;
  
  static const _targetCalories = 300.0; // Default daily target

  @override
  void initState() {
    super.initState();
    _loadTodayData();
  }

  @override
  void dispose() {
    _durationController.dispose();
    super.dispose();
  }

  Future<void> _loadTodayData() async {
    final entries = await _exerciseService.getEntriesForDate(_selectedDate);
    final calories = await _exerciseService.getTotalCaloriesForDate(_selectedDate);
    
    if (mounted) {
      setState(() {
        _todayEntries = entries;
        _todayCalories = calories;
      });
    }
  }

  Future<void> _addExercise() async {
    if (_selectedType == null) return;
    
    final duration = int.tryParse(_durationController.text);
    if (duration == null || duration <= 0) return;

    await _exerciseService.addEntry(
      type: _selectedType!,
      durationMinutes: duration,
    );

    if (mounted) {
      _durationController.clear();
      setState(() => _selectedType = null);
      await _loadTodayData();
      
      // Update the global burned calories
      if (mounted) {
        final totalBurned = await _exerciseService.getTotalCaloriesForDate(DateTime.now());
        await context.read<DailyStatsProvider>().setBurned(totalBurned.round());
      }
    }
  }

  Future<void> _resetDay() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return AlertDialog(
          title: Text(l10n.resetDayTitle),
          content: Text(l10n.resetDayConfirm),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(l10n.reset),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await _exerciseService.resetDate(_selectedDate);
      await _loadTodayData();
      await context.read<DailyStatsProvider>().resetDay(); // Reset global stats
    }
  }

  Future<void> _deleteEntry(String id) async {
    await _exerciseService.deleteEntry(id);
    await _loadTodayData();
    
    // Notify HomeProvider of the change
    if (mounted) {
      // Update burned calories in global stats
      final totalBurned = await _exerciseService.getTotalCaloriesForDate(DateTime.now());
      await context.read<DailyStatsProvider>().setBurned(totalBurned.round());
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isTurkish = Localizations.localeOf(context).languageCode == 'tr';
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.exerciseTracking),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetDay,
            tooltip: l10n.resetDay,
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress circle
          Padding(
            padding: const EdgeInsets.all(16),
            child: CircularPercentIndicator(
              radius: 100.0,
              lineWidth: 12.0,
              percent: (_todayCalories / _targetCalories).clamp(0.0, 1.0),
              progressColor: Theme.of(context).primaryColor,
              backgroundColor: Theme.of(context).dividerColor,
              circularStrokeCap: CircularStrokeCap.round,
              center: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _todayCalories.toStringAsFixed(0),
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text(
                    l10n.caloriesBurned,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),

          // Exercise type selector
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<ExerciseType>(
                    value: _selectedType,
                    hint: Text(l10n.selectExercise),
                    items: ExerciseType.values.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(type.getLocalizedName(isTurkish)),
                      );
                    }).toList(),
                    onChanged: (type) => setState(() => _selectedType = type),
                  ),
                ),
                const SizedBox(width: 16),
                SizedBox(
                  width: 100,
                  child: TextField(
                    controller: _durationController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: l10n.minutes,
                      suffixText: l10n.min,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.add_circle),
                  onPressed: _selectedType == null ? null : _addExercise,
                  tooltip: l10n.addExercise,
                ),
              ],
            ),
          ),

          const Divider(height: 32),

          // Exercise list
          Expanded(
            child: _todayEntries == null
                ? const Center(child: CircularProgressIndicator())
                : _todayEntries!.isEmpty
                    ? EmptyState(
                        icon: Icons.directions_run,
                        title: l10n.noExercisesToday,
                        subtitle: l10n.addExerciseHint,
                      )
                    : ListView.builder(
                        itemCount: _todayEntries!.length,
                        itemBuilder: (context, index) {
                          final entry = _todayEntries![index];
                          return ListTile(
                            leading: const Icon(Icons.fitness_center),
                            title: Text(entry.type.getLocalizedName(isTurkish)),
                            subtitle: Text(
                              '${entry.durationMinutes} ${l10n.min} • ${entry.caloriesBurned.toStringAsFixed(0)} ${l10n.kcal}',
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () => _deleteEntry(entry.id),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}


