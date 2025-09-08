import 'package:flutter/material.dart';
import '../models/book_model.dart';
import '../models/author_spotlight_model.dart';
import '../services/books_service.dart';

class BooksProvider extends ChangeNotifier {
  List<Book> _trendingBooks = [];
  List<Book> _quickReads = [];
  List<Book> _popularBusinessBooks = [];
  List<Book> _recentlyAddedBooks = [];
  List<Book> _relatedBooks = [];
  List<AuthorSpotlight> _authorsSpotlight = [];

  bool _isLoading = false;
  bool _isLoadingRelated = false;
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
        BooksService.getAuthorsSpotlight(),
      ]);

      debugPrint("Trending books fetched: ${results[0].length}");
      debugPrint("Quick reads fetched: ${results[1].length}");
      debugPrint("Business books fetched: ${results[2].length}");
      debugPrint("Recent books fetched: ${results[3].length}");
      debugPrint("Authors spotlight fetched: ${results[4].length}");

      _trendingBooks = results[0];
      _quickReads = results[1];
      _popularBusinessBooks = results[2];
      _recentlyAddedBooks = results[3];
      _authorsSpotlight = results[4];

      debugPrint("Provider state updated - Trending: ${_trendingBooks.length}");
      debugPrint("Authors spotlight: ${_authorsSpotlight.length}");
      
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
    await fetchAllBooks();
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
