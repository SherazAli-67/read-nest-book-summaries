import 'package:flutter/material.dart';
import '../models/book_model.dart';
import '../models/author_spotlight_model.dart';
import '../services/books_service.dart';
import '../services/cache_service.dart';

class BooksProvider extends ChangeNotifier {
  List<Book> _trendingBooks = [];
  List<Book> _quickReads = [];
  List<Book> _popularBusinessBooks = [];
  List<Book> _recentlyAddedBooks = [];
  List<Book> _relatedBooks = [];
  List<AuthorSpotlight> _authorsSpotlight = [];

  bool _isLoading = false;
  bool _isLoadingRelated = false;
  bool _isRefreshing = false;
  bool _hasCache = false;
  String? _error;
  Book? _currentBookForRelated;

  // Getters
  List<Book> get trendingBooks => _trendingBooks;
  List<Book> get quickReads => _quickReads;
  List<Book> get popularBusinessBooks => _popularBusinessBooks;
  List<Book> get recentlyAddedBooks => _recentlyAddedBooks;
  List<Book> get relatedBooks => _relatedBooks;
  List<AuthorSpotlight> get authorsSpotlight => _authorsSpotlight;

  bool get isLoading => _isLoading;
  bool get isLoadingRelated => _isLoadingRelated;
  bool get isRefreshing => _isRefreshing;
  bool get hasCache => _hasCache;
  String? get error => _error;

  // Fetch all categories with smart caching
  Future<void> fetchAllBooks({bool forceRefresh = false}) async {
    _error = null;

    // Check for cached data first (if not forcing refresh)
    if (!forceRefresh) {
      final hasFreshCache = await CacheService.hasFreshCache();
      if (hasFreshCache) {
        await _loadFromCache();
        // Background refresh if online
        if (await CacheService.isOnline()) {
          _refreshInBackground();
        }
        return;
      }
    }

    // Check if we have any cached data to show while loading
    final cachedData = await CacheService.getAllCachedBooksData();
    if (cachedData != null && !forceRefresh) {
      await _loadFromCache();
      _hasCache = true;
      notifyListeners();
    }

    _isLoading = true;
    if (!_hasCache) {
      notifyListeners(); // Only notify if we don't have cached data to show
    }

    try {
      debugPrint("Starting fetchAllBooks...");
      
      final results = await Future.wait([
        BooksService.getTrendingBooks(),
        BooksService.getQuickReads(),
        BooksService.getPopularBusinessBooks(),
        BooksService.getRecentlyAddedBooks(),
        BooksService.getAuthorsSpotlight(),
      ]);

      debugPrint("All data fetched successfully");

      _trendingBooks = results[0] as List<Book>;
      _quickReads = results[1] as List<Book>;
      _popularBusinessBooks = results[2] as List<Book>;
      _recentlyAddedBooks = results[3] as List<Book>;
      _authorsSpotlight = results[4] as List<AuthorSpotlight>;

      // Cache the new data
      await CacheService.cacheAllBooksData(
        trendingBooks: _trendingBooks,
        quickReads: _quickReads,
        businessBooks: _popularBusinessBooks,
        recentBooks: _recentlyAddedBooks,
        authorsSpotlight: _authorsSpotlight,
      );

      debugPrint("Data cached successfully");
      
    } catch (e) {
      debugPrint("Error in fetchAllBooks: $e");
      _error = e.toString();
      
      // If we have cached data and there's an error, keep showing cached data
      if (_hasCache) {
        _error = null; // Don't show error if we have cached data
        debugPrint("Error occurred but showing cached data");
      }
    } finally {
      _isLoading = false;
      _isRefreshing = false;
      notifyListeners();
    }
  }

  // Load data from cache
  Future<void> _loadFromCache() async {
    final cachedData = await CacheService.getAllCachedBooksData();
    if (cachedData != null) {
      _trendingBooks = cachedData['trendingBooks'] as List<Book>;
      _quickReads = cachedData['quickReads'] as List<Book>;
      _popularBusinessBooks = cachedData['businessBooks'] as List<Book>;
      _recentlyAddedBooks = cachedData['recentBooks'] as List<Book>;
      _authorsSpotlight = cachedData['authorsSpotlight'] as List<AuthorSpotlight>;
      _hasCache = true;
      debugPrint("Data loaded from cache");
    }
  }

  // Refresh data in background without showing loading
  void _refreshInBackground() async {
    if (_isRefreshing) return;
    
    _isRefreshing = true;
    try {
      debugPrint("Background refresh started...");
      
      final results = await Future.wait([
        BooksService.getTrendingBooks(),
        BooksService.getQuickReads(),
        BooksService.getPopularBusinessBooks(),
        BooksService.getRecentlyAddedBooks(),
        BooksService.getAuthorsSpotlight(),
      ]);

      _trendingBooks = results[0] as List<Book>;
      _quickReads = results[1] as List<Book>;
      _popularBusinessBooks = results[2] as List<Book>;
      _recentlyAddedBooks = results[3] as List<Book>;
      _authorsSpotlight = results[4] as List<AuthorSpotlight>;

      // Cache the refreshed data
      await CacheService.cacheAllBooksData(
        trendingBooks: _trendingBooks,
        quickReads: _quickReads,
        businessBooks: _popularBusinessBooks,
        recentBooks: _recentlyAddedBooks,
        authorsSpotlight: _authorsSpotlight,
      );

      debugPrint("Background refresh completed");
      notifyListeners();
      
    } catch (e) {
      debugPrint("Background refresh error: $e");
      // Don't update error state for background refresh failures
    } finally {
      _isRefreshing = false;
    }
  }

  // Individual fetch methods
  Future<void> fetchTrendingBooks() async {
    try {
      _trendingBooks = await BooksService.getTrendingBooks();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> fetchQuickReads() async {
    try {
      _quickReads = await BooksService.getQuickReads();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> fetchPopularBusinessBooks() async {
    try {
      _popularBusinessBooks = await BooksService.getPopularBusinessBooks();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> fetchRecentlyAddedBooks() async {
    try {
      _recentlyAddedBooks = await BooksService.getRecentlyAddedBooks();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> fetchAuthorsSpotlight() async {
    try {
      _authorsSpotlight = await BooksService.getAuthorsSpotlight();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Refresh all data
  Future<void> refreshData() async {
    await fetchAllBooks(forceRefresh: true);
  }

  // Fetch related books for a specific book
  Future<void> fetchRelatedBooks(Book currentBook) async {
    // Avoid re-fetching for the same book
    if (_currentBookForRelated?.bookID == currentBook.bookID) {
      debugPrint("Related books already fetched for: ${currentBook.bookName}");
      return;
    }

    _isLoadingRelated = true;
    _error = null;
    notifyListeners();

    try {
      debugPrint("Fetching related books for: ${currentBook.bookName}");
      _currentBookForRelated = currentBook;
      _relatedBooks = await BooksService.getRelatedBooks(currentBook);
      debugPrint("Related books fetched: ${_relatedBooks.length}");
    } catch (e) {
      debugPrint("Error fetching related books: $e");
      _error = e.toString();
    } finally {
      _isLoadingRelated = false;
      notifyListeners();
    }
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
