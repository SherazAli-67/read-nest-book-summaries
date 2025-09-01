import 'package:flutter/material.dart';
import 'package:read_nest/src/res/app_colors.dart';
import 'package:read_nest/src/res/app_textstyle.dart';

class BookMarkPage extends StatelessWidget{
  const BookMarkPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        spacing: 10,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.textFieldFillColor,
              shape: BoxShape.circle
            ),
            child: Icon(Icons.favorite_border),
          ),
          Text("No Favorites Yet", style: AppTextStyles.titleTextStyle,),
          Text("Start exploring books and tap the heart icon to save your favorites",textAlign: TextAlign.center, style: AppTextStyles.smallTextStyle,)
        ],
      ),
    ));
  }
}