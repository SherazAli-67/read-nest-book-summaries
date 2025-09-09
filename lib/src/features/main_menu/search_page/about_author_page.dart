import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:read_nest/src/models/author_spotlight_model.dart';
import 'package:read_nest/src/res/app_colors.dart';
import 'package:read_nest/src/res/app_textstyle.dart';

class AboutAuthorPage extends StatefulWidget{
  const AboutAuthorPage({super.key, required AuthorSpotlight author}): _author = author;
  final AuthorSpotlight _author;

  @override
  State<AboutAuthorPage> createState() => _AboutAuthorPageState();
}

class _AboutAuthorPageState extends State<AboutAuthorPage> {
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
      body: SafeArea(child: Column(
        spacing: 20,
        children: [
          _buildSearchBar(),
          Container(
            color: AppColors.textFieldFillColor,
            padding: EdgeInsets.all(10),
            child: Column(
              spacing: 20,
              children: [
                Row(
                  children: [
                    IconButton(onPressed: ()=> Navigator.pop(context), icon: Icon(Icons.arrow_back_rounded)),
                    Text("Back to authors", style: AppTextStyles.smallTextStyle,)
                  ],
                ),
                Row(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: CachedNetworkImage(imageUrl: widget._author.books.first.image, fit: BoxFit.cover, height: 75,),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 5,
                        children: [
                          Text(widget._author.authorName, style: AppTextStyles.regularTextStyle,),
                          Text(widget._author.books.first.aboutAuthor, maxLines: 5, overflow: TextOverflow.ellipsis, style: AppTextStyles.smallTextStyle.copyWith(color: Colors.grey),)
                        ],
                      ),
                    )
                  ],
                ),
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  spacing: 10,
                  children: [
                    _buildAuthorInfoWidget(value: '850k', title: 'Followers'),
                    _buildAuthorInfoWidget(value: '${widget._author.books.length}', title: 'Books'),
                    _buildAuthorInfoWidget(value: '4.5', title: 'Rating'),

                  ],
                )
              ],
            ),
          )
        ],
      )),
    );
  }

  Widget _buildAuthorInfoWidget({required String value, required String title}) {
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

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: SizedBox(
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
      ),
    );
  }
}