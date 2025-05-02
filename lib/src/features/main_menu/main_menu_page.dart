import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:read_nest/src/features/main_menu/explore_page.dart';
import 'package:read_nest/src/features/main_menu/home_page.dart';
import 'package:read_nest/src/features/main_menu/profile_page.dart';
import 'package:read_nest/src/features/main_menu/bookmark_page.dart';
import 'package:read_nest/src/providers/main_menu_tab_change_provider.dart';
import 'package:read_nest/src/res/app_colors.dart';
import 'package:read_nest/src/res/app_icons.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class MainMenuPage extends StatelessWidget{
  const MainMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MainMenuTabChangeProvider>(builder: (ctx, provider, _){
      return Scaffold(
        bottomNavigationBar: SalomonBottomBar(
          onTap: (index)=> provider.onTabChange(index),
            selectedItemColor: AppColors.primaryColor,
            currentIndex: provider.currentIndex,
            // selectedLabelStyle: AppTextStyles.regularTextStyle.copyWith(color: Colors.white),
            unselectedItemColor: Colors.grey,
            items: [
          _buildBottomNavigationItemWidget(icon: AppIcons.icHome, label: 'Home', isSelected: provider.currentIndex == 0),
          _buildBottomNavigationItemWidget(icon: AppIcons.icDiscover, label: 'Discover', isSelected: provider.currentIndex == 1),
          _buildBottomNavigationItemWidget(icon: AppIcons.icBookmark, label: 'Bookmark', isSelected: provider.currentIndex == 2),
          _buildBottomNavigationItemWidget(icon: AppIcons.icUserProfile, label: 'Profile', isSelected: provider.currentIndex == 3),
        ]),
        body: SafeArea(child: _buildPage(provider.currentIndex)),
      );
    },
    );
  }

  SalomonBottomBarItem _buildBottomNavigationItemWidget({required String icon, required String label, required bool isSelected}) =>
      SalomonBottomBarItem(
        icon: SvgPicture.asset(icon, colorFilter: ColorFilter.mode(
            isSelected ? AppColors.primaryColor : Colors.grey,
            BlendMode.srcIn)),
        title: Text(label),
        selectedColor: AppColors.primaryColor,
      );
    /*  BottomNavigationBarItem(
        icon: SvgPicture.asset(icon, colorFilter: ColorFilter.mode(
            isSelected ? AppColors.primaryColor : Colors.grey,
            BlendMode.srcIn)), label: label,);*/

  Widget _buildPage(int currentIndex) {
    switch(currentIndex){
      case 0:
        return HomePage();

      case 1:
        return ExplorePage();

      case 2:
        return BookMarkPage();

      case 3:
        return ProfilePage();

      default:
        return HomePage();
    }
  }

}