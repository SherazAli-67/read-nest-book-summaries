import 'package:flutter/material.dart';

import '../features/search_page.dart';
import '../res/app_colors.dart';
import '../res/app_textstyle.dart';

class SearchBarClickableWidget extends StatelessWidget {
  const SearchBarClickableWidget({
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SearchPage()),
        );
      },
      child: Container(
        decoration: BoxDecoration(
            color: AppColors.textFieldFillColor,
            borderRadius: BorderRadius.circular(99)
        ),
        padding: EdgeInsets.all(10),
        child: Row(
          spacing: 5,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.search_rounded),
            Text("Search summaries", style: AppTextStyles.smallTextStyle,)
          ],
        ),
      ),
    );
  }
}