import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:read_nest/src/data/app_data.dart';
import 'package:read_nest/src/providers/books_provider.dart';
import 'package:read_nest/src/res/app_avatars.dart';
import 'package:read_nest/src/res/app_colors.dart';
import 'package:read_nest/src/res/app_icons.dart';
import 'package:read_nest/src/res/app_textstyle.dart';
import 'package:read_nest/src/widgets/home_page_categories_books_widget.dart';
import 'package:read_nest/src/widgets/shimmer_widgets.dart';

class OptimizedHomePage extends StatefulWidget {
  const OptimizedHomePage({super.key});

  @override
  State<OptimizedHomePage> createState() => _OptimizedHomePageState();
}

class _OptimizedHomePageState extends State<OptimizedHomePage> {
  int _selectedCategoryIndex = 0;
  final TextEditingController _searchTextEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fetch books data when the page loads
    WidgetsBinding.instance.addPostFrameCallback((_) => context.read<BooksProvider>().fetchAllBooks());
  }

  @override
  void dispose() {
    _searchTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    
    return RefreshIndicator(
      onRefresh: () async {
        await context.read<BooksProvider>().fetchAllBooks(forceRefresh: true);
      },
      child: Consumer<BooksProvider>(
        builder: (context, booksProvider, child) {
          return CustomScrollView(
            slivers: [
              // Header Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
                  child: Column(
                    spacing: 20,
                    children: [
                      _buildHeader(),
                      _buildSearchBar(),
                      _buildCategoryFilter(),
                    ],
                  ),
                ),
              ),

              // Content Sections
              if (booksProvider.isLoading && !booksProvider.hasCache)
                ..._buildShimmerSections(size)
              else if (booksProvider.error != null && !booksProvider.hasCache)
                _buildErrorSection(size, booksProvider)
              else
                ..._buildContentSections(size, booksProvider),

              // Add some bottom padding
              const SliverToBoxAdapter(
                child: SizedBox(height: 20),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 10,
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(AppAvatars.avatar1),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Hi, Sheraz", style: AppTextStyles.titleTextStyle),
                Text("Good Morning", style: AppTextStyles.regularTextStyle),
              ],
            ),
          ],
        ),
        IconButton(
          onPressed: () {},
          icon: SvgPicture.asset(AppIcons.icNotification),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return SizedBox(
      height: 45,
      child: TextField(
        controller: _searchTextEditingController,
        decoration: InputDecoration(
          fillColor: AppColors.textFieldFillColor,
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(99),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(99),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
          hintText: 'Search books',
          hintStyle: AppTextStyles.smallTextStyle,
          prefixIcon: const Icon(Icons.search_rounded),
        ),
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return SizedBox(
      height: 35,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: AppData.genres.length,
        itemBuilder: (ctx, index) {
          bool isSelected = _selectedCategoryIndex == index;
          return Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isSelected ? Colors.black : AppColors.textFieldFillColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(99),
                ),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onPressed: () => setState(() => _selectedCategoryIndex = index),
              child: Text(
                AppData.genres[index],
                textAlign: TextAlign.center,
                style: AppTextStyles.smallTextStyle.copyWith(
                  color: isSelected ? Colors.white : Colors.black,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildShimmerSections(Size size) {
    return [
      SliverToBoxAdapter(
        child: HomeSectionShimmer(width: size.width, title: 'Trending Now'),
      ),
      const SliverToBoxAdapter(child: SizedBox(height: 20)),
      SliverToBoxAdapter(
        child: HomeSectionShimmer(width: size.width, title: 'Quick Reads'),
      ),
      const SliverToBoxAdapter(child: SizedBox(height: 20)),
      SliverToBoxAdapter(
        child: HomeSectionShimmer(width: size.width, title: 'Popular in Business'),
      ),
      const SliverToBoxAdapter(child: SizedBox(height: 20)),
      SliverToBoxAdapter(
        child: HomeSectionShimmer(width: size.width, title: 'Recently Added'),
      ),
    ];
  }

  Widget _buildErrorSection(Size size, BooksProvider booksProvider) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: size.height * 0.4,
        width: size.width,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.grey),
              const SizedBox(height: 16),
              Text('Error: ${booksProvider.error}', style: AppTextStyles.smallTextStyle),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => booksProvider.fetchAllBooks(forceRefresh: true),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildContentSections(Size size, BooksProvider booksProvider) {
    return [
      // Trending Now Section
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: SizedBox(
            height: size.height * 0.4,
            width: size.width,
            child: HomePageCategoriesBooksWidget(
              width: size.width * 0.45,
              icon: Icons.trending_up,
              title: 'Trending Now',
              books: booksProvider.trendingBooks,
              onSeeAllTap: () {},
            ),
          ),
        ),
      ),
      const SliverToBoxAdapter(child: SizedBox(height: 20)),

      // Quick Reads Section
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: SizedBox(
            height: size.height * 0.4,
            width: size.width,
            child: HomePageCategoriesBooksWidget(
              width: size.width * 0.45,
              icon: Icons.access_time_rounded,
              title: 'Quick Reads',
              books: booksProvider.quickReads,
              onSeeAllTap: () {},
            ),
          ),
        ),
      ),
      const SliverToBoxAdapter(child: SizedBox(height: 20)),

      // Popular in Business Section
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: SizedBox(
            height: size.height * 0.4,
            width: size.width,
            child: HomePageCategoriesBooksWidget(
              width: size.width * 0.45,
              icon: Icons.star_border_rounded,
              title: 'Popular in Business',
              books: booksProvider.popularBusinessBooks,
              onSeeAllTap: () {},
            ),
          ),
        ),
      ),
      const SliverToBoxAdapter(child: SizedBox(height: 20)),

      // Recently Added Section
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: SizedBox(
            height: size.height * 0.4,
            width: size.width,
            child: HomePageCategoriesBooksWidget(
              width: size.width * 0.45,
              icon: Icons.fiber_new_rounded,
              title: 'Recently Added',
              books: booksProvider.recentlyAddedBooks,
              onSeeAllTap: () {},
            ),
          ),
        ),
      ),

      // Show refresh indicator if refreshing in background
      if (booksProvider.isRefreshing)
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 8),
                  Text('Updating...', style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
          ),
        ),
    ];
  }
}
