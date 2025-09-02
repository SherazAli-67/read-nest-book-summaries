
import 'package:flutter/material.dart';
import 'package:read_nest/src/features/main_menu/profile_page/profile_activity_widget.dart';
import 'package:read_nest/src/features/main_menu/profile_page/profile_overview_widget.dart';

import '../../../res/app_colors.dart';

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
          height: 40,
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
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorPadding: EdgeInsets.all(5),
            indicator: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(99)
            ),
            labelColor: AppColors.primaryColor,
            labelStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w600,),
            unselectedLabelStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w500,),
            indicatorColor: Colors.white,
          ),
        ),
        Expanded(child: TabBarView(
            controller: _tabController,
            children: [
              ProfileOverviewWidget(),
              ProfileActivityWidget(),
              Center(child: Text("Settings page"),),
            ]))
      ],
    );
  }
}