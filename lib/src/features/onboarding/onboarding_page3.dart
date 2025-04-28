import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:read_nest/src/res/app_colors.dart';
import 'package:read_nest/src/res/app_constants.dart';
import 'package:read_nest/src/res/app_icons.dart';
import 'package:read_nest/src/res/app_textstyle.dart';

class OnboardingPageHolder extends StatefulWidget{
  const OnboardingPageHolder({super.key});

  @override
  State<OnboardingPageHolder> createState() => _OnboardingPageHolderState();
}

class _OnboardingPageHolderState extends State<OnboardingPageHolder> {
  int _currentIndex = 0;
  final List<String> _onboardingTitles = [onboardingTitle1, onboardingTitle2, onboardingTitle3];
  final List<String> _onboardingDescription = [onboardingDescription1, onboardingDescription2, onboardingDescription3];
  final List<String> _onboardingImages = [AppIcons.onboarding1, AppIcons.onboarding2, AppIcons.onboarding3];


  final PageController _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: PageView.builder(
        controller: _pageController,
          itemCount: _onboardingTitles.length,
          onPageChanged: (index)=> setState(()=>  _currentIndex = index),
          itemBuilder: (ctx, index){
            return OnboardingItemWidget(isSelected: _currentIndex == index,
              title: _onboardingTitles[index],
              description: _onboardingDescription[index],
              image: _onboardingImages[index],
              onTap: () {
                _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn);
              },);
      })
    );
  }
}

class OnboardingItemWidget extends StatelessWidget {
  const OnboardingItemWidget({
    super.key,
    required bool isSelected,
    required String title, required String description, required String image, required VoidCallback onTap,
  }) : _isSelected = isSelected, _title = title, _description = description, _image = image, _onTap = onTap;

  final bool _isSelected;
  final String _title;
  final String _description;
  final String _image;
  final VoidCallback _onTap;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(child: Image.asset(_image)),
        Card(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              spacing: 20,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index){

                    return Container(
                      height: 10,
                      margin: EdgeInsets.only(right: 10),
                      width: _isSelected ? 40 : 15,
                      decoration: BoxDecoration(
                          color: _isSelected ? AppColors.primaryColor : Colors.grey,
                          borderRadius: BorderRadius.circular(10)
                      ),
                    );
                  }),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: Text(_title, textAlign: TextAlign.center, style:TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                ),
                Text(_description, textAlign: TextAlign.center, style: AppTextStyles.regularTextStyle,),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: SizedBox(
                    width: 200,
                    height: 50,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor
                        ),
                        onPressed: _onTap, child: Text("Continue",style: AppTextStyles.titleTextStyle.copyWith(color: Colors.white),)),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}