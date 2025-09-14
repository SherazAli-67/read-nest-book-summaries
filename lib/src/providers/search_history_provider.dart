import 'package:flutter/foundation.dart';
import '../services/search_history_service.dart';

class SearchHistoryProvider extends ChangeNotifier {
  List<String> _recentSearches = [];
  bool _isLoading = false;

  List<String> get recentSearches => _recentSearches;
  bool get hasHistory => _recentSearches.isNotEmpty;
  bool get isLoading => _isLoading;

  /// Get searches to display (real history or fallback suggestions)
  List<String> get displaySearches {
    return hasHistory ? _recentSearches : SearchHistoryService.getSuggestedSearches();
  }

  /// Initialize provider and load search history
  SearchHistoryProvider() {
    _loadSearchHistory();
  }

  /// Load search history from storage
  Future<void> _loadSearchHistory() async {
    _isLoading = true;
    notifyListeners();

    try {
      _recentSearches = await SearchHistoryService.getRecentSearches();
    } catch (e) {
      debugPrint('Error loading search history: $e');
      _recentSearches = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Add a search query to history
  Future<void> addSearch(String query) async {
    if (query.trim().isEmpty) return;

    try {
      await SearchHistoryService.addSearch(query);
      await _loadSearchHistory(); // Reload to update UI
    } catch (e) {
      debugPrint('Error adding search to history: $e');
    }
  }

  /// Clear all search history
  Future<void> clearHistory() async {
    try {
      await SearchHistoryService.clearHistory();
      _recentSearches = [];
      notifyListeners();
    } catch (e) {
      debugPrint('Error clearing search history: $e');
    }
  }

  /// Refresh search history from storage
  Future<void> refreshHistory() async {
    await _loadSearchHistory();
  }
}
