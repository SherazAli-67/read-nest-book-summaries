import 'package:flutter/material.dart';
import '../models/book_model.dart';
import '../services/books_service.dart';

class BooksProvider extends ChangeNotifier {
  List<Book> _trendingBooks = [];
  List<Book> _quickReads = [];
  List<Book> _popularBusinessBooks = [];
  List<Book> _recentlyAddedBooks = [];

  bool _isLoading = false;
  String? _error;

  // Getters
  List<Book> get trendingBooks => _trendingBooks;
  List<Book> get quickReads => _quickReads;
  List<Book> get popularBusinessBooks => _popularBusinessBooks;
  List<Book> get recentlyAddedBooks => _recentlyAddedBooks;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Fetch all categories
  Future<void> fetchAllBooks() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      debugPrint("Starting fetchAllBooks...");
      
      final results = await Future.wait([
        BooksService.getTrendingBooks(),
        BooksService.getQuickReads(),
        BooksService.getPopularBusinessBooks(),
        BooksService.getRecentlyAddedBooks(),
      ]);

      debugPrint("Trending books fetched: ${results[0].length}");
      debugPrint("Quick reads fetched: ${results[1].length}");
      debugPrint("Business books fetched: ${results[2].length}");
      debugPrint("Recent books fetched: ${results[3].length}");

      _trendingBooks = results[0];
      _quickReads = results[1];
      _popularBusinessBooks = results[2];
      _recentlyAddedBooks = results[3];

      debugPrint("Provider state updated - Trending: ${_trendingBooks.length}");
      
    } catch (e) {
      debugPrint("Error in fetchAllBooks: $e");
      _error = e.toString();
    } finally {
      _isLoading = false;
      debugPrint("Loading set to false, notifying listeners...");
      notifyListeners();
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

  // Refresh all data
  Future<void> refreshData() async {
    await fetchAllBooks();
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
