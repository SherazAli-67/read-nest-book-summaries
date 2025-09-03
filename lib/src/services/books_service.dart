import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../models/book_model.dart';

class BooksService {
  static final _firestore = FirebaseFirestore.instance;
  static final _booksCollection = _firestore.collection('books');

  // Fetch quick reads (books with short reading time)
  static Future<List<Book>> getQuickReads({int maxMinutes = 20, int limit = 10}) async {
    try {
      final snapshot = await _booksCollection
          .where('timeInMinutes', isLessThanOrEqualTo: maxMinutes)
          .orderBy('timeInMinutes')
          .limit(limit)
          .get();

      return snapshot.docs.map((doc) => Book.fromMap(doc.data())).toList();
    } catch (e) {
      throw Exception('Failed to fetch quick reads: $e');
    }
  }

  // Fetch trending books (you can add a trending field or use recent uploads)
  static Future<List<Book>> getTrendingBooks({int limit = 10}) async {
    try {
      // Option 1: If you add a 'trending' boolean field
      // final snapshot = await _booksCollection
      //     .where('trending', isEqualTo: true)
      //     .limit(limit)
      //     .get();

      // Option 2: For now, get most recent books
      final snapshot = await _booksCollection
          // .orderBy(FieldPath.documentId, descending: true)
          .limit(limit)
          .get();

      debugPrint("Trending length: ${snapshot.docs.length}");
      List<Book> books = snapshot.docs.map((doc) => Book.fromMap(doc.data())).toList();
      debugPrint("Trending books: ${books.length}");

      return books;
    } catch (e) {
      throw Exception('Failed to fetch trending books: $e');
    }
  }

  // Fetch popular business books
  static Future<List<Book>> getPopularBusinessBooks({int limit = 10}) async {
    try {
      final snapshot = await _booksCollection
          .where('categories', arrayContains: 'Business')
          .limit(limit)
          .get();

      return snapshot.docs.map((doc) => Book.fromMap(doc.data())).toList();
    } catch (e) {
      throw Exception('Failed to fetch business books: $e');
    }
  }

  // Fetch recently added books
  static Future<List<Book>> getRecentlyAddedBooks({int limit = 10}) async {
    try {
      // Using document ID for ordering (newest first)
      final snapshot = await _booksCollection
          .orderBy(FieldPath.documentId, descending: true)
          .limit(limit)
          .get();

      return snapshot.docs.map((doc) => Book.fromMap(doc.data())).toList();
    } catch (e) {
      throw Exception('Failed to fetch recent books: $e');
    }
  }

  // Fetch all books for search functionality
  static Future<List<Book>> getAllBooks() async {
    try {
      final snapshot = await _booksCollection.get();
      return snapshot.docs.map((doc) => Book.fromMap(doc.data())).toList();
    } catch (e) {
      throw Exception('Failed to fetch all books: $e');
    }
  }

  // Fetch books by category
  static Future<List<Book>> getBooksByCategory(String category, {int limit = 10}) async {
    try {
      final snapshot = await _booksCollection
          .where('categories', arrayContains: category)
          .limit(limit)
          .get();

      return snapshot.docs.map((doc) => Book.fromMap(doc.data())).toList();
    } catch (e) {
      throw Exception('Failed to fetch books by category: $e');
    }
  }

  // Fetch related books based on current book's categories and author
  static Future<List<Book>> getRelatedBooks(Book currentBook, {int limit = 10}) async {
    try {
      debugPrint('Fetching related books for: ${currentBook.bookName}');
      debugPrint('Current book categories: ${currentBook.categories}');
      debugPrint('Current book author: ${currentBook.author}');

      List<Book> relatedBooks = [];
      Set<String> addedBookIds = {};

      // Strategy 1: Find books with matching categories (exclude current book)
      if (currentBook.categories.isNotEmpty) {
        final categorySnapshot = await _booksCollection
            .where('categories', arrayContainsAny: currentBook.categories)
            .limit(limit * 2)
            .get();

        for (var doc in categorySnapshot.docs) {
          final book = Book.fromMap(doc.data());
          if (book.bookID != currentBook.bookID && !addedBookIds.contains(book.bookID)) {
            relatedBooks.add(book);
            addedBookIds.add(book.bookID);
          }
        }
      }

      // Strategy 2: Find books by same author (if we need more books)
      if (relatedBooks.length < limit) {
        final authorSnapshot = await _booksCollection
            .where('author', isEqualTo: currentBook.author)
            .limit(5)
            .get();

        for (var doc in authorSnapshot.docs) {
          final book = Book.fromMap(doc.data());
          if (book.bookID != currentBook.bookID && 
              !addedBookIds.contains(book.bookID) && 
              relatedBooks.length < limit) {
            relatedBooks.add(book);
            addedBookIds.add(book.bookID);
          }
        }
      }

      // Strategy 3: Fill remaining slots with any books (if still need more)
      if (relatedBooks.length < limit) {
        final remainingSnapshot = await _booksCollection
            .limit(limit * 2)
            .get();

        for (var doc in remainingSnapshot.docs) {
          final book = Book.fromMap(doc.data());
          if (book.bookID != currentBook.bookID && 
              !addedBookIds.contains(book.bookID) && 
              relatedBooks.length < limit) {
            relatedBooks.add(book);
            addedBookIds.add(book.bookID);
          }
        }
      }

      debugPrint('Found ${relatedBooks.length} related books');
      return relatedBooks.take(limit).toList();
    } catch (e) {
      debugPrint('Error fetching related books: $e');
      throw Exception('Failed to fetch related books: $e');
    }
  }
}
