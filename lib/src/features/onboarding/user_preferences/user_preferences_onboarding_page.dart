import 'package:flutter/material.dart';
import 'package:read_nest/src/features/onboarding/user_preferences/choose_your_age_page.dart';
import 'package:read_nest/src/features/onboarding/user_preferences/choose_your_book_genre.dart';
import 'package:read_nest/src/features/onboarding/user_preferences/select_gender_page.dart';
import 'package:read_nest/src/features/widgets/app_back_button.dart';
import 'package:read_nest/src/features/widgets/primary_btn.dart';
import 'package:read_nest/src/res/app_colors.dart';

class UserPreferencesOnboardingPage extends StatefulWidget{
  const UserPreferencesOnboardingPage({super.key});

  @override
  State<UserPreferencesOnboardingPage> createState() => _UserPreferencesOnboardingPageState();
}

class _UserPreferencesOnboardingPageState extends State<UserPreferencesOnboardingPage> {
  late PageController _pageController;
  final List<Widget> _onboardingPages = [
    SelectGenderPage(),
    ChooseYourAgePage(),
    ChooseBookGenrePage()
  ];

  int _currentPageIndex = 0;

  @override
  void initState() {
    _pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    debugPrint("Current index: $_currentPageIndex");
    return Scaffold(
      body: SafeArea(child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
        child: Column(
          spacing: 20,
          children: [
            Row(
              spacing: 20,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppBackButton(),
                Expanded(child:  PercentProgressIndicator(percent: (_currentPageIndex+1)*0.33,))
              ],
            ),
            Expanded(child: PageView.builder(
              physics: NeverScrollableScrollPhysics(),
                controller: _pageController,
                onPageChanged: (val)=> setState(()=> _currentPageIndex = val),
                itemBuilder: (ctx, index){
                  return _onboardingPages[index];
            })),
            SizedBox(
                height: 55,
                width: double.infinity,
                child: PrimaryBtn(onTap: (){
                  _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
                }, btnText: "Continue"))
          ],
        ),
      )),
    );
  }
}


class PercentProgressIndicator extends StatefulWidget {
  final double percent;
  final Color progressColor;
  final double height;
  final double width;
  final double borderRadius;

  const PercentProgressIndicator({
    super.key,
    required this.percent,
    this.progressColor = AppColors.primaryColor,
    this.height = 10,
    this.width = 300,
    this.borderRadius = 12,
  });

  @override
  State<PercentProgressIndicator> createState() =>
      _PercentProgressIndicatorState();
}

class _PercentProgressIndicatorState extends State<PercentProgressIndicator> {
  double _width = 0;

/*  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _width = widget.percent * widget.width;
      });
    });
  }*/

  @override
  void initState() {
    super.initState();
    _width = widget.percent * widget.width;
  }

  @override
  void didUpdateWidget(covariant PercentProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.percent != widget.percent) {
      setState(() {
        _width = widget.percent * widget.width;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 300,
          height: 10,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              color: Colors.grey[300]),
        ),
        AnimatedContainer(
            duration: const Duration(milliseconds: 800),
            width: _width,
            height: widget.height,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                color: widget.progressColor)),
      ],
    );
  }
}