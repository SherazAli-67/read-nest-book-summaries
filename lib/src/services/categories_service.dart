import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../models/category_model.dart';

class CategoriesService {
  static final _firestore = FirebaseFirestore.instance;
  static final _categoriesCollection = _firestore.collection('categories');

  // Fetch all categories
  static Future<List<Category>> getAllCategories({int limit = 20}) async {
    try {
      debugPrint('Fetching categories from Firestore...');
      
      final snapshot = await _categoriesCollection
          .orderBy('title')
          .limit(limit)
          .get();

      final categories = snapshot.docs
          .map((doc) => Category.fromMap(doc.data()))
          .toList();

      debugPrint('Categories fetched: ${categories.length}');
      return categories;
    } catch (e) {
      debugPrint('Error fetching categories: $e');
      throw Exception('Failed to fetch categories: $e');
    }
  }

  // Fetch categories with pagination
  static Future<List<Category>> getCategoriesPaginated({
    int limit = 10,
    DocumentSnapshot? lastDocument,
  }) async {
    try {
      Query query = _categoriesCollection
          .orderBy('title')
          .limit(limit);

      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }

      final snapshot = await query.get();
      return snapshot.docs
          .map((doc) => Category.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch paginated categories: $e');
    }
  }

  // Get category by ID
  static Future<Category?> getCategoryById(String id) async {
    try {
      final doc = await _categoriesCollection.doc(id).get();
      if (doc.exists) {
        return Category.fromMap(doc.data()!);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch category: $e');
    }
  }

  // Search categories by title
  static Future<List<Category>> searchCategories(String searchTerm) async {
    try {
      final snapshot = await _categoriesCollection
          .where('title', isGreaterThanOrEqualTo: searchTerm)
          .where('title', isLessThanOrEqualTo: searchTerm + '\uf8ff')
          .orderBy('title')
          .limit(10)
          .get();

      return snapshot.docs
          .map((doc) => Category.fromMap(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to search categories: $e');
    }
  }
}
