import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:read_nest/src/res/app_icons.dart';
import 'package:read_nest/src/res/app_textstyle.dart';
import '../../../res/app_colors.dart';
import '../../../providers/books_provider.dart';
import '../../../providers/categories_provider.dart';
import '../../../models/author_spotlight_model.dart';
import '../../../widgets/shimmer_widgets.dart';
import '../../../widgets/category_widgets.dart';
import 'about_author_page.dart';
import 'authors_spotlight_page.dart';

class DiscoverPage extends StatefulWidget{
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  final TextEditingController _searchTextEditingController = TextEditingController();
  final List<String>  _trendingSearches = [
    'Productivity', 'Motivation', 'Leadership', 'Business',  'Money', 'Psychology'
  ];
  String _selectedTrending = '';
  
  @override
  void initState() {
    super.initState();
    // Fetch categories when the page loads
    WidgetsBinding.instance.addPostFrameCallback((_)=> context.read<CategoriesProvider>().fetchCategories());
  }
  
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
      child: Column(
        spacing: 20,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Discover", style: AppTextStyles.regularTextStyle,),
              Icon(Icons.filter_alt_rounded)
            ],
          ),
          SizedBox(
            height: 45,
            child: TextField(
              controller: _searchTextEditingController,
              decoration: InputDecoration(
                  fillColor: AppColors.textFieldFillColor.withValues(alpha: 0.5),
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(99),
                      borderSide: BorderSide(color: Colors.transparent)
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(99),
                      borderSide: BorderSide(color: Colors.transparent)
                  ),
                  hintText: 'Search books',
                  hintStyle: AppTextStyles.smallTextStyle,
                  prefixIcon: Icon(Icons.search_rounded)
              ),
            ),
          ),
          _buildTrendingSearches(),
          _buildAuthorsSpotLight(),
          _buildReadingGoals(),
          _buildMostSearchedThisWeek(),
          _buildAllCategories()
        ],
      ),
    );
  }

  Widget _buildTrendingSearches() {
    return Column(
      spacing: 10,
      children: [
        Row(
          spacing: 5,
          children: [
            Icon(Icons.trending_up, color: Colors.black, size: 20,),
            Text("Trending searches", style: AppTextStyles.smallTextStyle,),
          ],
        ),
        Wrap(
          children: _trendingSearches.map((trending){
            bool isSelected = _selectedTrending == trending;
            return Padding(
              padding: const EdgeInsets.only(right: 10.0, bottom: 10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: isSelected ? Colors.black : AppColors.textFieldFillColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(99)
                    ),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap
                ),
                onPressed: ()=> setState(()=> _selectedTrending = trending), child: Text(trending, textAlign: TextAlign.center, style: AppTextStyles.smallTextStyle.copyWith(color: isSelected ? Colors.white : Colors.black),),),
            );
          }).toList(),
        )
      ],
    );
  }

  _buildAuthorsSpotLight() {
    return Consumer<BooksProvider>(
      builder: (context, booksProvider, child) {
        return Column(
          spacing: 10,
          children: [
            Row(
              children: [
                Expanded(
                  child: Row(
                    spacing: 5,
                    children: [
                      Icon(Icons.stars_rounded, color: Colors.black, size: 20,),
                      Text("Authors Spotlight", style: AppTextStyles.smallTextStyle,),
                    ],
                  ),
                ),
                TextButton(onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (_)=> AuthorsSpotLightPage()));
                }, child: Text("See All"))
              ],
            ),
            SizedBox(
              height: 150,
              child: booksProvider.isLoading && !booksProvider.hasCache
                  ? const AuthorSpotlightShimmer()
                  : booksProvider.authorsSpotlight.isEmpty
                      ? Center(
                          child: Text(
                            'No authors found',
                            style: AppTextStyles.smallTextStyle.copyWith(
                              color: Colors.grey,
                            ),
                          ),
                        )
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: booksProvider.authorsSpotlight.length,
                          itemBuilder: (ctx, index) {
                            AuthorSpotlight author = booksProvider.authorsSpotlight[index];
                            return GestureDetector(
                              onTap: ()=> Navigator.of(context).push(MaterialPageRoute(builder: (_)=> AboutAuthorPage(author: author))),
                              child: Container(
                                width: 160,
                                margin: EdgeInsets.only(right: 10),
                                decoration: BoxDecoration(
                                  color: author.categoryColor.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  spacing: 8,
                                  children: [
                                    Icon(
                                      author.categoryIcon,
                                      color: author.categoryColor,
                                      size: 24,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            author.authorName,
                                            style: AppTextStyles.smallTextStyle.copyWith(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 13,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(height: 2),
                                          Text(
                                            author.primaryCategory,
                                            style: AppTextStyles.smallTextStyle.copyWith(
                                              fontSize: 10,
                                              color: Colors.grey[600],
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(height: 2),
                                          Text(
                                            '${author.totalBooks} ${author.totalBooks == 1 ? 'book' : 'books'}',
                                            style: AppTextStyles.smallTextStyle.copyWith(
                                              fontSize: 12,
                                              color: Colors.grey[700],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Book thumbnails
                                    Wrap(
                                      spacing: 3,
                                      children: author.books.take(4).map((book) {
                                        return ClipRRect(
                                          borderRadius: BorderRadius.circular(2),
                                          child: CachedNetworkImage(
                                            imageUrl: book.image.isNotEmpty
                                                ? book.image
                                                : AppIcons.dummyBookImageUrl2,
                                            height: 22,
                                            width: 16,
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) => Container(
                                              height: 22,
                                              width: 16,
                                              color: Colors.grey[300],
                                              child: Icon(
                                                Icons.book,
                                                size: 12,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                            errorWidget: (context, url, error) => Container(
                                              height: 22,
                                              width: 16,
                                              color: Colors.grey[300],
                                              child: Icon(
                                                Icons.book,
                                                size: 12,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        );
      },
    );
  }

  _buildReadingGoals() {
    return SizedBox(
      height: 450,
      child: Column(
        spacing: 10,
        children: [
          Row(
            spacing: 5,
            children: [
              Icon(Icons.ac_unit_rounded, color: Colors.black, size: 20,),
              Text("Reading Goals", style: AppTextStyles.smallTextStyle,),
            ],
          ),
          Expanded(
            child: GridView.builder(
                itemCount: 4,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 15), itemBuilder: (_, index){
              return Container(
                margin: EdgeInsets.only(right: 10, bottom: 10),
                decoration: BoxDecoration(
                    color: AppColors.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10)
                ),
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10,
                  children: [
                    Icon(Icons.attach_money_rounded, color: Colors.amber,),
                    Text("Wealth Building", style: AppTextStyles.smallTextStyle.copyWith(fontWeight: FontWeight.w600),),
                    Text('4 books', style: AppTextStyles.smallTextStyle.copyWith(fontSize: 12),),
                    Wrap(
                      spacing: 5,
                      children: List.generate(4, (index){
                        return ClipRRect(
                            borderRadius: BorderRadius.circular(2),
                            child: CachedNetworkImage(imageUrl: AppIcons.dummyBookImageUrl2, height: 25,));
                      }),
                    )
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  _buildMostSearchedThisWeek() {
    return Column(
      spacing: 10,
      children: [
        Row(
          spacing: 5,
          children: [
            Icon(Icons.trending_up, color: Colors.black, size: 20,),
            Text("Most Searched This Week", style: AppTextStyles.smallTextStyle,),
          ],
        ),
        Column(
          children: List.generate(3, (index){
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.black,
                radius: 10,
                child: Center(child: Text('${index+1}', style: AppTextStyles.smallTextStyle.copyWith(color: Colors.white, fontSize: 12),),),
              ),
              title: Text('Productivity', style: AppTextStyles.regularTextStyle,),
              subtitle: Text('2.1k searches', style: TextStyle(fontSize: 12, color: Colors.grey),),
              trailing: SizedBox(
                width: 100,
                child: Row(
                  spacing: 2,
                  children: List.generate(2, (index){
                  return ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: CachedNetworkImage(imageUrl: AppIcons.dummyBookImageUrl2, height: 25,));
                }),),
              ),
            );
          }),
        )
      ],
    );
  }

  Widget _buildAllCategories() {
    return Consumer<CategoriesProvider>(
      builder: (context, categoriesProvider, child) {
        // Show shimmer while loading and no cache
        if (categoriesProvider.isLoadingCategories && !categoriesProvider.hasCategoriesCache) {
          return const CategoriesGridShimmer(itemCount: 6);
        }

        // Show error state
        if (categoriesProvider.categoriesError != null && !categoriesProvider.hasCategoriesCache) {
          return CategoriesErrorState(
            error: categoriesProvider.categoriesError!,
            onRetry: () => categoriesProvider.fetchCategories(forceRefresh: true),
          );
        }

        // Show empty state
        if (categoriesProvider.categories.isEmpty) {
          return const CategoriesEmptyState();
        }

        // Calculate dynamic height
        final dynamicHeight = categoriesProvider.calculateCategoriesGridHeight(
          categoriesProvider.categories.length,
        );

        return SizedBox(
          height: dynamicHeight,
          child: Column(
            spacing: 20,
            children: [
              // Section header
              Row(
                spacing: 5,
                children: [
                  Icon(Icons.star_border_rounded, color: Colors.black, size: 20),
                  Text("Browse All Categories", style: AppTextStyles.smallTextStyle),
                ],
              ),
              
              // Categories grid
              Expanded(
                child: GridView.builder(
                  itemCount: categoriesProvider.categories.length,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 3 / 2,
                  ),
                  itemBuilder: (context, index) {

                    final category = categoriesProvider.categories[index];
                    return CategoryCard(
                      category: category,
                      onTap: () {
                        // TODO: Navigate to category books page
                        debugPrint('Tapped on category: ${category.title}');
                      },
                    );
                  },
                ),
              ),

              // Show refresh indicator if refreshing in background
              if (categoriesProvider.isRefreshingCategories)
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      SizedBox(width: 8),
                      Text('Updating categories...', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
