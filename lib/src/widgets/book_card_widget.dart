import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:read_nest/src/features/summary_detail_page/summary_detail_page.dart';
import 'package:read_nest/src/models/book_model.dart';
import 'package:read_nest/src/services/books_service.dart';

import '../res/app_colors.dart';
import '../res/app_textstyle.dart';

class BookCard extends StatelessWidget {
  const BookCard({
    super.key,
    required this.book,
    this.onTap,
  });

  final Book book;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => SummaryDetailPage(book: book),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Book Image Container
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      child: Hero(
                        tag: 'bookImage-${book.bookID}',
                        child: CachedNetworkImage(
                          imageUrl: book.image.isNotEmpty 
                            ? book.image 
                            : 'https://via.placeholder.com/300x400/E0E0E0/757575?text=No+Image',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          placeholder: (context, url) => Container(
                            color: Colors.grey[200],
                            child: const Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.grey[300],
                            child: Icon(
                              Icons.book,
                              size: 40,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Favorite Button
                    Positioned(
                      right: 8,
                      top: 8,
                      child: StreamBuilder<bool>(
                        stream: BooksService.getIsFav(book.bookID),
                        builder: (_, snapshot) {
                          if (snapshot.hasData) {
                            return _buildFavIcon(book.bookID, isFav: snapshot.requireData);
                          }
                          return _buildFavIcon(book.bookID);
                        },
                      ),
                    ),
                    // Reading Time Badge
                    Positioned(
                      left: 8,
                      bottom: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.textFieldFillColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.access_time_outlined, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              book.time,
                              style: AppTextStyles.smallTextStyle.copyWith(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Book Details Container
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Book Title
                    Text(
                      book.bookName,
                      style: AppTextStyles.smallTextStyle.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    // Author Name
                    Text(
                      book.author,
                      style: AppTextStyles.smallTextStyle.copyWith(
                        fontSize: 11,
                        color: Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavIcon(String bookID, {bool isFav = false}) {
    return GestureDetector(
      onTap: () => BooksService.addToFavorite(bookID: bookID, isRemove: isFav),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: AppColors.textFieldFillColor,
          shape: BoxShape.circle,
        ),
        child: Icon(
          isFav ? Icons.favorite : Icons.favorite_border,
          color: isFav ? Colors.red : Colors.black45,
          size: 16,
        ),
      ),
    );
  }
}

