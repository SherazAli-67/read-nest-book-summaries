import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:read_nest/src/providers/user_preferences_provider.dart';
import 'package:read_nest/src/res/app_textstyle.dart';

class SelectGenderPage extends StatelessWidget{
  const SelectGenderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("What is your gender?", style: AppTextStyles.largeTextStyle,),
        Text("Select your gender for better content", style: AppTextStyles.regularTextStyle,),
        
        Consumer<UserPreferencesProvider>(builder: (ctx, provider, _){
          String selectedGender = provider.gender;
          return Column(
            spacing: 10,
            children: [
              RadioListTileWidget(groupValue: selectedGender, onChange: (val)=> provider.setGender(val!), title: "I am Male", value: "Male",),
              Divider(),
              RadioListTileWidget(groupValue: selectedGender, onChange: (val)=> provider.setGender(val!), title: "I am Female", value: "Female",),
              Divider(),
              RadioListTileWidget(groupValue: selectedGender, onChange: (val)=> provider.setGender(val!), title: "Rather not to say", value: "Not Described",),

            ],
          );
        })
      ],
    );
  }

}

class RadioListTileWidget extends StatelessWidget {
  const RadioListTileWidget({
    super.key,
    required this.groupValue,
    required this.onChange,
    required this.title,
    required this.value
  });

  final String groupValue;
  final Function(String? val) onChange;
  final String title;
  final String value;
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        listTileTheme: ListTileThemeData(
          horizontalTitleGap: 4,//here adjust based on your need
        ),
      ),
      child: RadioListTile(
        dense: true,
        contentPadding: EdgeInsets.zero,
        value: value, groupValue: groupValue, onChanged: onChange, title: Text(title, style: AppTextStyles.regularTextStyle.copyWith(fontWeight: FontWeight.w600),),

      ),
    );
  }
}