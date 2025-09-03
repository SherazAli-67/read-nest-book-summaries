import 'package:flutter/material.dart';
import 'package:read_nest/src/models/book_model.dart';
import 'package:read_nest/src/res/app_colors.dart';
import 'package:read_nest/src/res/app_textstyle.dart';

class SummaryInsightsWidget extends StatelessWidget{
  const SummaryInsightsWidget({super.key, required Book book}) : _book = book;
  final Book _book;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        spacing: 20,
        children: [
          Row(
            spacing: 10,
            children: [
              Icon(Icons.emoji_events, color: Colors.grey,),
              Text("Key insights", style: AppTextStyles.smallTextStyle,)
            ],
          ),
          Column(
            spacing: 15,
            children: List.generate(_book.sections.length, (index){
              String title = _book.sections[index].title;
              return Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.textFieldFillColor.withValues(alpha: 0.4)
                ),
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Row(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 15,
                      backgroundColor: Colors.black,
                      child: Center(child: Text('${index+1}', style: AppTextStyles.smallTextStyle.copyWith(color: Colors.white),),),
                    ),
                    Expanded(child: Text(title, style: AppTextStyles.smallTextStyle,))
                  ],
                ),
              );
            }),
          )
        ],
      ),
    );
  }

}