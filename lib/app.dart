import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:foodie/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'providers/app_provider.dart';
import 'providers/home_provider.dart';
import 'providers/search_provider.dart';
import 'services/food_search_service.dart';
import 'models/food_item.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/home/home_screen.dart';
import 'features/search/search_screen.dart';
import 'features/exercise/exercise_screen.dart';
import 'features/profile/profile_screen.dart';
import 'providers/daily_stats_provider.dart';

class FoodieApp extends StatelessWidget {
  const FoodieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => SearchProvider(FoodSearchService())),
        ChangeNotifierProvider(create: (_) => DailyStatsProvider()..load()),
      ],
      child: Consumer<AppProvider>(
        builder: (context, appProvider, child) {
          return MaterialApp(
            title: 'Foodie',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.green,
              primaryColor: Colors.green,
              scaffoldBackgroundColor: Colors.grey[50],
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black87,
                elevation: 0,
              ),
              bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                backgroundColor: Colors.white,
                selectedItemColor: Colors.green,
                unselectedItemColor: Colors.grey,
                type: BottomNavigationBarType.fixed,
                elevation: 8,
              ),
            ),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''),
              Locale('tr', ''),
            ],
            locale: Locale(appProvider.language),
            home: const AppInitializer(),
          );
        },
      ),
    );
  }
}

class AppInitializer extends StatefulWidget {
  const AppInitializer({super.key});

  @override
  State<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await context.read<AppProvider>().initialize();
    await context.read<HomeProvider>().initialize();
    setState(() {
      _isInitialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: Colors.green,
          ),
        ),
      );
    }

    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        if (!appProvider.isOnboardingCompleted) {
          return const OnboardingScreen();
        }

        return const MainNavigationScreen();
      },
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  List<Widget> get _screens => [
        HomeScreen(onNavigateToSearch: navigateToSearch),
        SearchScreen(onNavigateToHome: () => setState(() => _currentIndex = 0)),
        const ExerciseScreen(),
        const ProfileScreen(),
      ];

  void navigateToSearch(MealType? mealType) {
    final searchProvider = context.read<SearchProvider>();

    if (mealType != null) {
      searchProvider.setMealType(mealType);
    }

    setState(() {
      _currentIndex = 1; // Switch to Search tab
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      searchProvider.onArrivedFromPlus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: l10n.navHome,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.search),
            label: l10n.navSearch,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.fitness_center),
            label: l10n.navExercise,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: l10n.navProfile,
          ),
        ],
      ),
    );
  }
}
