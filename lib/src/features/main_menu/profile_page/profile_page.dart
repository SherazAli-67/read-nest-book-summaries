import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:read_nest/src/res/app_colors.dart';
import 'package:read_nest/src/res/app_icons.dart';
import 'package:read_nest/src/res/app_textstyle.dart';

import 'profile_tabbar_view_widget.dart';

class ProfilePage extends StatelessWidget{
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        spacing: 20,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Profile", style: AppTextStyles.headingTextStyle,),
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.textFieldFillColor,
              borderRadius: BorderRadius.circular(10)
            ),
            child: Column(
              spacing: 10,
              children: [
                Row(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(AppIcons.dummyBookImageUrl),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 10,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Sheraz Ali", style: AppTextStyles.titleTextStyle,),
                            Text("soomrosheraz054@gmail.com", style: AppTextStyles.smallTextStyle,),
                          ],
                        ),
                        Row(
                          spacing: 20,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(99),
                                color: Colors.white
                              ),
                              padding: EdgeInsets.all(5),
                              child:   Row(
                                spacing: 5,
                                children: [
                                  Icon(Icons.leaderboard, size: 15,),
                                  Text("Reading Pro", style: AppTextStyles.smallTextStyle.copyWith(fontSize: 10, fontWeight: FontWeight.w600),)
                                ],
                              )
                            ),
                            Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(99),
                                    color: Colors.white
                                ),
                                padding: EdgeInsets.all(5),
                                child:   Row(
                                  spacing: 5,
                                  children: [
                                    Icon(Icons.local_fire_department_outlined, size: 15, color: Colors.amber,),
                                    Text("7 days streak", style: AppTextStyles.smallTextStyle.copyWith(fontSize: 10, fontWeight: FontWeight.w600),)
                                  ],
                                )
                            )
                          ],
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)
                          )
                      ),
                      onPressed: (){}, child: Text('Edit Profile', textAlign: TextAlign.center,)),
                )
              ],
            ),
          ),
          Expanded(child: ProfileTabBarViewWidget())
        ],
      ),
    );
  }
}