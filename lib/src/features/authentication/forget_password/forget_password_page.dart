import 'package:flutter/material.dart';
import 'package:read_nest/src/features/authentication/forget_password/create_new_password.dart';
import 'package:read_nest/src/features/widgets/app_back_button.dart';
import 'package:read_nest/src/features/widgets/app_textfield_widget.dart';
import 'package:read_nest/src/features/widgets/primary_btn.dart';
import 'package:read_nest/src/res/app_textstyle.dart';

class ForgetPasswordPage extends StatefulWidget{
  const ForgetPasswordPage({super.key,});
  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final TextEditingController _emailController = TextEditingController();


  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 10),
        child: Column(
          spacing: 20,
          children: [
            AppBackButton(),

            Column(
              children: [
                Text("Forget Password", style: AppTextStyles.headingTextStyle.copyWith(fontWeight: FontWeight.w600),),
                Text("Recover your account password", style: AppTextStyles.regularTextStyle,)
              ],
            ),
            AppTextField(textController: _emailController, hintText: "Email Address", titleText: "Email", textInputType: TextInputType.emailAddress,),
            const SizedBox(height: 20,),
            SizedBox(
              height: 55,
              width: double.infinity,
              child: PrimaryBtn(onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=> CreateNewPassword()));
              }, btnText: "Continue"),
            ),
          ],
        ),
      )),
    );
  }
}