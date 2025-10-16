# Foodie Search Feature Setup

## Overview

The Foodie app now includes a comprehensive search feature that allows users to find and add food items to their meals. The search integrates with two APIs:

1. **Spoonacular API** (Primary) - Provides detailed nutrition information
2. **TheMealDB API** (Fallback) - Used for Turkish dishes when Spoonacular returns empty results

## Setup Instructions

### 1. Get Spoonacular API Key

1. Visit [Spoonacular Food API](https://spoonacular.com/food-api)
2. Sign up for a free account
3. Get your API key from the dashboard
4. Update the API key in `lib/config/api_config.dart`:

```dart
static const String spoonacularKey = 'YOUR_ACTUAL_API_KEY_HERE';
```

### 2. API Configuration

The API configuration is centralized in `lib/config/api_config.dart`:

```dart
class ApiConfig {
  static const String spoonacularKey = 'YOUR_SPOONACULAR_API_KEY_HERE';
  static const String spoonacularBaseUrl = 'https://api.spoonacular.com';
  static const String mealDbBaseUrl = 'https://www.themealdb.com/api/json/v1/1';
  static const int debounceDelayMs = 350;
}
```

### 3. Features

#### Search Functionality
- **Debounced search** (350ms delay) to avoid excessive API calls
- **Minimum 2 characters** required to trigger search
- **Turkish character detection** for automatic fallback to MealDB
- **Error handling** with retry functionality

#### UI Features
- **Responsive design** - no overflow warnings in English/Turkish
- **Loading states** with progress indicators
- **Error states** with retry buttons
- **Empty states** with helpful hints
- **Food item cards** showing nutrition information

#### Navigation
- **Meal-specific search** - tapping "+" on meal cards navigates to search with context
- **Auto-focus** search field when navigating from meal cards
- **Return to home** after adding food items

### 4. Data Models

#### FoodItem
```dart
class FoodItem {
  final String id;
  final String name;
  final double calories;    // per serving
  final double protein;     // g
  final double carbs;       // g
  final double fat;         // g
  final String? brand;      // optional
  final String? servingDesc; // e.g., "1 serving (240g)"
}
```

#### MealType
```dart
enum MealType {
  breakfast,
  lunch,
  dinner,
  snacks,
}
```

### 5. API Integration

#### Spoonacular API
- **Search endpoint**: `/food/ingredients/search`
- **Nutrition endpoint**: `/food/ingredients/{id}/information`
- **Rate limit**: 50 requests per minute (free tier)
- **Data**: Full nutrition information (calories, protein, carbs, fat)

#### TheMealDB API
- **Search endpoint**: `/search.php`
- **Rate limit**: No authentication required
- **Data**: Recipe names only (no nutrition data)
- **Usage**: Fallback for Turkish dishes

### 6. Testing

#### Manual Testing Steps

1. **English Search**:
   - Search for "chicken breast"
   - Should return results with nutrition data from Spoonacular

2. **Turkish Search**:
   - Search for "menemen"
   - Should fallback to MealDB and return recipe names

3. **Navigation**:
   - Tap "+" on any meal card
   - Should navigate to search tab with meal context
   - Add a food item and verify it returns to home

4. **Error Handling**:
   - Test with invalid API key
   - Test with no internet connection
   - Verify retry functionality works

### 7. Localization

Search-related strings are localized in:
- `lib/l10n/app_en.arb`
- `lib/l10n/app_tr.arb`

Key strings:
- `searchHint`: "Search foods (e.g., chicken, menemen)"
- `searchNoResults`: "No results found"
- `searchError`: "Couldn't fetch data"
- `searchAdd`: "Add"
- `searchRetry`: "Retry"

### 8. Architecture

#### Services
- `FoodSearchService`: Handles API calls and data normalization
- `SearchProvider`: Manages search state and debouncing
- `HomeProvider`: Extended to handle food items

#### UI Components
- `SearchScreen`: Main search interface
- `FoodItemCard`: Individual food item display
- Navigation callbacks for meal-specific search

### 9. Performance Considerations

- **Debouncing**: Prevents excessive API calls during typing
- **Caching**: Results are stored in provider state
- **Error handling**: Graceful fallback between APIs
- **Responsive design**: No layout overflow issues

### 10. Future Enhancements

- **Offline caching** of search results
- **Favorites** system for frequently used foods
- **Barcode scanning** integration
- **Custom food items** creation
- **Nutrition goals** tracking
- **Meal planning** features

## Troubleshooting

### Common Issues

1. **API Key Not Working**:
   - Verify the key is correctly set in `api_config.dart`
   - Check Spoonacular dashboard for usage limits

2. **No Results for Turkish Queries**:
   - This is expected behavior - MealDB fallback should activate
   - Turkish characters trigger fallback automatically

3. **Search Not Working**:
   - Check internet connection
   - Verify API endpoints are accessible
   - Check console for error messages

4. **Navigation Issues**:
   - Ensure callbacks are properly wired in `app.dart`
   - Check that providers are correctly initialized

The search feature is now fully integrated and ready for use! 🚀
