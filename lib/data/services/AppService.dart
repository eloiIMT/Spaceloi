import 'package:shared_preferences/shared_preferences.dart';

class AppService {
  static const String _favoritesKey = 'favorite_launches';
  static const String _onboardingKey = 'onboarding_completed';

  static Future<bool> hasCompletedOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingKey) ?? false;
  }

  static Future<void> setOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingKey, true);
  }

  static Future<List<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_favoritesKey) ?? [];
  }

  static Future<void> addFavorite(String launchId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavorites();
    if (!favorites.contains(launchId)) {
      favorites.add(launchId);
      await prefs.setStringList(_favoritesKey, favorites);
    }
  }

  static Future<void> removeFavorite(String launchId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavorites();
    favorites.remove(launchId);
    await prefs.setStringList(_favoritesKey, favorites);
  }

  static Future<bool> isFavorite(String launchId) async {
    final favorites = await getFavorites();
    return favorites.contains(launchId);
  }
}