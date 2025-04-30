import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../res/app_textstyle.dart';

class SocialSignInBtn extends StatelessWidget {
  const SocialSignInBtn({
    super.key,
    required this.btnText, required this.socialIcon, required this.onTap
  });

  final String btnText;
  final String socialIcon;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            elevation: 0,
            side: BorderSide(color: Colors.grey[300]!),
            padding: EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
        ),
        onPressed: onTap, child: Row(
      spacing: 10,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(socialIcon, height: 30,),
        Text(btnText, style: AppTextStyles.regularTextStyle.copyWith( fontWeight: FontWeight.w500),)
      ],
    ));
  }
}