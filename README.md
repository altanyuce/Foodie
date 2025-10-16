<<<<<<< HEAD
# Foodie - Bilingual Diet App

A Flutter-based diet tracking app with bilingual support (English/Turkish).

## Features

- **Bilingual Support**: English and Turkish localization
- **Calorie Tracking**: Visual donut chart showing remaining calories
- **Macro Tracking**: Progress bars for protein, carbohydrates, and fat
- **Meal Management**: Add meals for breakfast, lunch, dinner, and snacks
- **User Profile**: Edit height, weight, and language preferences
- **Onboarding**: First-time setup for height and weight

## Getting Started

### Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK (3.0.0 or higher)

### Installation

1. Clone the repository
2. Install Flutter SDK (if not already installed)
3. Install dependencies:
   ```bash
   flutter pub get
   ```

4. Generate localization files:
   ```bash
   flutter gen-l10n
   ```

5. Run the app:
   ```bash
   flutter run
   ```

**Quick Setup (Windows):**
```bash
setup.bat
```

**Quick Setup (Linux/Mac):**
```bash
chmod +x setup.sh
./setup.sh
```

## How to Use

### First Launch
1. Enter your height (cm) and weight (kg)
2. The app will calculate your daily calorie target
3. You'll be taken to the main home screen

### Home Screen
- View your remaining calories in the center donut chart
- See consumed and burned calories on the sides
- Track your macro progress (protein, carbs, fat)
- Add meals by tapping the "+" button on meal rows
- Use the "Add 100 kcal demo" button to test the functionality

### Profile Screen
- Edit your height and weight
- Change language between English and Turkish
- Reset onboarding to go through setup again
- View app version

### Navigation
- **Home**: Main dashboard with calorie and macro tracking
- **Search**: Coming soon
- **Exercise**: Coming soon  
- **Profile**: User settings and preferences

## Technical Details

- **Framework**: Flutter with null-safe Dart
- **State Management**: Provider pattern
- **Localization**: flutter_localizations with intl
- **Persistence**: shared_preferences for user data
- **Theme**: Green/White color scheme, light mode only

## Project Structure

```
lib/
├── main.dart
├── app.dart
├── l10n/                    # Localization files
├── features/                # Feature-based organization
│   ├── home/
│   ├── search/
│   ├── exercise/
│   ├── profile/
│   └── onboarding/
├── models/                  # Data models
├── providers/               # State management
├── services/                # Business logic
└── widgets/                 # Reusable UI components
```

## Assets

Place your logo file at: `assets/images/logo.png` (transparent PNG)

## Development

The app follows Flutter best practices with:
- Clean architecture
- Provider state management
- Responsive design
- Accessibility support
- Smooth animations

## Troubleshooting

### Common Issues

1. **Flutter not found**: Make sure Flutter SDK is installed and added to your PATH
2. **Dependencies not found**: Run `flutter pub get` to install dependencies
3. **Version conflicts**: If you get intl version conflicts, run:
   ```bash
   flutter pub add intl:^0.20.2
   flutter pub get
   ```
4. **Localization errors**: Run `flutter gen-l10n` to generate localization files
5. **Build errors**: Make sure you're using Flutter 3.10.0 or higher

### Development

The app follows Flutter best practices with:
- Clean architecture
- Provider state management
- Responsive design
- Accessibility support
- Smooth animations

## License

This project is for demonstration purposes.
=======
# Foodie
A Flutter-based calorie &amp; nutrition tracker app.
>>>>>>> 5f34ee731cded329bfb166da31e61f5b12c899f7
