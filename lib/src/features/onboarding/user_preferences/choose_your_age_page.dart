import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:read_nest/src/data/app_data.dart';
import 'package:read_nest/src/providers/user_preferences_provider.dart';
import 'package:read_nest/src/res/app_colors.dart';
import 'package:read_nest/src/res/app_textstyle.dart';

class ChooseYourAgePage extends StatelessWidget{
  const ChooseYourAgePage({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        Text("Choose your age?", style: AppTextStyles.headingTextStyle,),
        Text("Select age range for better content", style: AppTextStyles.regularTextStyle,),
        Consumer<UserPreferencesProvider>(builder: (ctx, provider, _){
          return Wrap(
            children: AppDate.ageRanges.map((ageRange){

              bool isSelected = provider.age == ageRange;
              
              return GestureDetector(
                onTap: ()=> provider.setAge(ageRange),
                child: Container(
                  width: size.width*0.4,
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(99),
                    border: Border.all(
                        color: AppColors.primaryColor
                    ),
                    color: isSelected ? AppColors.primaryColor : Colors.white
                  ),
                  child: Text(ageRange, textAlign: TextAlign.center, style: AppTextStyles.regularTextStyle.copyWith(color: isSelected ? Colors.white : AppColors.primaryColor, fontWeight: FontWeight.w600, fontSize: 18),),
                ),
              );
            }).toList(),
          );
        }),
        
      ],
    );
  }
  
}