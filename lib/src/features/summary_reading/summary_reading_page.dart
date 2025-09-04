import 'dart:async';
import 'package:flutter/material.dart';
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

class _SummaryReadingPageState extends State<SummaryReadingPage> 
    with TickerProviderStateMixin {
  int _currentReadingChapter = 0;
  late AnimationController _progressAnimationController;
  late Animation<double> _progressAnimation;
  Timer? _pageTimer;
  final Stopwatch _stopwatch = Stopwatch();
  int _pageTimeInSeconds = 0;

  @override
  void initState() {
    super.initState();
    _progressAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: _readingProgress,
    ).animate(CurvedAnimation(
      parent: _progressAnimationController,
      curve: Curves.easeInOut,
    ));
    
    _startPageTimer();
    _progressAnimationController.forward();
  }

  @override
  void dispose() {
    _progressAnimationController.dispose();
    _stopPageTimer();
    super.dispose();
  }

  void _startPageTimer() {
    _stopwatch.start();
    _pageTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() => _pageTimeInSeconds = _stopwatch.elapsed.inSeconds);
    });
  }

  void _stopPageTimer() {
    _pageTimer?.cancel();
    _stopwatch.stop();
  }

  void _resetPageTimer() {
    _stopwatch.reset();
    _pageTimeInSeconds = 0;
    _stopwatch.start();
  }

  void _animateToNewProgress() {
    final newProgress = _readingProgress;
    _progressAnimation = Tween<double>(
      begin: _progressAnimation.value,
      end: newProgress,
    ).animate(CurvedAnimation(
      parent: _progressAnimationController,
      curve: Curves.easeInOut,
    ));
    _progressAnimationController.reset();
    _progressAnimationController.forward();
  }

  // Helper method to calculate progress (0.0 to 1.0)
  double get _readingProgress {
    if (widget._book.sections.isEmpty) return 0.0;
    return (_currentReadingChapter + 1) / widget._book.sections.length;
  }

  // Helper method to calculate reading percentage
  int get _readingPercentage {
    return (_readingProgress * 100).round();
  }

  // Helper method to calculate word count in content
  int _calculateWordCount(String content) {
    if (content.isEmpty) return 0;
    return content.split(RegExp(r'\s+')).where((word) => word.isNotEmpty).length;
  }

  // Helper method to calculate estimated reading time for current section
  String get _estimatedReadingTime {
    if (widget._book.sections.isEmpty || _currentReadingChapter >= widget._book.sections.length) {
      return "0 min read";
    }
    
    final content = widget._book.sections[_currentReadingChapter].content;
    final wordCount = _calculateWordCount(content);
    final readingTimeMinutes = (wordCount / 175).ceil(); // 250 words per minute average
    
    return "$readingTimeMinutes min read";
  }

  // Helper method to format page time spent
  String get _pageTimeFormatted {
    final minutes = _pageTimeInSeconds ~/ 60;
    final seconds = _pageTimeInSeconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  // Helper method to check if we can go to previous chapter
  bool get _canGoPrevious => _currentReadingChapter > 0;

  // Helper method to check if we can go to next chapter
  bool get _canGoNext => _currentReadingChapter < widget._book.sections.length - 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(onPressed: ()=> Navigator.of(context).pop(), icon: Icon(Icons.arrow_back_rounded)),
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
                        Text('Chapter ${_currentReadingChapter+1}', style: AppTextStyles.smallTextStyle,),
                        Row(
                          spacing: 10,
                          children: [
                            Icon(Icons.access_time_rounded, color: Colors.grey, size: 20,),
                            Text(_pageTimeFormatted, style: AppTextStyles.smallTextStyle.copyWith(fontSize: 12, color: Colors.grey),),
                            Text("$_readingPercentage%", style: AppTextStyles.smallTextStyle.copyWith(fontSize: 12,),)
                          ],
                        )
                      ],
                    ),

                    AnimatedBuilder(
                      animation: _progressAnimation,
                      builder: (context, child) {
                        return LinearProgressIndicator(
                          value: _progressAnimation.value, 
                          color: Colors.black, 
                          backgroundColor: AppColors.textFieldFillColor,
                        );
                      },
                    )
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
                      child: Text('Chapter ${_currentReadingChapter+1} of ${widget._book.sections.length}', style: AppTextStyles.smallTextStyle.copyWith(fontWeight: FontWeight.w600),),
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
                    child: Text(_estimatedReadingTime, style: AppTextStyles.smallTextStyle),
                  ),
                ),
                Text(widget._book.sections[_currentReadingChapter].content)

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
                  TextButton(
                    onPressed: _canGoPrevious ? () {
                      setState(() => _currentReadingChapter--);
                      // _resetPageTimer();
                      _animateToNewProgress();
                    } : null,
                    child: Row(
                      spacing: 5,
                      children: [
                        Icon(Icons.arrow_back_ios_new_rounded, size: 15, color: _canGoPrevious ? null : Colors.grey),
                        Text('Previous', style: AppTextStyles.smallTextStyle.copyWith(color: _canGoPrevious ? null : Colors.grey),)
                      ],
                    )),
                  OnBoardingDotWidget(dotsLength: widget._book.sections.length, isDarkTheme: false, currentPage: _currentReadingChapter),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: _canGoNext ? Colors.black : Colors.grey
                      ),
                      onPressed: _canGoNext ? () {
                        setState(() => _currentReadingChapter++);
                        // _resetPageTimer();
                        _animateToNewProgress();
                      } : null,
                      child: Row(
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
