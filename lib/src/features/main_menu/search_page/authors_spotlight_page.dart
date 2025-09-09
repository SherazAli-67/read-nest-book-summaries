import 'package:flutter/material.dart';
import 'package:read_nest/src/res/app_colors.dart';
import 'package:read_nest/src/res/app_textstyle.dart';

class AuthorsSpotLightPage extends StatelessWidget{
  const AuthorsSpotLightPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(onPressed: ()=> Navigator.pop(context), icon: Icon(Icons.arrow_back_rounded)),
        title: Text("Authors Spotlight",style: AppTextStyles.regularTextStyle,)
      ),
      body: SafeArea(child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
        child: Column(
          spacing: 20,
          children: [
            ListTile(
              tileColor: AppColors.textFieldFillColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
              ),
              title: Text("Featured Authors", style: AppTextStyles.smallTextStyle.copyWith(fontWeight: FontWeight.w600),),
              subtitle: Text('Discover brilliant minds', style: AppTextStyles.smallTextStyle,),
              trailing: Column(
                children: [
                  Text("4", style: AppTextStyles.regularTextStyle.copyWith(fontWeight: FontWeight.w600),),
                  Text("Authors", style: AppTextStyles.smallTextStyle,)
                ],
              ),
            )
          ],
        ),
      )),
    );
  }

}