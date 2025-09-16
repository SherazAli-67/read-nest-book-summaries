import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:read_nest/src/providers/user_provider.dart';
import 'package:read_nest/src/res/app_colors.dart';
import 'package:read_nest/src/res/app_icons.dart';
import 'package:read_nest/src/res/app_textstyle.dart';
import 'package:read_nest/src/services/progress_tracking_service.dart';
import 'package:read_nest/src/models/user_stats_model.dart';
import 'package:read_nest/src/models/achievement_model.dart';

import 'profile_tabbar_view_widget.dart';

class ProfilePage extends StatefulWidget{
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserStats? userStats;
  List<UserAchievement> userAchievements = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      // Fetch user stats and achievements
      final stats = await ProgressTrackingService.getReadingStats();
      final achievements = await ProgressTrackingService.getUserAchievements();

      setState(() {
        userStats = stats;
        userAchievements = achievements;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to load user data';
      });
      debugPrint('Error loading user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        spacing: 20,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Profile", style: AppTextStyles.headingTextStyle,),
          _buildUserInfoSection(),

          Expanded(child: ProfileTabBarViewWidget())
        ],
      ),
    );
  }

  Widget _buildUserInfoSection() {
    return Consumer<UserProvider>(builder: (_, provider, _){

          return provider.currentUser != null
              ? Container(
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
                            Text('${provider.currentUser!.fName} ${provider.currentUser!.lName}', style: AppTextStyles.titleTextStyle,),
                            Text(provider.currentUser!.email, style: AppTextStyles.smallTextStyle,),
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
          ) : SizedBox();
        });
  }
}
