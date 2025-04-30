import 'package:flutter/material.dart';
import 'package:read_nest/src/features/widgets/app_textfield_widget.dart';
import 'package:read_nest/src/features/widgets/primary_btn.dart';
import 'package:read_nest/src/res/app_textstyle.dart';

class CreateNewPassword extends StatefulWidget{
  const CreateNewPassword({super.key,});
  @override
  State<CreateNewPassword> createState() => _CreateNewPasswordState();
}

class _CreateNewPasswordState extends State<CreateNewPassword> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController = TextEditingController();

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
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
            Align(
              alignment: Alignment.topLeft,
              child: CircleAvatar(
                backgroundColor: Colors.grey[200],
                child: Center(child: IconButton(onPressed: (){}, icon: Icon(Icons.arrow_back)),),
              ),
            ),
            Column(
              children: [
                Text("Create a\nNew Password", textAlign: TextAlign.center, style: AppTextStyles.headingTextStyle.copyWith(fontWeight: FontWeight.w600),),
                Text("Enter your new password",textAlign: TextAlign.center, style: AppTextStyles.regularTextStyle,)
              ],
            ),
            AppTextField(textController: _newPasswordController, readOnly: true,  hintText: "*******", titleText: "New Password", isPassword: true,),
            AppTextField(textController: _confirmNewPasswordController, readOnly: true,  hintText: "*******", titleText: "Confirm Password", isPassword: true,),

            const SizedBox(height: 20,),
            SizedBox(
              height: 55,
              width: double.infinity,
              child: PrimaryBtn(onTap: (){}, btnText: "Continue"),
            ),
          ],
        ),
      )),
    );
  }
}