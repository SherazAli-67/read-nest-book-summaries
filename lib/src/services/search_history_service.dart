import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SearchHistoryService {
  static const String _searchHistoryKey = 'search_history';
  static const int _maxHistoryItems = 10;
  static const int _minQueryLength = 2;

  static Future<SharedPreferences> get _prefs async => await SharedPreferences.getInstance();

  /// Add a search query to history
  static Future<void> addSearch(String query) async {
    if (!_isValidQuery(query)) return;

    final prefs = await _prefs;
    List<String> history = await getRecentSearches();
    
    // Remove the query if it already exists (to avoid duplicates)
    history.removeWhere((item) => item.toLowerCase() == query.toLowerCase());
    
    // Add the new query at the beginning
    history.insert(0, query.trim());
    
    // Keep only the most recent items
    if (history.length > _maxHistoryItems) {
      history = history.take(_maxHistoryItems).toList();
    }
    
    // Save to SharedPreferences
    await prefs.setStringList(_searchHistoryKey, history);
  }

  /// Get recent search queries
  static Future<List<String>> getRecentSearches() async {
    final prefs = await _prefs;
    return prefs.getStringList(_searchHistoryKey) ?? [];
  }

  /// Clear all search history
  static Future<void> clearHistory() async {
    final prefs = await _prefs;
    await prefs.remove(_searchHistoryKey);
  }

  /// Check if search history exists
  static Future<bool> hasHistory() async {
    final history = await getRecentSearches();
    return history.isNotEmpty;
  }

  /// Get suggested searches (fallback when no history exists)
  static List<String> getSuggestedSearches() {
    return [
      'Productivity',
      'Motivation', 
      'Leadership',
      'Business',
      'Money',
      'Psychology'
    ];
  }

  /// Validate if a query should be saved
  static bool _isValidQuery(String query) {
    final trimmedQuery = query.trim();
    return trimmedQuery.isNotEmpty && 
           trimmedQuery.length >= _minQueryLength &&
           !_isNumeric(trimmedQuery);
  }

  /// Check if string is purely numeric (avoid saving accidental numeric searches)
  static bool _isNumeric(String str) {
    return double.tryParse(str) != null;
  }
}
