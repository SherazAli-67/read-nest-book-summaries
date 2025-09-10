import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:read_nest/src/res/firebase_const.dart';
import '../models/book_model.dart';
import '../models/author_spotlight_model.dart';

class BooksService {
  static final _firestore = FirebaseFirestore.instance;
  static final _booksCollection = _firestore.collection('books');

  // Fetch quick reads (books with short reading time)
  static Future<List<Book>> getQuickReads({
    int maxMinutes = 20, 
    int limit = 10,
    int offset = 0,
  }) async {
    try {
      Query query = _booksCollection
          .where('timeInMinutes', isLessThanOrEqualTo: maxMinutes)
          .orderBy('timeInMinutes');

      if (offset > 0) {
        // For pagination, we need to skip 'offset' number of documents
        final skipSnapshot = await query.limit(offset).get();
        if (skipSnapshot.docs.isNotEmpty) {
          final lastDoc = skipSnapshot.docs.last;
          query = query.startAfterDocument(lastDoc);
        }
      }

      final snapshot = await query.limit(limit).get();
      return snapshot.docs.map((doc) => Book.fromMap(doc.data() as Map<String, dynamic>)).toList();
    } catch (e) {
      throw Exception('Failed to fetch quick reads: $e');
    }
  }

  // Fetch trending books (you can add a trending field or use recent uploads)
  static Future<List<Book>> getTrendingBooks({
    int limit = 10,
    int offset = 0,
  }) async {
    try {
      Query query = _booksCollection;

      if (offset > 0) {
        final skipSnapshot = await query.limit(offset).get();
        if (skipSnapshot.docs.isNotEmpty) {
          final lastDoc = skipSnapshot.docs.last;
          query = query.startAfterDocument(lastDoc);
        }
      }

      final snapshot = await query.limit(limit).get();
      debugPrint("Trending length: ${snapshot.docs.length}");
      List<Book> books = snapshot.docs.map((doc) => Book.fromMap(doc.data() as Map<String, dynamic>)).toList();
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
          .where('categories', arrayContains: 'Money & Investments')
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

  // Fetch authors spotlight - groups books by author and creates spotlight data
  static Future<List<AuthorSpotlight>> getAuthorsSpotlight({int limit = 6}) async {
    try {
      debugPrint('Fetching authors spotlight...');
      
      // Get all books
      final snapshot = await _booksCollection.get();
      List<Book> allBooks = snapshot.docs.map((doc) => Book.fromMap(doc.data())).toList();
      
      // Group books by author
      Map<String, List<Book>> booksByAuthor = {};
      for (var book in allBooks) {
        if (book.author.isNotEmpty) {
          if (!booksByAuthor.containsKey(book.author)) {
            booksByAuthor[book.author] = [];
          }
          booksByAuthor[book.author]!.add(book);
        }
      }
      
      // Create author spotlight objects and sort by book count
      List<AuthorSpotlight> authorsSpotlight = [];
      booksByAuthor.forEach((author, books) {
        if (books.isNotEmpty) {
          authorsSpotlight.add(AuthorSpotlight.create(
            authorName: author,
            books: books,
          ));
        }
      });
      
      // Sort by book count (descending) and take top authors
      authorsSpotlight.sort((a, b) => b.totalBooks.compareTo(a.totalBooks));
      
      debugPrint('Found ${authorsSpotlight.length} authors, returning top $limit');
      return authorsSpotlight.take(limit).toList();
    } catch (e) {
      debugPrint('Error fetching authors spotlight: $e');
      throw Exception('Failed to fetch authors spotlight: $e');
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

  static Future<void> addToFavorite({required String bookID,required bool isRemove})async {
    String userID = FirebaseAuth.instance.currentUser!.uid;
    final userFavDoc = _firestore
        .collection(FirebaseConst.usersCollection)
        .doc(userID)
        .collection(FirebaseConst.favoritesCollection)
        .doc(bookID);

    final bookFavDoc = _firestore
        .collection(FirebaseConst.booksCollection)
        .doc(bookID)
        .collection(FirebaseConst.favoritesCollection)
        .doc(userID);

    if (isRemove) {
      await Future.wait([
        userFavDoc.delete(),
        bookFavDoc.delete(),
      ]);
    } else {
      await Future.wait([
        userFavDoc.set({'bookID' : bookID}),
        bookFavDoc.set({'userID' : userID}),
      ]);
    }

  }

  static Stream<bool> getIsFav(String bookID) {
    String currentUID = FirebaseAuth.instance.currentUser!.uid;
    return _firestore
        .collection(FirebaseConst.usersCollection)
        .doc(currentUID)
        .collection(FirebaseConst.favoritesCollection)
        .doc(bookID)
        .snapshots()
        .map((snapshot)=> snapshot.exists);
  }

  static Future<void> addToShare({required String bookID})async {
    String userID = FirebaseAuth.instance.currentUser!.uid;
    await _firestore
        .collection(FirebaseConst.booksCollection)
        .doc(bookID)
        .collection(FirebaseConst.summarySharedCollection).add({
      'userID': userID
    });
  }
}