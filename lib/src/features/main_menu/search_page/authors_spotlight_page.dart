import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:read_nest/src/models/author_spotlight_model.dart';
import 'package:read_nest/src/providers/books_provider.dart';
import 'package:read_nest/src/res/app_colors.dart';
import 'package:read_nest/src/res/app_icons.dart';
import 'package:read_nest/src/res/app_textstyle.dart';

class AuthorsSpotLightPage extends StatefulWidget{
  const AuthorsSpotLightPage({super.key});

  @override
  State<AuthorsSpotLightPage> createState() => _AuthorsSpotLightPageState();
}

class _AuthorsSpotLightPageState extends State<AuthorsSpotLightPage> {
  final _searchTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(onPressed: ()=> Navigator.pop(context), icon: Icon(Icons.arrow_back_rounded)),
        title: Text("Authors Spotlight",style: AppTextStyles.regularTextStyle,)
      ),
      body: SafeArea(child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
        child: Consumer<BooksProvider>(
          builder: (context, provider, _) {
            return Column(
              spacing: 20,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSearchBar(),
                _buildFeaturedAuthorsTile(featuredAuthorsCount: provider.authorsSpotlight.length),
                Expanded(child: _buildBrowseAuthorsWidget(authors: provider.authorsSpotlight),)
              ],
            );
          }
        ),
      )),
    );
  }

  Widget _buildFeaturedAuthorsTile({required int featuredAuthorsCount}) {
    return Consumer<BooksProvider>(
      builder: (ctx, provider, _) {
        return ListTile(
                tileColor: AppColors.textFieldFillColor.withValues(alpha: 0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
                ),
                title: Text("Featured Authors", style: AppTextStyles.smallTextStyle.copyWith(fontWeight: FontWeight.w600),),
                subtitle: Text('Discover brilliant minds', style: AppTextStyles.smallTextStyle,),
                trailing: Column(
                  children: [
                    Text('$featuredAuthorsCount', style: AppTextStyles.regularTextStyle.copyWith(fontWeight: FontWeight.w600),),
                    Text("Authors", style: AppTextStyles.smallTextStyle,)
                  ],
                ),
              );
      }
    );
  }

  Widget _buildSearchBar() {
    return SizedBox(
      height: 45,
      child: TextField(
        controller: _searchTextEditingController,
        decoration: InputDecoration(
          fillColor: AppColors.textFieldFillColor.withValues(alpha: 0.3),
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(99),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(99),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
          hintText: 'Search authors',
          hintStyle: AppTextStyles.smallTextStyle,
          prefixIcon: const Icon(Icons.search_rounded),
        ),
      ),
    );
  }

  _buildBrowseAuthorsWidget({required List<AuthorSpotlight> authors}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Browse Authors", style: AppTextStyles.regularTextStyle,),
        Expanded(child: ListView.builder(
            itemCount: authors.length,
            itemBuilder: (_, index){
              AuthorSpotlight author = authors[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Material(
                  elevation: 1.0,
                  shadowColor: Colors.white,
                  child: ListTile(
                    tileColor: Colors.white,
                    titleAlignment: ListTileTitleAlignment.top,
                    title: Text(author.authorName, style: AppTextStyles.smallTextStyle.copyWith(fontWeight: FontWeight.w600),),
                    leading: CircleAvatar(
                      backgroundColor: AppColors.textFieldFillColor.withValues(alpha: 0.3),
                      child: Center(child: Icon(author.categoryIcon),),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 5,
                      children: [
                        Container(
                            padding: EdgeInsets.all(3),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(99),
                                color: AppColors.textFieldFillColor
                            ),
                            child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                child: Text(author.primaryCategory, style: AppTextStyles.smallTextStyle.copyWith(fontSize: 12, fontWeight: FontWeight.w600),)
                            )),

                        Text(author.books[0].aboutAuthor, maxLines: 2, overflow: TextOverflow.ellipsis, style: AppTextStyles.smallTextStyle,),
                        Row(
                          children: [
                            Expanded(child: Row(
                              spacing: 10,
                              children: [
                                Icon(Icons.menu_book_rounded, color: Colors.grey,),
                                Text('${author.books.length} books', style: TextStyle(fontSize: 12, color: Colors.grey),)
                              ],)),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(2),
                              child: CachedNetworkImage(
                                imageUrl: AppIcons.dummyBookImageUrl2,
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
                            )
                          ],
                        )
                      ],
                    ),
                    trailing: SizedBox(
                      width: 50,
                      child: Row(
                        spacing: 5,
                        children: [
                          Icon(Icons.person, color: Colors.grey, size: 15,),
                          Text("2.1M",style: TextStyle(fontSize: 10, color: Colors.grey),)
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }))
      ],
    );
  }
}