// Simple Dart analysis script to check for common issues
// Run with: dart check_code.dart

import 'dart:io';

void main() {
  print('Foodie App - Code Analysis');
  print('========================');

  // Check if required files exist
  final requiredFiles = [
    'pubspec.yaml',
    'lib/main.dart',
    'lib/app.dart',
    'lib/l10n/app_en.arb',
    'lib/l10n/app_tr.arb',
    'lib/l10n.yaml',
  ];

  print('\nChecking required files...');
  for (final file in requiredFiles) {
    if (File(file).existsSync()) {
      print('✅ $file');
    } else {
      print('❌ $file - MISSING');
    }
  }

  // Check if directories exist
  final requiredDirs = [
    'lib/features',
    'lib/providers',
    'lib/services',
    'lib/models',
    'lib/widgets',
    'assets/images',
  ];

  print('\nChecking required directories...');
  for (final dir in requiredDirs) {
    if (Directory(dir).existsSync()) {
      print('✅ $dir/');
    } else {
      print('❌ $dir/ - MISSING');
    }
  }

  print('\nAnalysis complete!');
  print('\nNext steps:');
  print('1. Install Flutter SDK');
  print('2. Run: flutter pub get');
  print('3. Run: flutter gen-l10n');
  print('4. Run: flutter run');
}

