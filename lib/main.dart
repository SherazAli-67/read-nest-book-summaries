import 'package:flutter/material.dart';
import 'package:read_nest/src/features/welcome_page.dart';
import 'package:read_nest/src/res/app_colors.dart';
import 'package:read_nest/src/res/app_constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      theme: ThemeData(
        fontFamily: appFontFamilyJakartaSans,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColor, ),
        scaffoldBackgroundColor: Colors.white
      ),
      home: WelcomePage()
    );
  }
}
