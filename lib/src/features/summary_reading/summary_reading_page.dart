import 'package:flutter/material.dart';
import 'package:read_nest/src/features/summary_reading/reading_chapter_widget.dart';
import 'package:read_nest/src/models/book_model.dart';
import 'package:read_nest/src/res/app_colors.dart';
import 'package:read_nest/src/res/app_textstyle.dart';
import 'package:read_nest/src/widgets/on_boarding_dot_widget.dart';

class SummaryReadingPage extends StatefulWidget{
  const SummaryReadingPage({super.key, required Book book}): _book = book;
  final Book _book;

  @override
  State<SummaryReadingPage> createState() => _SummaryReadingPageState();
}

class _SummaryReadingPageState extends State<SummaryReadingPage> {
  int _currentReadingChapter =0;  // 0 for introduction, 1 for _book.sections[0], 2 for _book.sections[1], and so on.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(onPressed: (){}, icon: Icon(Icons.arrow_back_rounded)),
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.bookmark_border_rounded)),
          IconButton(onPressed: (){}, icon: Icon(Icons.dark_mode_outlined)),
          IconButton(onPressed: (){}, icon: Icon(Icons.more_horiz)),
        ],
      ),
      body: SafeArea(child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          spacing: 10,
          children: [
            Expanded(child: SingleChildScrollView(child: Column(
              spacing: 20,
              children: [
                Column(
                  spacing: 10,
                  children: [
                    Row(
                      mainAxisAlignment:  MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Introduction', style: AppTextStyles.smallTextStyle,),
                        Row(
                          spacing: 10,
                          children: [
                            Icon(Icons.access_time_rounded, color: Colors.grey, size: 20,),
                            Text("23:33", style: AppTextStyles.smallTextStyle.copyWith(fontSize: 12, color: Colors.grey),),
                            Text("20%", style: AppTextStyles.smallTextStyle.copyWith(fontSize: 12,),)
                          ],
                        )
                      ],
                    ),

                    LinearProgressIndicator(value: 0.3, color: Colors.black, backgroundColor: AppColors.textFieldFillColor,)
                  ],
                ),
                Column(
                  spacing: 10,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(99),
                          color: AppColors.textFieldFillColor
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                      child: Text('Chapter $_currentReadingChapter of ${widget._book.sections.length}', style: AppTextStyles.smallTextStyle.copyWith(fontWeight: FontWeight.w600),),
                    ),
                    Text(widget._book.bookName, style: AppTextStyles.headingTextStyle,),
                    Text('by ${widget._book.author}', style: AppTextStyles.smallTextStyle,),

                  ],
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(99),
                        color: AppColors.textFieldFillColor.withValues(alpha: 0.4)
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                    child: Text('2 min read', style: AppTextStyles.smallTextStyle),
                  ),
                ),
                Text(_currentReadingChapter == 0 ? widget._book.introduction : widget._book.sections[_currentReadingChapter].content)

              ],
            ),),),


            Card(
              elevation: 0,
              shape: InputBorder.none,
              color: Colors.white,
              margin: EdgeInsets.zero,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(onPressed: ()=> setState(() => _currentReadingChapter--), child: Row(
                    spacing: 5,
                    children: [
                      Icon(Icons.arrow_back_ios_new_rounded, size: 15,),
                      Text('Previous', style: AppTextStyles.smallTextStyle,)
                    ],
                  )),
                  OnBoardingDotWidget(dotsLength: widget._book.sections.length+1, isDarkTheme: false, currentPage: _currentReadingChapter),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black
                      ),
                      onPressed: ()=> setState(() => _currentReadingChapter++), child: Row(
                    children: [
                      Text('Next', style: AppTextStyles.smallTextStyle.copyWith(color: Colors.white),),
                      Icon(Icons.navigate_next, color: Colors.white,)
                    ],
                  ))
                ],
              ),
            )
          ],
        ),
      )),
    );
  }
}