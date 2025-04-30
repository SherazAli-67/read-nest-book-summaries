import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:read_nest/src/res/app_colors.dart';

class LoadingWidget extends StatelessWidget{
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Platform.isIOS ? CupertinoActivityIndicator(color: AppColors.primaryColor,) : CircularProgressIndicator(color: AppColors.primaryColor,),);
  }

}