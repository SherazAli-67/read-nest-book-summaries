import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../res/app_colors.dart';
import '../res/app_textstyle.dart';

class HomePageCategoriesBooksWidget extends StatelessWidget{
  const HomePageCategoriesBooksWidget(
      {super.key, required double width, required IconData icon, required String title, required VoidCallback onSeeAllTap})
      : _width = width,
        _icon = icon,
        _title = title,
        _onSeeAllTap = onSeeAllTap;
  final double _width;
  final IconData _icon;
  final String _title;
  final VoidCallback _onSeeAllTap;
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
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, index) {
                return SizedBox(
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
                              CachedNetworkImage(imageUrl: 'https://www.classificationoffice.govt.nz/media/images/killers_of_the_flower_moon.width-1200.jpg', fit: BoxFit.cover,width: _width,),
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
                                            Text('15 min', style: AppTextStyles.smallTextStyle.copyWith(fontSize: 12, fontWeight: FontWeight.w600),)
                                          ],
                                        ),
                                      ))),
                            ],
                          )),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Killers of the FLOWER MOON", style: AppTextStyles.smallTextStyle.copyWith(fontWeight: FontWeight.w600),),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Text('David Grann', style: AppTextStyles.smallTextStyle.copyWith(fontSize: 12),),
                              )
                            ],
                          )

                        ],
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