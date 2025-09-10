import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:read_nest/firebase_options.dart';
import 'package:read_nest/src/features/authentication/login_email_page.dart';
import 'package:read_nest/src/features/main_menu/main_menu_page.dart';
import 'package:read_nest/src/providers/books_provider.dart';
import 'package:read_nest/src/providers/categories_provider.dart';
import 'package:read_nest/src/providers/main_menu_tab_change_provider.dart';
import 'package:read_nest/src/providers/user_preferences_provider.dart';
import 'package:read_nest/src/res/app_colors.dart';
import 'package:read_nest/src/res/app_constants.dart';

Future<void> main() async {
   WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserPreferencesProvider()),
        ChangeNotifierProvider(create: (_) => MainMenuTabChangeProvider()),
        ChangeNotifierProvider(create: (_) => BooksProvider()),
        ChangeNotifierProvider(create: (_) => CategoriesProvider()),
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
      debugShowCheckedModeBanner: false,
      title: appTitle,
      theme: ThemeData(
        fontFamily: appFontFamilyJakartaSans,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColor, ),
        scaffoldBackgroundColor: Colors.white
      ),
      home:  FirebaseAuth.instance.currentUser != null ? MainMenuPage() : LoginEmailPage()
    );
  }
}
