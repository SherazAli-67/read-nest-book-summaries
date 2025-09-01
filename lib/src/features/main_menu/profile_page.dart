import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:read_nest/src/res/app_colors.dart';
import 'package:read_nest/src/res/app_icons.dart';
import 'package:read_nest/src/res/app_textstyle.dart';

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

class ProfileTabBarViewWidget extends StatefulWidget{
  const ProfileTabBarViewWidget({super.key});

  @override
  State<ProfileTabBarViewWidget> createState() => _ProfileTabBarViewWidgetState();
}

class _ProfileTabBarViewWidgetState extends State<ProfileTabBarViewWidget> with SingleTickerProviderStateMixin{
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(99),

            color: AppColors.textFieldFillColor,
          ),
          child: TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: 'Overview'),
        
              Tab(text: 'Activity'),
        
              Tab(text: 'Settings'),
            ],
            dividerHeight: 0,
            indicatorSize: TabBarIndicatorSize.label,
            labelColor: AppColors.primaryColor,
            labelStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w600,),
            unselectedLabelStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w500,),
            indicatorColor: AppColors.primaryColor,
          ),
        ),
        Expanded(child: TabBarView(
            controller: _tabController,
            children: [
             Center(child: Text("Overview page"),),
              Center(child: Text("Activity page"),),
              Center(child: Text("Settings page"),),
            ]))
      ],
    );
  }
}