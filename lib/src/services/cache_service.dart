import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../models/book_model.dart';
import '../models/author_spotlight_model.dart';
import '../models/category_model.dart';

class CacheService {
  static const String _trendingBooksKey = 'trending_books';
  static const String _quickReadsKey = 'quick_reads';
  static const String _businessBooksKey = 'business_books';
  static const String _recentBooksKey = 'recent_books';
  static const String _authorsSpotlightKey = 'authors_spotlight';
  static const String _categoriesKey = 'categories';
  static const String _cacheTimestampKey = 'cache_timestamp';
  static const String _categoriesCacheTimestampKey = 'categories_cache_timestamp';
  static const String _cacheExpirationMinutes = '60'; // Cache expires after 1 hour

  static Future<SharedPreferences> get _prefs async => await SharedPreferences.getInstance();

  // Check if device is connected to internet
  static Future<bool> isOnline() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  // Check if cache is expired
  static Future<bool> isCacheExpired() async {
    final prefs = await _prefs;
    final timestamp = prefs.getInt(_cacheTimestampKey) ?? 0;
    final now = DateTime.now().millisecondsSinceEpoch;
    final expirationTime = int.parse(_cacheExpirationMinutes) * 60 * 1000; // Convert to milliseconds
    
    return (now - timestamp) > expirationTime;
  }

  // Update cache timestamp
  static Future<void> updateCacheTimestamp() async {
    final prefs = await _prefs;
    await prefs.setInt(_cacheTimestampKey, DateTime.now().millisecondsSinceEpoch);
  }

  // Cache trending books
  static Future<void> cacheTrendingBooks(List<Book> books) async {
    final prefs = await _prefs;
    final booksJson = books.map((book) => json.encode(book.toMap())).toList();
    await prefs.setStringList(_trendingBooksKey, booksJson);
  }

  // Get cached trending books
  static Future<List<Book>?> getCachedTrendingBooks() async {
    final prefs = await _prefs;
    final booksJson = prefs.getStringList(_trendingBooksKey);
    if (booksJson == null) return null;
    
    try {
      return booksJson
          .map((bookStr) => Book.fromMap(json.decode(bookStr)))
          .toList();
    } catch (e) {
      return null;
    }
  }

  // Cache quick reads
  static Future<void> cacheQuickReads(List<Book> books) async {
    final prefs = await _prefs;
    final booksJson = books.map((book) => json.encode(book.toMap())).toList();
    await prefs.setStringList(_quickReadsKey, booksJson);
  }

  // Get cached quick reads
  static Future<List<Book>?> getCachedQuickReads() async {
    final prefs = await _prefs;
    final booksJson = prefs.getStringList(_quickReadsKey);
    if (booksJson == null) return null;
    
    try {
      return booksJson
          .map((bookStr) => Book.fromMap(json.decode(bookStr)))
          .toList();
    } catch (e) {
      return null;
    }
  }

  // Cache business books
  static Future<void> cacheBusinessBooks(List<Book> books) async {
    final prefs = await _prefs;
    final booksJson = books.map((book) => json.encode(book.toMap())).toList();
    await prefs.setStringList(_businessBooksKey, booksJson);
  }

  // Get cached business books
  static Future<List<Book>?> getCachedBusinessBooks() async {
    final prefs = await _prefs;
    final booksJson = prefs.getStringList(_businessBooksKey);
    if (booksJson == null) return null;
    
    try {
      return booksJson
          .map((bookStr) => Book.fromMap(json.decode(bookStr)))
          .toList();
    } catch (e) {
      return null;
    }
  }

  // Cache recent books
  static Future<void> cacheRecentBooks(List<Book> books) async {
    final prefs = await _prefs;
    final booksJson = books.map((book) => json.encode(book.toMap())).toList();
    await prefs.setStringList(_recentBooksKey, booksJson);
  }

  // Get cached recent books
  static Future<List<Book>?> getCachedRecentBooks() async {
    final prefs = await _prefs;
    final booksJson = prefs.getStringList(_recentBooksKey);
    if (booksJson == null) return null;
    
    try {
      return booksJson
          .map((bookStr) => Book.fromMap(json.decode(bookStr)))
          .toList();
    } catch (e) {
      return null;
    }
  }

  // Cache authors spotlight
  static Future<void> cacheAuthorsSpotlight(List<AuthorSpotlight> authors) async {
    final prefs = await _prefs;
    final authorsData = authors.map((author) => {
      'authorName': author.authorName,
      'primaryCategory': author.primaryCategory,
      'totalBooks': author.totalBooks,
      'books': author.books.map((book) => book.toMap()).toList(),
    }).toList();
    
    await prefs.setString(_authorsSpotlightKey, json.encode(authorsData));
  }

  // Get cached authors spotlight
  static Future<List<AuthorSpotlight>?> getCachedAuthorsSpotlight() async {
    final prefs = await _prefs;
    final authorsJson = prefs.getString(_authorsSpotlightKey);
    if (authorsJson == null) return null;
    
    try {
      final List<dynamic> authorsData = json.decode(authorsJson);
      return authorsData.map((authorData) {
        final books = (authorData['books'] as List<dynamic>)
            .map((bookData) => Book.fromMap(bookData))
            .toList();
        
        return AuthorSpotlight.create(
          authorName: authorData['authorName'],
          books: books,
        );
      }).toList();
    } catch (e) {
      return null;
    }
  }

  // Cache all books data
  static Future<void> cacheAllBooksData({
    required List<Book> trendingBooks,
    required List<Book> quickReads,
    required List<Book> businessBooks,
    required List<Book> recentBooks,
    required List<AuthorSpotlight> authorsSpotlight,
  }) async {
    await Future.wait([
      cacheTrendingBooks(trendingBooks),
      cacheQuickReads(quickReads),
      cacheBusinessBooks(businessBooks),
      cacheRecentBooks(recentBooks),
      cacheAuthorsSpotlight(authorsSpotlight),
      updateCacheTimestamp(),
    ]);
  }

  // Get all cached books data
  static Future<Map<String, dynamic>?> getAllCachedBooksData() async {
    try {
      final results = await Future.wait([
        getCachedTrendingBooks(),
        getCachedQuickReads(),
        getCachedBusinessBooks(),
        getCachedRecentBooks(),
        getCachedAuthorsSpotlight(),
      ]);

      // Check if any cache is null
      if (results.any((result) => result == null)) {
        return null;
      }

      return {
        'trendingBooks': results[0] as List<Book>,
        'quickReads': results[1] as List<Book>,
        'businessBooks': results[2] as List<Book>,
        'recentBooks': results[3] as List<Book>,
        'authorsSpotlight': results[4] as List<AuthorSpotlight>,
      };
    } catch (e) {
      return null;
    }
  }

  // Clear all cache
  static Future<void> clearAllCache() async {
    final prefs = await _prefs;
    await Future.wait([
      prefs.remove(_trendingBooksKey),
      prefs.remove(_quickReadsKey),
      prefs.remove(_businessBooksKey),
      prefs.remove(_recentBooksKey),
      prefs.remove(_authorsSpotlightKey),
      prefs.remove(_cacheTimestampKey),
    ]);
  }

  // Categories caching methods
  
  // Check if categories cache is expired
  static Future<bool> isCategoriesCacheExpired() async {
    final prefs = await _prefs;
    final timestamp = prefs.getInt(_categoriesCacheTimestampKey) ?? 0;
    final now = DateTime.now().millisecondsSinceEpoch;
    final expirationTime = int.parse(_cacheExpirationMinutes) * 60 * 1000; // Convert to milliseconds
    
    return (now - timestamp) > expirationTime;
  }

  // Update categories cache timestamp
  static Future<void> updateCategoriesCacheTimestamp() async {
    final prefs = await _prefs;
    await prefs.setInt(_categoriesCacheTimestampKey, DateTime.now().millisecondsSinceEpoch);
  }

  // Cache categories
  static Future<void> cacheCategories(List<Category> categories) async {
    final prefs = await _prefs;
    final categoriesJson = categories.map((category) => json.encode(category.toMap())).toList();
    await prefs.setStringList(_categoriesKey, categoriesJson);
    await updateCategoriesCacheTimestamp();
  }

  // Get cached categories
  static Future<List<Category>?> getCachedCategories() async {
    final prefs = await _prefs;
    final categoriesJson = prefs.getStringList(_categoriesKey);
    if (categoriesJson == null) return null;
    
    try {
      return categoriesJson
          .map((categoryStr) => Category.fromMap(json.decode(categoryStr)))
          .toList();
    } catch (e) {
      return null;
    }
  }

  // Check if categories cache exists and is valid
  static Future<bool> hasFreshCategoriesCache() async {
    final hasCache = await getCachedCategories() != null;
    final isExpired = await isCategoriesCacheExpired();
    return hasCache && !isExpired;
  }

  // Clear categories cache
  static Future<void> clearCategoriesCache() async {
    final prefs = await _prefs;
    await Future.wait([
      prefs.remove(_categoriesKey),
      prefs.remove(_categoriesCacheTimestampKey),
    ]);
  }

  // Check if cache exists and is valid
  static Future<bool> hasFreshCache() async {
    final hasCache = await getAllCachedBooksData() != null;
    final isExpired = await isCacheExpired();
    return hasCache && !isExpired;
  }
}
