@echo off
echo Setting up Foodie Flutter App...
echo.

echo Installing Flutter dependencies...
flutter pub get
if %errorlevel% neq 0 (
    echo Error installing dependencies. Trying to resolve version conflicts...
    flutter pub add intl:^0.20.2
    flutter pub get
)

echo.
echo Generating localization files...
flutter gen-l10n

echo.
echo Setup complete! You can now run the app with:
echo flutter run
echo.
pause
