import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:read_nest/src/res/app_colors.dart';
import 'package:read_nest/src/res/app_textstyle.dart';

import '../../../data/app_data.dart';
import '../../../providers/user_preferences_provider.dart';

class ChooseBookGenrePage extends StatelessWidget{
  const ChooseBookGenrePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        Text("Choose the Book Genre You Like ❤️", style: AppTextStyles.headingTextStyle,),
        Text("Select your preferred book genre for better recommendations, or you can skip it", style: AppTextStyles.regularTextStyle,),
        Consumer<UserPreferencesProvider>(builder: (ctx, provider, _){
          return Expanded(
            child: Wrap(
              children: AppDate.genres.map((genre){

                bool isSelected = provider.favGenres.contains(genre);
            
                return GestureDetector(
                  onTap: ()=> provider.toggleGenre(genre),
                  child: Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(99),
                        border: Border.all(
                            color: AppColors.primaryColor
                        ),
                        color: isSelected ? AppColors.primaryColor : Colors.white
                    ),
                    child: Text(genre, textAlign: TextAlign.center, style: AppTextStyles.regularTextStyle.copyWith(color: isSelected ? Colors.white : AppColors.primaryColor, fontWeight: FontWeight.w600,),),
                  ),
                );
              }).toList(),
            ),
          );
        }),

      ],
    );
  }
  
}