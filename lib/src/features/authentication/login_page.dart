import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:read_nest/src/features/authentication/forget_password/forget_password_page.dart';
import 'package:read_nest/src/features/authentication/signup_email_page.dart';
import 'package:read_nest/src/features/widgets/app_textfield_widget.dart';
import 'package:read_nest/src/features/widgets/primary_btn.dart';
import 'package:read_nest/src/res/app_textstyle.dart';

import '../../res/app_colors.dart';
import '../../res/app_constants.dart';
import '../../res/app_icons.dart';
import '../widgets/social_signin_btn.dart';

class LoginPage extends StatefulWidget{
  const LoginPage({super.key, required this.emailAddress});
  final String emailAddress;
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  bool _rememberMe = false;

  @override
  void initState() {
    _emailController.text = widget.emailAddress;
    super.initState();
  }
  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 10),
        child: Column(
          spacing: 20,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  child: Center(child: IconButton(onPressed: (){}, icon: Icon(Icons.arrow_back)),),
                ),
                Text("Sign In", style: AppTextStyles.regularTextStyle.copyWith(fontWeight: FontWeight.w600),),
                const SizedBox(width: 40,)
              ],
            ),
            AppTextField(textController: _emailController, readOnly: true,  hintText: "Email Address", titleText: "Email", textInputType: TextInputType.emailAddress,),
            AppTextField(textController: _passController, isPassword: true, hintText: "***********", titleText: "Password"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Checkbox(value: _rememberMe, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(99)), onChanged: (val)=> setState(()=> _rememberMe = val!)),
                    Text("Remember Me", style: AppTextStyles.regularTextStyle.copyWith(fontSize: 14, color: Colors.grey),)
                  ],
                ),
                TextButton(onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=> ForgetPasswordPage()));
                }, child: Text("Forget Password", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w600),))
              ],
            ),
            SizedBox(
              height: 55,
              width: double.infinity,
              child: PrimaryBtn(onTap: (){}, btnText: "Sign In"),
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
                        TextSpan(text: "Don't have an account? ", style: AppTextStyles.regularTextStyle.copyWith(color: Colors.grey, fontFamily: appFontFamilyMontserrat, )),
                        TextSpan(
                            recognizer: TapGestureRecognizer()..onTap = () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=> SignupEmailPage()));
                              // Single tapped.
                            },
                            text: "Sign up", style: AppTextStyles.regularTextStyle.copyWith(color: AppColors.primaryColor, fontFamily: appFontFamilyMontserrat, fontWeight: FontWeight.w600 )),
                      ]
                  )),
            ),
          ],
        ),
      )),
    );
  }
}