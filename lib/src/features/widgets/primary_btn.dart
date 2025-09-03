import 'package:flutter/material.dart';
import 'package:read_nest/src/features/widgets/loading_widget.dart';
import '../../res/app_colors.dart';
import '../../res/app_textstyle.dart';

class PrimaryBtn extends StatelessWidget{
  final VoidCallback onTap;
  final String btnText;
  final bool isLoading;
  const PrimaryBtn({super.key, required this.onTap, required this.btnText, this.isLoading = false});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor
        ),
        onPressed: onTap, child: isLoading ? LoadingWidget() : Text(btnText
      ,style: AppTextStyles.titleTextStyle.copyWith(color: Colors.white),));
  }

}