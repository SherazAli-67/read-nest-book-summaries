import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:read_nest/src/features/authentication/login_email_page.dart';
import 'package:read_nest/src/features/onboarding/user_preferences/user_preferences_onboarding_page.dart';
import 'package:read_nest/src/features/widgets/app_textfield_widget.dart';
import 'package:read_nest/src/features/widgets/primary_btn.dart';
import 'package:read_nest/src/res/app_colors.dart';
import 'package:read_nest/src/res/app_constants.dart';
import 'package:read_nest/src/res/app_textstyle.dart';
import 'package:read_nest/src/upload/upload_books_page.dart';

class SignupPage extends StatefulWidget{
  const SignupPage({super.key, required this.emailAddress});
  final String emailAddress;
  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _creatingAccount = false;
  @override
  void initState() {
    super.initState();
    _emailController.text = widget.emailAddress;
  }
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
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
                Text("Sign up", style: AppTextStyles.regularTextStyle.copyWith(fontWeight: FontWeight.w600),),
                const SizedBox(width: 40,)
              ],
            ),
            Text("Complete your account", style: AppTextStyles.largeTextStyle,),

            AppTextField(textController: _firstNameController, hintText: "i.e Sheraz", titleText: "First Name"),
            AppTextField(textController: _lastNameController, hintText: "i.e Ali", titleText: "Last Name"),

            AppTextField(textController: _emailController, readOnly: true,  hintText: "Email Address", titleText: "Email", textInputType: TextInputType.emailAddress,),
            AppTextField(textController: _passwordController, isPassword: true, hintText: "***********", titleText: "Password"),
            AppTextField(textController: _confirmPasswordController, isPassword: true, hintText: "***********", titleText: "Confirm Password"),

            const SizedBox(height: 20,),
            SizedBox(
              height: 55,
              width: double.infinity,
              child: PrimaryBtn(onTap: (){
                // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (ctx)=> UserPreferencesOnboardingPage()), (value)=> false);
                _onSignupTap();
              }, btnText: "Sign up", isLoading: _creatingAccount,),
            ),
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
          ],
        ),
      )),
    );
  }

  void _onSignupTap()async{
    FirebaseAuth auth = FirebaseAuth.instance;
    setState(()=> _creatingAccount = true);
    // String fName = _firstNameController.text.trim();
    // String lName = _lastNameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    await auth.createUserWithEmailAndPassword(email: email, password: password);
    setState(()=> _creatingAccount = false);
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_)=> UploadBooksPage()), (_)=> false);
  }
}
