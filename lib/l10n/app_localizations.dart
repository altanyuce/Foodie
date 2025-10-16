import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('tr')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Foodie'**
  String get appTitle;

  /// No description provided for @onbHeight.
  ///
  /// In en, this message translates to:
  /// **'Height (cm)'**
  String get onbHeight;

  /// No description provided for @onbWeight.
  ///
  /// In en, this message translates to:
  /// **'Weight (kg)'**
  String get onbWeight;

  /// No description provided for @onbContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get onbContinue;

  /// No description provided for @homeCaloriesConsumed.
  ///
  /// In en, this message translates to:
  /// **'Calories consumed'**
  String get homeCaloriesConsumed;

  /// No description provided for @homeRemaining.
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get homeRemaining;

  /// No description provided for @homeCaloriesBurned.
  ///
  /// In en, this message translates to:
  /// **'Calories burned'**
  String get homeCaloriesBurned;

  /// No description provided for @homeProtein.
  ///
  /// In en, this message translates to:
  /// **'Protein'**
  String get homeProtein;

  /// No description provided for @homeCarbohydrate.
  ///
  /// In en, this message translates to:
  /// **'Carbohydrate'**
  String get homeCarbohydrate;

  /// No description provided for @homeFat.
  ///
  /// In en, this message translates to:
  /// **'Fat'**
  String get homeFat;

  /// No description provided for @mealsBreakfast.
  ///
  /// In en, this message translates to:
  /// **'Breakfast'**
  String get mealsBreakfast;

  /// No description provided for @mealsLunch.
  ///
  /// In en, this message translates to:
  /// **'Lunch'**
  String get mealsLunch;

  /// No description provided for @mealsDinner.
  ///
  /// In en, this message translates to:
  /// **'Dinner'**
  String get mealsDinner;

  /// No description provided for @mealsSnacks.
  ///
  /// In en, this message translates to:
  /// **'Snacks'**
  String get mealsSnacks;

  /// No description provided for @addItemsComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Adding items is coming soon'**
  String get addItemsComingSoon;

  /// No description provided for @addDemoKcal.
  ///
  /// In en, this message translates to:
  /// **'Add demo kcal'**
  String get addDemoKcal;

  /// No description provided for @commonComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get commonComingSoon;

  /// No description provided for @profileHeight.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get profileHeight;

  /// No description provided for @profileWeight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get profileWeight;

  /// No description provided for @profileEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get profileEdit;

  /// No description provided for @profileLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get profileLanguage;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageTurkish.
  ///
  /// In en, this message translates to:
  /// **'Turkish'**
  String get languageTurkish;

  /// No description provided for @profileVersion.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get profileVersion;

  /// No description provided for @profileResetOnboarding.
  ///
  /// In en, this message translates to:
  /// **'Reset onboarding'**
  String get profileResetOnboarding;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get navSearch;

  /// No description provided for @navExercise.
  ///
  /// In en, this message translates to:
  /// **'Exercise'**
  String get navExercise;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search foods (e.g., chicken, menemen)'**
  String get searchHint;

  /// No description provided for @searchNoResults.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get searchNoResults;

  /// No description provided for @searchError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t fetch data'**
  String get searchError;

  /// No description provided for @searchAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get searchAdd;

  /// No description provided for @searchRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get searchRetry;

  /// No description provided for @searchClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get searchClear;

  /// No description provided for @searchKcal.
  ///
  /// In en, this message translates to:
  /// **'{calories} kcal'**
  String searchKcal(Object calories);

  /// No description provided for @exerciseTracking.
  ///
  /// In en, this message translates to:
  /// **'Exercise Tracking'**
  String get exerciseTracking;

  /// No description provided for @caloriesBurned.
  ///
  /// In en, this message translates to:
  /// **'Calories Burned'**
  String get caloriesBurned;

  /// No description provided for @selectExercise.
  ///
  /// In en, this message translates to:
  /// **'Select Exercise'**
  String get selectExercise;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'Minutes'**
  String get minutes;

  /// No description provided for @min.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get min;

  /// No description provided for @kcal.
  ///
  /// In en, this message translates to:
  /// **'kcal'**
  String get kcal;

  /// No description provided for @addExercise.
  ///
  /// In en, this message translates to:
  /// **'Add Exercise'**
  String get addExercise;

  /// No description provided for @resetDay.
  ///
  /// In en, this message translates to:
  /// **'Reset Day'**
  String get resetDay;

  /// No description provided for @resetDayTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset Exercise Data'**
  String get resetDayTitle;

  /// No description provided for @resetDayConfirm.
  ///
  /// In en, this message translates to:
  /// **'This will remove all exercise entries for today. Are you sure?'**
  String get resetDayConfirm;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @noExercisesToday.
  ///
  /// In en, this message translates to:
  /// **'No exercises recorded today'**
  String get noExercisesToday;

  /// No description provided for @addExerciseHint.
  ///
  /// In en, this message translates to:
  /// **'Start by adding an exercise above'**
  String get addExerciseHint;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
