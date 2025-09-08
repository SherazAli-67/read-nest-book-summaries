import 'package:flutter/material.dart';
import 'book_model.dart';

class AuthorSpotlight {
  final String authorName;
  final String primaryCategory;
  final List<Book> books;
  final int totalBooks;
  final IconData categoryIcon;
  final Color categoryColor;

  AuthorSpotlight({
    required this.authorName,
    required this.primaryCategory,
    required this.books,
    required this.totalBooks,
    required this.categoryIcon,
    required this.categoryColor,
  });

  static IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'business':
        return Icons.business_center_rounded;
      case 'money':
      case 'finance':
        return Icons.attach_money_rounded;
      case 'psychology':
        return Icons.psychology_rounded;
      case 'productivity':
        return Icons.trending_up_rounded;
      case 'leadership':
        return Icons.group_rounded;
      case 'motivation':
      case 'self-help':
        return Icons.psychology_alt_rounded;
      case 'health':
        return Icons.favorite_rounded;
      case 'technology':
        return Icons.computer_rounded;
      case 'science':
        return Icons.science_rounded;
      default:
        return Icons.book_rounded;
    }
  }

  static Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'business':
        return Colors.blue;
      case 'money':
      case 'finance':
        return Colors.amber;
      case 'psychology':
        return Colors.purple;
      case 'productivity':
        return Colors.green;
      case 'leadership':
        return Colors.orange;
      case 'motivation':
      case 'self-help':
        return Colors.pink;
      case 'health':
        return Colors.red;
      case 'technology':
        return Colors.indigo;
      case 'science':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  factory AuthorSpotlight.create({
    required String authorName,
    required List<Book> books,
  }) {
    // Find the most common category for this author
    Map<String, int> categoryCount = {};
    for (var book in books) {
      for (var category in book.categories) {
        categoryCount[category] = (categoryCount[category] ?? 0) + 1;
      }
    }

    String primaryCategory = 'General';
    if (categoryCount.isNotEmpty) {
      primaryCategory = categoryCount.entries
          .reduce((a, b) => a.value > b.value ? a : b)
          .key;
    }

    return AuthorSpotlight(
      authorName: authorName,
      primaryCategory: primaryCategory,
      books: books,
      totalBooks: books.length,
      categoryIcon: _getCategoryIcon(primaryCategory),
      categoryColor: _getCategoryColor(primaryCategory),
    );
  }
}
