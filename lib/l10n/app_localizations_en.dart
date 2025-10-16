// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Foodie';

  @override
  String get onbHeight => 'Height (cm)';

  @override
  String get onbWeight => 'Weight (kg)';

  @override
  String get onbContinue => 'Continue';

  @override
  String get homeCaloriesConsumed => 'Calories consumed';

  @override
  String get homeRemaining => 'Remaining';

  @override
  String get homeCaloriesBurned => 'Calories burned';

  @override
  String get homeProtein => 'Protein';

  @override
  String get homeCarbohydrate => 'Carbohydrate';

  @override
  String get homeFat => 'Fat';

  @override
  String get mealsBreakfast => 'Breakfast';

  @override
  String get mealsLunch => 'Lunch';

  @override
  String get mealsDinner => 'Dinner';

  @override
  String get mealsSnacks => 'Snacks';

  @override
  String get addItemsComingSoon => 'Adding items is coming soon';

  @override
  String get addDemoKcal => 'Add demo kcal';

  @override
  String get commonComingSoon => 'Coming soon';

  @override
  String get profileHeight => 'Height';

  @override
  String get profileWeight => 'Weight';

  @override
  String get profileEdit => 'Edit';

  @override
  String get profileLanguage => 'Language';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageTurkish => 'Turkish';

  @override
  String get profileVersion => 'Version';

  @override
  String get profileResetOnboarding => 'Reset onboarding';

  @override
  String get navHome => 'Home';

  @override
  String get navSearch => 'Search';

  @override
  String get navExercise => 'Exercise';

  @override
  String get navProfile => 'Profile';

  @override
  String get searchHint => 'Search foods (e.g., chicken, menemen)';

  @override
  String get searchNoResults => 'No results found';

  @override
  String get searchError => 'Couldn\'t fetch data';

  @override
  String get searchAdd => 'Add';

  @override
  String get searchRetry => 'Retry';

  @override
  String get searchClear => 'Clear';

  @override
  String searchKcal(Object calories) {
    return '$calories kcal';
  }

  @override
  String get exerciseTracking => 'Exercise Tracking';

  @override
  String get caloriesBurned => 'Calories Burned';

  @override
  String get selectExercise => 'Select Exercise';

  @override
  String get minutes => 'Minutes';

  @override
  String get min => 'min';

  @override
  String get kcal => 'kcal';

  @override
  String get addExercise => 'Add Exercise';

  @override
  String get resetDay => 'Reset Day';

  @override
  String get resetDayTitle => 'Reset Exercise Data';

  @override
  String get resetDayConfirm =>
      'This will remove all exercise entries for today. Are you sure?';

  @override
  String get cancel => 'Cancel';

  @override
  String get reset => 'Reset';

  @override
  String get noExercisesToday => 'No exercises recorded today';

  @override
  String get addExerciseHint => 'Start by adding an exercise above';
}
