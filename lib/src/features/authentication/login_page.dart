import 'package:flutter/material.dart';
import 'package:read_nest/src/res/app_colors.dart';
import 'package:read_nest/src/res/app_textstyle.dart';

class LoginPage extends StatefulWidget{
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Column(
        spacing: 40,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 45.0),
                  child: Text("Hi, Welcome Back 👋", textAlign: TextAlign.center, style: AppTextStyles.largeTextStyle.copyWith(color: Colors.white),),
                ),
                Text("Please enter your username/email and password to sign in", style: AppTextStyles.regularTextStyle.copyWith(color: Colors.white, fontSize: 15),),
              ],
            ),
          ),
          Expanded(
            child: Card(
              color: Colors.white,
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  spacing: 5,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Email", style: AppTextStyles.regularTextStyle,),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                          hintText: "Enter your email address",
                          hintStyle: AppTextStyles.regularTextStyle,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(color: Colors.grey[200]!)
                        ),
                        fillColor: Colors.grey[200],
                        filled: true
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text("Password", style: AppTextStyles.regularTextStyle,),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                          hintText: "Enter your password",
                          hintStyle: AppTextStyles.regularTextStyle,
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(color: Colors.grey[200]!)
                          ),
                          fillColor: Colors.grey[200],
                          filled: true
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}