#!/bin/bash

echo "Setting up Foodie Flutter App..."
echo

echo "Installing Flutter dependencies..."
flutter pub get
if [ $? -ne 0 ]; then
    echo "Error installing dependencies. Trying to resolve version conflicts..."
    flutter pub add intl:^0.20.2
    flutter pub get
fi

echo
echo "Generating localization files..."
flutter gen-l10n

echo
echo "Setup complete! You can now run the app with:"
echo "flutter run"
echo
