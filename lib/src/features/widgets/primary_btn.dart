import 'package:flutter/material.dart';
import '../../res/app_colors.dart';
import '../../res/app_textstyle.dart';

class PrimaryBtn extends StatelessWidget{
  final VoidCallback onTap;
  final String btnText;

  const PrimaryBtn({super.key, required this.onTap, required this.btnText});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor
        ),
        onPressed: onTap, child: Text(btnText
      ,style: AppTextStyles.titleTextStyle.copyWith(color: Colors.white),));
  }

}