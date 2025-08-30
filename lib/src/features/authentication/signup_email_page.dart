import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:read_nest/src/features/authentication/login_email_page.dart';
import 'package:read_nest/src/features/authentication/signup_page.dart';
import 'package:read_nest/src/features/widgets/app_textfield_widget.dart';
import 'package:read_nest/src/features/widgets/primary_btn.dart';
import 'package:read_nest/src/res/app_colors.dart';
import 'package:read_nest/src/res/app_constants.dart';
import 'package:read_nest/src/res/app_icons.dart';
import 'package:read_nest/src/res/app_textstyle.dart';

import '../widgets/social_signin_btn.dart';

class SignupEmailPage extends StatefulWidget{
  const SignupEmailPage({super.key});

  @override
  State<SignupEmailPage> createState() => _SignupEmailPageState();
}

class _SignupEmailPageState extends State<SignupEmailPage> {
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
            padding: const EdgeInsets.only(left: 15.0, right: 15, top: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 45.0),
                  child: Text("Create Account", textAlign: TextAlign.center, style: AppTextStyles.largeTextStyle.copyWith(color: Colors.white),),
                ),
                Text("Create account and get started with $appTitle", style: AppTextStyles.regularTextStyle.copyWith(color: Colors.white, fontSize: 15),),
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(left: 15.0, right: 15, top: 40),
                child: Column(
                  spacing:15,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTextField(textController: _emailController,  hintText: "Enter your email address", titleText: "Email", textInputType: TextInputType.emailAddress,),
                    // AppTextField(textController: _passwordController, prefixIcon: '', hintText: "******", titleText: "Password"),
                    const SizedBox(height: 10,),
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: PrimaryBtn(onTap: (){
                        String emailAddress = _emailController.text.trim();
                        if(emailAddress.isEmpty){
                          return;
                        }
                        Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=> SignupPage(emailAddress: emailAddress)));
                      }, btnText: "Signup with Email"),
                    ),
                    Row(
                      spacing: 10,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 100,
                          child: Divider(),
                        ),
                        Text("Or continue with", style: AppTextStyles.regularTextStyle.copyWith(color: Colors.grey),),
                        SizedBox(
                          width: 100,
                          child: Divider(),
                        ),
                      ],
                    ),
                    SocialSignInBtn(btnText: "Continue with Google", socialIcon: AppIcons.icGoogle, onTap: (){},),
                    SocialSignInBtn(btnText: "Continue with Apple", socialIcon: AppIcons.icApple, onTap: (){},),
                    // const Spacer(),
                    Align(
                      alignment: Alignment.center,
                      child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                              children: [
                                TextSpan(text: "Already have an account? ", style: AppTextStyles.regularTextStyle.copyWith(color: Colors.grey, fontFamily: appFontFamilyMontserrat, )),
                                TextSpan(
                                    recognizer: TapGestureRecognizer()..onTap = (){
                                      Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=> LoginEmailPage()));
                                    },
                                    text: "Sign in", style: AppTextStyles.regularTextStyle.copyWith(color: AppColors.primaryColor, fontFamily: appFontFamilyMontserrat, fontWeight: FontWeight.w600 )),
                              ]
                          )),
                    ),

                    // const Spacer(),
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