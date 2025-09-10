import 'package:flutter/foundation.dart';
import 'package:read_nest/src/models/book_model.dart';
import 'package:share_plus/share_plus.dart';

class ShareService {
  /// Shares a book with formatted rich text content
  static Future<void> shareBook(Book book) async {
    final shareText = _formatBookShareText(book);
    
    try {
      await Share.share(
        shareText,
        subject: 'Check out "${book.bookName}" on ReadNest',
      );
    } catch (e) {
      // Handle sharing error gracefully
      if (kDebugMode) {
        debugPrint('Error sharing book: $e');
      }
    }
  }

  /// Formats the book information into a rich text format for sharing
  static String _formatBookShareText(Book book) {
    // Truncate summary to 100-150 characters with ellipsis
    String truncatedSummary = _truncateText(book.shortSummary, 150);
    
    // Get up to 2 main categories for display
    String categories = book.categories.isNotEmpty 
        ? book.categories.take(2).join(', ')
        : 'General';
    
    return '''📚 "${book.bookName}" by ${book.author}

$truncatedSummary

⏱️ ${book.time} | 📖 $categories

Discover more book summaries on ReadNest! 📱''';
  }

  /// Helper method to truncate text to specified length with ellipsis
  static String _truncateText(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    }
    
    // Find the last space before maxLength to avoid cutting words
    int cutIndex = maxLength;
    for (int i = maxLength - 1; i >= 0; i--) {
      if (text[i] == ' ') {
        cutIndex = i;
        break;
      }
    }
    
    return '${text.substring(0, cutIndex)}...';
  }

  /// Shares book with custom message (for potential future use)
  static Future<void> shareBookWithMessage(Book book, String customMessage) async {
    final baseText = _formatBookShareText(book);
    final shareText = '$customMessage\n\n$baseText';
    
    try {
      await Share.share(
        shareText,
        subject: 'Check out "${book.bookName}" on ReadNest',
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error sharing book with custom message: $e');
      }
    }
  }
}
