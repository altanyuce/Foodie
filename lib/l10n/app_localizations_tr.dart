// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'Foodie';

  @override
  String get onbHeight => 'Boy (cm)';

  @override
  String get onbWeight => 'Kilo (kg)';

  @override
  String get onbContinue => 'Devam';

  @override
  String get homeCaloriesConsumed => 'Alınan kalori';

  @override
  String get homeRemaining => 'Kalan';

  @override
  String get homeCaloriesBurned => 'Yakılan kalori';

  @override
  String get homeProtein => 'Protein';

  @override
  String get homeCarbohydrate => 'Karbonhidrat';

  @override
  String get homeFat => 'Yağ';

  @override
  String get mealsBreakfast => 'Kahvaltı';

  @override
  String get mealsLunch => 'Öğle';

  @override
  String get mealsDinner => 'Akşam';

  @override
  String get mealsSnacks => 'Atıştırmalıklar';

  @override
  String get addItemsComingSoon => 'Öğe ekleme yakında';

  @override
  String get addDemoKcal => 'Demo kcal ekle';

  @override
  String get commonComingSoon => 'Çok yakında';

  @override
  String get profileHeight => 'Boy';

  @override
  String get profileWeight => 'Kilo';

  @override
  String get profileEdit => 'Düzenle';

  @override
  String get profileLanguage => 'Dil';

  @override
  String get languageEnglish => 'İngilizce';

  @override
  String get languageTurkish => 'Türkçe';

  @override
  String get profileVersion => 'Sürüm';

  @override
  String get profileResetOnboarding => 'Onboarding’i sıfırla';

  @override
  String get navHome => 'Ana Sayfa';

  @override
  String get navSearch => 'Ara';

  @override
  String get navExercise => 'Egzersiz';

  @override
  String get navProfile => 'Profil';

  @override
  String get searchHint => 'Yiyecek ara (örn. tavuk, menemen)';

  @override
  String get searchNoResults => 'Sonuç bulunamadı';

  @override
  String get searchError => 'Veri alınamadı';

  @override
  String get searchAdd => 'Ekle';

  @override
  String get searchRetry => 'Tekrar dene';

  @override
  String get searchClear => 'Temizle';

  @override
  String searchKcal(Object calories) {
    return '$calories kcal';
  }

  @override
  String get exerciseTracking => 'Egzersiz Takibi';

  @override
  String get caloriesBurned => 'Yakılan Kalori';

  @override
  String get selectExercise => 'Egzersiz Seç';

  @override
  String get minutes => 'Dakika';

  @override
  String get min => 'dk';

  @override
  String get kcal => 'kcal';

  @override
  String get addExercise => 'Egzersiz Ekle';

  @override
  String get resetDay => 'Günü Sıfırla';

  @override
  String get resetDayTitle => 'Egzersiz Verilerini Sıfırla';

  @override
  String get resetDayConfirm =>
      'Bu işlem bugünkü tüm egzersiz kayıtlarını silecek. Emin misiniz?';

  @override
  String get cancel => 'İptal';

  @override
  String get reset => 'Sıfırla';

  @override
  String get noExercisesToday => 'Bugün kaydedilen egzersiz yok';

  @override
  String get addExerciseHint => 'Yukarıdan bir egzersiz ekleyerek başlayın';
}
