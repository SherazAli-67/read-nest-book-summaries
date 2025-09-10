import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:read_nest/src/models/book_model.dart';
import 'package:read_nest/src/res/app_colors.dart';
import 'package:read_nest/src/res/app_icons.dart';
import 'package:read_nest/src/res/app_textstyle.dart';
import 'package:read_nest/src/services/books_service.dart';
import 'package:read_nest/src/widgets/book_card_widget.dart';

import '../models/category_model.dart';

class CategoryBooksPage extends StatefulWidget{
  const CategoryBooksPage({super.key, required Category category}): _category = category;
  final Category _category;

  @override
  State<CategoryBooksPage> createState() => _CategoryBooksPageState();
}

class _CategoryBooksPageState extends State<CategoryBooksPage> {
  final ScrollController _scrollController = ScrollController();
  List<Book> _books = [];
  DocumentSnapshot? _lastDocument;
  bool _isLoading = false;
  bool _hasMore = true;
  bool _isInitialLoad = true;
  String? _error;
  
  static const int _pageSize = 10;

  @override
  void initState() {
    super.initState();
    _loadBooks();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= 
        _scrollController.position.maxScrollExtent - 200) {
      if (!_isLoading && _hasMore) {
        _loadMoreBooks();
      }
    }
  }

  Future<void> _loadBooks() async {
    if (_isLoading) return;
    
    setState(() {
      _isLoading = true;
      _error = null;
      if (_isInitialLoad) {
        _books.clear();
        _lastDocument = null;
        _hasMore = true;
      }
    });

    try {
      final result = await BooksService.getBooksByCategory(
        widget._category.title,
        limit: _pageSize,
        lastDocument: _lastDocument,
      );
      
      final List<Book> newBooks = List<Book>.from(result['books']);
      final DocumentSnapshot? newLastDocument = result['lastDocument'];
      final bool hasMore = result['hasMore'] as bool;

      setState(() {
        if (_isInitialLoad) {
          _books = newBooks;
          _isInitialLoad = false;
        } else {
          _books.addAll(newBooks);
        }
        _lastDocument = newLastDocument;
        _hasMore = hasMore;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _loadMoreBooks() async {
    if (!_hasMore || _isLoading) return;
    await _loadBooks();
  }

  Future<void> _refresh() async {
    _isInitialLoad = true;
    _lastDocument = null;
    _hasMore = true;
    await _loadBooks();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context), 
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: Text(
          widget._category.title,
          style: AppTextStyles.regularTextStyle,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // Category Header
            SliverToBoxAdapter(
              child: Container(
                color: AppColors.textFieldFillColor,
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context), 
                          icon: const Icon(Icons.arrow_back_rounded),
                        ),
                        Text(
                          "Back to categories", 
                          style: AppTextStyles.smallTextStyle,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            imageUrl: AppIcons.dummyBookImageUrl2, 
                            fit: BoxFit.cover, 
                            height: 75,
                            width: 75,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget._category.title, 
                                style: AppTextStyles.regularTextStyle,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Fascinating stories and lessons from the past that shape our present', 
                                maxLines: 3, 
                                overflow: TextOverflow.ellipsis, 
                                style: AppTextStyles.smallTextStyle.copyWith(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _buildAuthorInfoItemWidget(
                          value: '${_books.length}', 
                          title: 'Loaded',
                        ),
                        _buildAuthorInfoItemWidget(
                          value: '${widget._category.totalSummaries}', 
                          title: 'Total',
                        ),
                        _buildAuthorInfoItemWidget(
                          value: '4.5', 
                          title: 'Rating',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            // Books Grid
            if (_error != null)
              SliverToBoxAdapter(
                child: _buildErrorWidget(),
              )
            else if (_isInitialLoad && _isLoading)
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.7,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => const BookCardShimmer(),
                    childCount: 6,
                  ),
                ),
              )
            else if (_books.isEmpty && !_isLoading)
              SliverToBoxAdapter(
                child: _buildEmptyWidget(),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.7,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index < _books.length) {
                        return BookCard(book: _books[index]);
                      }
                      return null;
                    },
                    childCount: _books.length,
                  ),
                ),
              ),
            
            // Loading indicator for pagination
            if (_isLoading && !_isInitialLoad)
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
            
            // End of list indicator
            if (!_hasMore && _books.isNotEmpty)
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child: Text(
                      'You\'ve reached the end!',
                      style: AppTextStyles.smallTextStyle.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 48,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          Text(
            'Something went wrong',
            style: AppTextStyles.regularTextStyle.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _error?.contains('Exception') == true 
              ? 'Please check your internet connection and try again'
              : _error ?? 'Unknown error occurred',
            style: AppTextStyles.smallTextStyle.copyWith(
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _refresh,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.book_outlined,
            size: 48,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No books found',
            style: AppTextStyles.regularTextStyle.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'There are no books available in this category yet.',
            style: AppTextStyles.smallTextStyle.copyWith(
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _refresh,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Refresh'),
          ),
        ],
      ),
    );
  }

  Widget _buildAuthorInfoItemWidget({required String value, required String title}) {
    return Expanded(
      child: Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
          child: Column(
            children: [
              Text(value, style: AppTextStyles.titleTextStyle),
              Text(title, style: AppTextStyles.regularTextStyle,)
            ],
          ),
        ),
      ),
    );
  }
}
