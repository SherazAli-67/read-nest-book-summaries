import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:read_nest/src/models/book_model.dart';
import 'package:read_nest/src/providers/books_provider.dart';
import 'package:read_nest/src/res/app_colors.dart';
import 'package:read_nest/src/res/app_textstyle.dart';

class SummaryRelatedBooks extends StatefulWidget {
  const SummaryRelatedBooks({super.key, required this.currentBook});
  final Book currentBook;

  @override
  State<SummaryRelatedBooks> createState() => _SummaryRelatedBooksState();
}

class _SummaryRelatedBooksState extends State<SummaryRelatedBooks> {
  @override
  void initState() {
    super.initState();
    // Fetch related books when the widget loads
    WidgetsBinding.instance.addPostFrameCallback((_) =>
        context.read<BooksProvider>().fetchRelatedBooks(widget.currentBook));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BooksProvider>(
      builder: (context, booksProvider, child) {
        if (booksProvider.isLoadingRelated) {
          return const Center(child: CircularProgressIndicator());
        }

        if (booksProvider.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 48, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'Error loading related books',
                  style: AppTextStyles.smallTextStyle,
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () =>
                      booksProvider.fetchRelatedBooks(widget.currentBook),
                  child: Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (booksProvider.relatedBooks.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.book_outlined, size: 48, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No related books found',
                  style: AppTextStyles.smallTextStyle,
                ),
                SizedBox(height: 8),
                Text(
                  'Try exploring other books in our collection',
                  style: AppTextStyles.smallTextStyle.copyWith(
                      color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                spacing: 10,
                children: [
                  Icon(Icons.auto_stories, color: Colors.grey),
                  Text(
                    'You might also like',
                    style: AppTextStyles.smallTextStyle.copyWith(
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: booksProvider.relatedBooks.length,
                  itemBuilder: (ctx, index) {
                    final book = booksProvider.relatedBooks[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        minLeadingWidth: 65,
                        leading: SizedBox(
                          height: 45,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: CachedNetworkImage(
                                imageUrl: book.image, width: 65,)),
                        ),
                        title: Text(book.bookName, style: AppTextStyles
                            .smallTextStyle.copyWith(fontWeight: FontWeight
                            .w600),),
                        subtitle: Row(
                          mainAxisSize: MainAxisSize.min,
                          spacing: 10,
                          children: [
                            Expanded(child: Text(book.author)),
                            Container(
                                padding: EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                    color: AppColors.textFieldFillColor
                                        .withValues(alpha: 0.7),
                                    borderRadius: BorderRadius.circular(99)
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    spacing: 4,
                                    children: [
                                      Icon(
                                        Icons.access_time_outlined, size: 18,),
                                      Text(book.time,
                                        style: AppTextStyles.smallTextStyle
                                            .copyWith(fontSize: 12,
                                            fontWeight: FontWeight.w600),)
                                    ],
                                  ),
                                )),
                          ],
                        ),
                      ),
                    );
                  })
            ],
          ),
        );
      },
    );
  }
}