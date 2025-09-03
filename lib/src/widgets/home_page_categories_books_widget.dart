import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:read_nest/src/features/summary_detail_page/summary_detail_page.dart';
import 'package:read_nest/src/models/book_model.dart';

import '../res/app_colors.dart';
import '../res/app_textstyle.dart';

class HomePageCategoriesBooksWidget extends StatelessWidget{
  const HomePageCategoriesBooksWidget(
      {super.key, required double width, required IconData icon, required String title, required VoidCallback onSeeAllTap, required List<Book> books})
      : _width = width,
        _icon = icon,
        _title = title,
        _onSeeAllTap = onSeeAllTap,
        _books = books;
  final double _width;
  final IconData _icon;
  final String _title;
  final VoidCallback _onSeeAllTap;
  final List<Book> _books;
  @override
  Widget build(BuildContext context) {
    
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              spacing: 5,
              children: [
                Icon(_icon, color: Colors.black, size: 20,),
                Text(_title, style: AppTextStyles.smallTextStyle,),
              ],
            ),
            TextButton(onPressed: _onSeeAllTap, child: Text("See All", style: AppTextStyles.smallTextStyle))
          ],
        ),

        Expanded(
          child: _books.isEmpty 
            ? Center(child: Text('No books available', style: AppTextStyles.smallTextStyle))
            : ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _books.length,
                itemBuilder: (_, index) {
                  final book = _books[index];
                  return GestureDetector(
                    onTap: ()=> Navigator.of(context).push(
                      MaterialPageRoute(builder: (_)=> SummaryDetailPage())
                    ),
                    child: SizedBox(
                      width:_width,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 15,
                            children: [
                              Expanded(child: Stack(
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: book.image.isNotEmpty 
                                      ? book.image 
                                      : 'https://via.placeholder.com/300x400/E0E0E0/757575?text=No+Image', 
                                    fit: BoxFit.cover,
                                    width: _width,
                                    errorWidget: (context, url, error) => Container(
                                      width: _width,
                                      color: Colors.grey[300],
                                      child: Icon(Icons.book, size: 50, color: Colors.grey[600]),
                                    ),
                                  ),
                                  Positioned(
                                      right: 10,
                                      top: 10,
                                      child: Container(
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                            color: AppColors.textFieldFillColor,
                                            shape: BoxShape.circle
                                        ),
                                        child: Icon(Icons.favorite_border, color: Colors.black45, size: 18,),)),
                                  Positioned(
                                      left: 10,
                                      bottom: 10,
                                      child: Container(
                                          padding: EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                              color: AppColors.textFieldFillColor,
                                              borderRadius: BorderRadius.circular(99)
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                            child: Row(
                                              spacing: 4,
                                              children: [
                                                Icon(Icons.access_time_outlined, size: 18,),
                                                Text(book.time, style: AppTextStyles.smallTextStyle.copyWith(fontSize: 12, fontWeight: FontWeight.w600),)
                                              ],
                                            ),
                                          ))),
                                ],
                              )),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(book.bookName, 
                                    style: AppTextStyles.smallTextStyle.copyWith(fontWeight: FontWeight.w600),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Text(book.author, 
                                      style: AppTextStyles.smallTextStyle.copyWith(fontSize: 12),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  )
                                ],
                              )

                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
        ),
      ],
    );
  }
  
}
