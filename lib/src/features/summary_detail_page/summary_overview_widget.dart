import 'package:flutter/material.dart';
import 'package:read_nest/src/models/book_model.dart';
import 'package:read_nest/src/res/app_colors.dart';
import 'package:read_nest/src/res/app_textstyle.dart';

class SummaryOverviewWidget extends StatelessWidget{
  const SummaryOverviewWidget({super.key, required Book book}) : _book = book;
  final Book _book;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColors.textFieldFillColor.withValues(alpha: 0.4)
            ),
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Column(
              spacing: 20,
              children: [
                Row(
                  spacing: 10,
                  children: [
                    Icon(Icons.menu_book_rounded),
                    Text("Book Summary", style: AppTextStyles.smallTextStyle,)
                  ],
                ),
                Text(_book.shortSummary, style: AppTextStyles.smallTextStyle,)
              ],
            ),
          ),
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent, splashColor: Colors.transparent ),
            child: ExpansionTile(
              dense: true,

              title: Text('About ${_book.author}', style: AppTextStyles.smallTextStyle.copyWith(fontWeight: FontWeight.w600),),
              subtitle: Text("Author", style: AppTextStyles.smallTextStyle,),
              children: [
                Text(_book.aboutAuthor, style: AppTextStyles.smallTextStyle,)
              ],
            ),
          )
        ],
      ),
    );
  }

}