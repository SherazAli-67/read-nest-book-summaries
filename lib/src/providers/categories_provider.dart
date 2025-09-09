import 'package:flutter/material.dart';
import '../models/category_model.dart';
import '../services/categories_service.dart';
import '../services/cache_service.dart';

class CategoriesProvider extends ChangeNotifier {
  List<Category> _categories = [];
  bool _isLoadingCategories = false;
  bool _isRefreshingCategories = false;
  bool _hasCategoriesCache = false;
  String? _categoriesError;

  // Getters
  List<Category> get categories => _categories;
  bool get isLoadingCategories => _isLoadingCategories;
  bool get isRefreshingCategories => _isRefreshingCategories;
  bool get hasCategoriesCache => _hasCategoriesCache;
  String? get categoriesError => _categoriesError;

  // Fetch categories with smart caching
  Future<void> fetchCategories({bool forceRefresh = false}) async {
    _categoriesError = null;

    // Check for cached data first (if not forcing refresh)
    if (!forceRefresh) {
      final hasFreshCache = await CacheService.hasFreshCategoriesCache();
      if (hasFreshCache) {
        await _loadCategoriesFromCache();
        // Background refresh if online
        if (await CacheService.isOnline()) {
          _refreshCategoriesInBackground();
        }
        return;
      }
    }

    // Check if we have any cached data to show while loading
    final cachedCategories = await CacheService.getCachedCategories();
    if (cachedCategories != null && !forceRefresh) {
      await _loadCategoriesFromCache();
      _hasCategoriesCache = true;
      notifyListeners();
    }

    _isLoadingCategories = true;
    if (!_hasCategoriesCache) {
      notifyListeners(); // Only notify if we don't have cached data to show
    }

    try {
      debugPrint("Starting fetchCategories...");
      
      _categories = await CategoriesService.getAllCategories();

      // Cache the new data
      await CacheService.cacheCategories(_categories);

      debugPrint("Categories cached successfully");
      
    } catch (e) {
      debugPrint("Error in fetchCategories: $e");
      _categoriesError = e.toString();
      
      // If we have cached data and there's an error, keep showing cached data
      if (_hasCategoriesCache) {
        _categoriesError = null; // Don't show error if we have cached data
        debugPrint("Error occurred but showing cached categories data");
      }
    } finally {
      _isLoadingCategories = false;
      _isRefreshingCategories = false;
      notifyListeners();
    }
  }

  // Load categories from cache
  Future<void> _loadCategoriesFromCache() async {
    final cachedCategories = await CacheService.getCachedCategories();
    if (cachedCategories != null) {
      _categories = cachedCategories;
      _hasCategoriesCache = true;
      debugPrint("Categories loaded from cache: ${_categories.length}");
    }
  }

  // Refresh categories in background without showing loading
  void _refreshCategoriesInBackground() async {
    if (_isRefreshingCategories) return;
    
    _isRefreshingCategories = true;
    try {
      debugPrint("Background categories refresh started...");
      
      _categories = await CategoriesService.getAllCategories();

      // Cache the refreshed data
      await CacheService.cacheCategories(_categories);

      debugPrint("Background categories refresh completed");
      notifyListeners();
      
    } catch (e) {
      debugPrint("Background categories refresh error: $e");
      // Don't update error state for background refresh failures
    } finally {
      _isRefreshingCategories = false;
    }
  }

  // Refresh categories data (for pull-to-refresh)
  Future<void> refreshCategories() async {
    await fetchCategories(forceRefresh: true);
  }

  // Search categories
  Future<List<Category>> searchCategories(String searchTerm) async {
    try {
      return await CategoriesService.searchCategories(searchTerm);
    } catch (e) {
      debugPrint("Error searching categories: $e");
      return [];
    }
  }

  // Get category by ID
  Future<Category?> getCategoryById(String id) async {
    try {
      return await CategoriesService.getCategoryById(id);
    } catch (e) {
      debugPrint("Error getting category by ID: $e");
      return null;
    }
  }

  // Clear categories error
  void clearCategoriesError() {
    _categoriesError = null;
    notifyListeners();
  }

  // Calculate grid height based on number of categories
  double calculateCategoriesGridHeight(int itemCount) {
    if (itemCount == 0) return 100; // Minimum height for empty state
    
    const double itemHeight = 80.0; // Height per item
    const double spacing = 10.0; // Spacing between items
    const double headerHeight = 30.0; // Section header height
    
    int rows = (itemCount / 2).ceil(); // 2 columns
    double gridHeight = (rows * itemHeight) + ((rows - 1) * spacing);
    
    return headerHeight + gridHeight + 20; // Extra padding
  }
}
