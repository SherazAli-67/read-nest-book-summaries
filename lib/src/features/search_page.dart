import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:read_nest/src/models/book_model.dart';
import 'package:read_nest/src/providers/books_provider.dart';
import 'package:read_nest/src/providers/search_history_provider.dart';
import 'package:read_nest/src/res/app_colors.dart';
import 'package:read_nest/src/res/app_textstyle.dart';
import 'package:read_nest/src/features/summary_detail_page/summary_detail_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  int _selectedFilterIndex = 0; // 0: All, 1: Books, 2: Authors
  List<Book> _filteredBooks = [];
  Timer? _debounceTimer;
  
  final List<String> _filterTabs = ['All', 'Books', 'Authors'];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    // Initialize with all books
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeAllBooks();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _initializeAllBooks() {
    final booksProvider = context.read<BooksProvider>();
    final List<Book> allBooks = [
      ...booksProvider.trendingBooks,
      ...booksProvider.quickReads,
      ...booksProvider.popularBusinessBooks,
      ...booksProvider.recentlyAddedBooks,
    ];
    
    // Remove duplicates based on bookID
    final Map<String, Book> uniqueBooks = {};
    for (Book book in allBooks) {
      uniqueBooks[book.bookID] = book;
    }
    
    setState(() {
      _filteredBooks = uniqueBooks.values.toList();
    });
  }

  void _onSearchChanged() {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      _performSearch(_searchController.text);
    });
  }

  void _performSearch(String query) {
    final booksProvider = context.read<BooksProvider>();
    final List<Book> allBooks = [
      ...booksProvider.trendingBooks,
      ...booksProvider.quickReads,
      ...booksProvider.popularBusinessBooks,
      ...booksProvider.recentlyAddedBooks,
    ];
    
    // Remove duplicates based on bookID
    final Map<String, Book> uniqueBooks = {};
    for (Book book in allBooks) {
      uniqueBooks[book.bookID] = book;
    }
    
    List<Book> searchResults = uniqueBooks.values.toList();
    
    if (query.isNotEmpty) {
      searchResults = searchResults.where((book) {
        bool matchesQuery = false;
        
        switch (_selectedFilterIndex) {
          case 0: // All
            matchesQuery = book.bookName.toLowerCase().contains(query.toLowerCase()) ||
                          book.author.toLowerCase().contains(query.toLowerCase());
            break;
          case 1: // Books
            matchesQuery = book.bookName.toLowerCase().contains(query.toLowerCase());
            break;
          case 2: // Authors
            matchesQuery = book.author.toLowerCase().contains(query.toLowerCase());
            break;
        }
        
        return matchesQuery;
      }).toList();
    }
    
    setState(() {
      _searchQuery = query;
      _filteredBooks = searchResults;
    });
  }

  void _onFilterChanged(int index) {
    setState(() {
      _selectedFilterIndex = index;
    });
    _performSearch(_searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Search Books',
          style: AppTextStyles.titleTextStyle,
        ),
      ),
      body: Consumer<BooksProvider>(
        builder: (context, booksProvider, child) {
          return Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextField(
                  controller: _searchController,
                  autofocus: true,
                  decoration: InputDecoration(
                    fillColor: AppColors.textFieldFillColor,
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
                    ),
                    hintText: 'Search for books or authors...',
                    hintStyle: AppTextStyles.smallTextStyle.copyWith(color: Colors.grey),
                    prefixIcon: const Icon(Icons.search_rounded, color: Colors.grey),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, color: Colors.grey),
                            onPressed: () {
                              _searchController.clear();
                              _performSearch('');
                            },
                          )
                        : null,
                  ),
                  style: AppTextStyles.regularTextStyle,
                ),
              ),
              
              // Filter Tabs
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  children: List.generate(_filterTabs.length, (index) {
                    bool isSelected = _selectedFilterIndex == index;
                    return Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: FilterChip(
                        selected: isSelected,
                        label: Text(
                          _filterTabs[index],
                          style: AppTextStyles.smallTextStyle.copyWith(
                            color: isSelected ? Colors.white : Colors.black,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                        selectedColor: Colors.black,
                        backgroundColor: AppColors.textFieldFillColor,
                        onSelected: (selected) => _onFilterChanged(index),
                        showCheckmark: false,
                      ),
                    );
                  }),
                ),
              ),
              
              const SizedBox(height: 15),
              
              // Search Results
              Expanded(
                child: _buildSearchResults(size, booksProvider),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSearchResults(Size size, BooksProvider booksProvider) {
    if (booksProvider.isLoading && !booksProvider.hasCache) {
      return _buildLoadingState();
    }
    
    if (_filteredBooks.isEmpty && _searchQuery.isNotEmpty) {
      return _buildEmptyState();
    }
    
    if (_filteredBooks.isEmpty && _searchQuery.isEmpty) {
      return _buildInitialState();
    }
    
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      itemCount: _filteredBooks.length,
      itemBuilder: (context, index) {
        return _buildBookCard(_filteredBooks[index]);
      },
    );
  }

  Widget _buildBookCard(Book book) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SummaryDetailPage(book: book),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Book Cover
            Hero(
              tag: 'bookImage-${book.bookID}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: book.image,
                  width: 80,
                  height: 120,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    width: 80,
                    height: 120,
                    color: AppColors.textFieldFillColor,
                    child: const Icon(Icons.book, color: Colors.grey),
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: 80,
                    height: 120,
                    color: AppColors.textFieldFillColor,
                    child: const Icon(Icons.error, color: Colors.grey),
                  ),
                ),
              ),
            ),
            
            const SizedBox(width: 12),
            
            // Book Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Book Title
                  Text(
                    book.bookName,
                    style: AppTextStyles.titleTextStyle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 4),
                  
                  // Author
                  Text(
                    book.author,
                    style: AppTextStyles.smallTextStyle.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Time Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.textFieldFillColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.access_time_outlined,
                          size: 14,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          book.time,
                          style: AppTextStyles.smallTextStyle.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Categories
                  if (book.categories.isNotEmpty)
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: book.categories.take(2).map((category) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.withOpacity(0.3)),
                          ),
                          child: Text(
                            category,
                            style: AppTextStyles.smallTextStyle.copyWith(
                              fontSize: 11,
                              color: Colors.grey[700],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No results found',
            style: AppTextStyles.titleTextStyle.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try searching with different keywords',
            style: AppTextStyles.smallTextStyle.copyWith(
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInitialState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Search for books',
            style: AppTextStyles.titleTextStyle.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Find your next favorite book summary',
            style: AppTextStyles.smallTextStyle.copyWith(
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}
