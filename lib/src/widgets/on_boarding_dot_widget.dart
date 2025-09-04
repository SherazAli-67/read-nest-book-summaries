import 'package:flutter/material.dart';
import 'package:read_nest/src/res/app_colors.dart';

class OnBoardingDotWidget extends  StatelessWidget{
  const OnBoardingDotWidget({super.key,
    required this.dotsLength,
    required this.isDarkTheme,
    required this.currentPage,
    this.color
  });

  final bool isDarkTheme;
  final int dotsLength;
  final int currentPage;
  final Color? color;
  @override
  Widget build(BuildContext context) {

    return  Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(dotsLength, (int index) {
        bool isSelected = currentPage == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration:  BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(99),
            ),
            color: color ?? (index < currentPage ? Colors.green : isSelected ? Colors.black : AppColors.textFieldFillColor)
            // color: color ?? (isDarkTheme ? Colors.white : const Color(0xFF000000)),
          ),
          margin: const EdgeInsets.only(right: 5),
          height: isSelected ? 5 :5,
          curve: Curves.easeIn,
          width: isSelected ? 20 : 5,
        );
      }),
    );
  }

}