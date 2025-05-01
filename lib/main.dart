import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:read_nest/src/features/main_menu/main_menu_page.dart';
import 'package:read_nest/src/providers/main_menu_tab_change_provider.dart';
import 'package:read_nest/src/providers/user_preferences_provider.dart';
import 'package:read_nest/src/res/app_colors.dart';
import 'package:read_nest/src/res/app_constants.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserPreferencesProvider()),
        ChangeNotifierProvider(create: (_) => MainMenuTabChangeProvider()),
      ],
      child: MyApp(),
    ),
  );
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
      home: MainMenuPage()
    );
  }
}
