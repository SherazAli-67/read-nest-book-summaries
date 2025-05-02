import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:read_nest/src/data/app_data.dart';
import 'package:read_nest/src/res/app_avatars.dart';
import 'package:read_nest/src/res/app_colors.dart';
import 'package:read_nest/src/res/app_constants.dart';
import 'package:read_nest/src/res/app_icons.dart';
import 'package:read_nest/src/res/app_textstyle.dart';

class HomePage extends StatefulWidget{
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedCategoryIndex = 0;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
      child: Column(
        spacing: 20,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 10,
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage(AppAvatars.avatar1),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Hi, Sheraz", style: AppTextStyles.titleTextStyle,),
                      Text("Good Morning", style: AppTextStyles.regularTextStyle,)
                    ],
                  )
                ],
              ),
              Row(
                children: [
                  SvgPicture.asset(AppIcons.icNotification)
                ],
              )
            ],
          ),
          SizedBox(
            height: size.height*0.37,
            child: Stack(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 40),
                  height: size.height*0.3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.primaryColor
                  ),
                  child: Text("Find interesting books from all over the world",textAlign: TextAlign.center, style: AppTextStyles.largeTextStyle.copyWith(color: Colors.white, fontWeight: FontWeight.w500),),
                ),
                Positioned(
                    top: size.height*0.15,
                    right: 15,
                    left: 15,
                    child: Container(
                      padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(color: Colors.black54, blurRadius: 10)
                    ],
                    color: Colors.white
                  ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("On a conviction to imprisonment for a period not exceeding for years...", style: AppTextStyles.regularTextStyle.copyWith(color: Colors.black54),),
                          TextButton(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero
                              ),
                              onPressed: (){}, child: Text("Continue Reading", style: AppTextStyles.titleTextStyle.copyWith(color: AppColors.primaryColor))),

                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: CachedNetworkImage(imageUrl: AppIcons.dummyBookImageUrl,),
                            ),
                            title: Text("Born a crime, Stories from south", style: AppTextStyles.titleTextStyle, overflow: TextOverflow.ellipsis,),
                            subtitle: RichText(text: TextSpan(
                              children: [
                                TextSpan(text: "Chapter ", style: AppTextStyles.regularTextStyle.copyWith(color: Colors.grey, fontFamily: appFontFamilyJakartaSans)),
                                TextSpan(text: "1 ", style: AppTextStyles.regularTextStyle.copyWith(color: Colors.black, fontFamily: appFontFamilyJakartaSans, fontWeight: FontWeight.w600)),
                                TextSpan(text: "of ", style: AppTextStyles.regularTextStyle.copyWith(color: Colors.grey, fontFamily: appFontFamilyJakartaSans)),
                                TextSpan(text: "4 ", style: AppTextStyles.regularTextStyle.copyWith(color: Colors.black, fontFamily: appFontFamilyJakartaSans,  fontWeight: FontWeight.w600)),

                              ]
                            ))
                          )
                        ],
                      ),

                ))
              ],
            ),
          ),
          SizedBox(
            height: 45,
            width: double.infinity,
            child: ListView.builder(
                itemCount: AppDate.genres.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (ctx, index){
                  bool isSelected = _selectedCategoryIndex == index;
                  return InkWell(
                    onTap: ()=> setState(() =>  _selectedCategoryIndex = index),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 15,),
                      margin: EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(99),
                        border: Border.all(color: isSelected ? Colors.transparent : Colors.grey),
                        color: isSelected ? AppColors.primaryColor.withOpacity(0.4) : Colors.white
                      ),
                      alignment: Alignment.center,
                      child: Text(AppDate.genres[index], textAlign: TextAlign.center, style: AppTextStyles.regularTextStyle.copyWith(color: isSelected ? AppColors.primaryColor : Colors.black, fontWeight: FontWeight.w600),),
                    ),
                  );
            }),
          )
        ],
      ),
    );
  }
}