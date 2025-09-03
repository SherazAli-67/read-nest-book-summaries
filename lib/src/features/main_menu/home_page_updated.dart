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

class UpdatedHomePage extends StatefulWidget{
  const UpdatedHomePage({super.key});

  @override
  State<UpdatedHomePage> createState() => _UpdatedHomePageState();
}

class _UpdatedHomePageState extends State<UpdatedHomePage> {
  int _selectedCategoryIndex = 0;
  final TextEditingController _searchTextEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fetch books data when the page loads
    WidgetsBinding.instance.addPostFrameCallback((_)=>  context.read<BooksProvider>().fetchAllBooks());
  }

  @override
  void dispose() {
    _searchTextEditingController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
      child: Column(
        spacing: 20,
        children: [
          Row(
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
                      Text("Hi, Sheraz", style: AppTextStyles.titleTextStyle,),
                      Text("Good Morning", style: AppTextStyles.regularTextStyle,)
                    ],
                  )
                ],
              ),
              IconButton(onPressed: (){}, icon: SvgPicture.asset(AppIcons.icNotification))
            ],
          ),
          SizedBox(
            height: 45,
            child: TextField(
              controller: _searchTextEditingController,
              decoration: InputDecoration(
                fillColor: AppColors.textFieldFillColor,
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
          SizedBox(
            height: 35,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
                itemCount: AppData.genres.length,
                itemBuilder: (ctx, index){
                bool isSelected = _selectedCategoryIndex == index;
                return Padding(
                  padding: const EdgeInsets.only(right: 10.0,),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isSelected ? Colors.black : AppColors.textFieldFillColor,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(99)
                      ),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap
                    ),
                    onPressed: ()=> setState(()=> _selectedCategoryIndex = index), child: Text(AppData.genres[index], textAlign: TextAlign.center, style: AppTextStyles.smallTextStyle.copyWith(color: isSelected ? Colors.white : Colors.black),),),
                );

            }),
          ),
          // Trending Now Section
          Consumer<BooksProvider>(
            builder: (context, booksProvider, child) {
              // debugPrint("UI Consumer - Loading: ${booksProvider.isLoading}");
              // debugPrint("UI Consumer - Error: ${booksProvider.error}");
              // debugPrint("UI Consumer - Trending Books Count: ${booksProvider.trendingBooks.length}");
              //
              if (booksProvider.isLoading) {
                return SizedBox(
                  height: size.height*0.4,
                  width: size.width,
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              
              if (booksProvider.error != null) {
                return SizedBox(
                  height: size.height*0.4,
                  width: size.width,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Error: ${booksProvider.error}', style: AppTextStyles.smallTextStyle),
                        SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () => booksProvider.fetchAllBooks(),
                          child: Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                );
              }
              
              return SizedBox(
                height: size.height*0.4,
                width: size.width,
                child: HomePageCategoriesBooksWidget(
                  width: size.width*0.45, 
                  icon: Icons.trending_up, 
                  title: 'Trending Now', 
                  books: booksProvider.trendingBooks,
                  onSeeAllTap: (){}
                ),
              );
            },
          ),

          // Quick Reads Section
          Consumer<BooksProvider>(
            builder: (context, booksProvider, child) {
              return SizedBox(
                height: size.height*0.4,
                width: size.width,
                child: HomePageCategoriesBooksWidget(
                  width: size.width*0.45, 
                  icon: Icons.access_time_rounded, 
                  title: 'Quick Reads', 
                  books: booksProvider.quickReads,
                  onSeeAllTap: (){}
                ),
              );
            },
          ),

          // Popular in Business Section
          Consumer<BooksProvider>(
            builder: (context, booksProvider, child) {
              return SizedBox(
                height: size.height*0.4,
                width: size.width,
                child: HomePageCategoriesBooksWidget(
                  width: size.width*0.45, 
                  icon: Icons.star_border_rounded, 
                  title: 'Popular in Business', 
                  books: booksProvider.popularBusinessBooks,
                  onSeeAllTap: (){}
                ),
              );
            },
          ),

          // Recently Added Section
          Consumer<BooksProvider>(
            builder: (context, booksProvider, child) {
              return SizedBox(
                height: size.height*0.4,
                width: size.width,
                child: HomePageCategoriesBooksWidget(
                  width: size.width*0.45, 
                  icon: Icons.fiber_new_rounded, 
                  title: 'Recently Added', 
                  books: booksProvider.recentlyAddedBooks,
                  onSeeAllTap: (){}
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
