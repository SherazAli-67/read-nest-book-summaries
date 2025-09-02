import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:read_nest/src/res/app_colors.dart';
import 'package:read_nest/src/res/app_textstyle.dart';

class ProfileSettingsWidget extends StatelessWidget{
  const ProfileSettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 20,
        children: [
          Text('Preferences', style: AppTextStyles.regularTextStyle,),
          Column(
            children: [
              _buildSettingSwitchWidget(icon: Icons.dark_mode_outlined, title: 'Dark Mode', subTitle: 'Switch to dark theme', val: false),
              _buildSettingSwitchWidget(icon: Icons.notifications_none_rounded, title: 'Notifications', subTitle: 'Get reading reminders', val: true),
              _buildSettingSwitchWidget(icon: Icons.file_download_outlined, title: 'Auto Download', subTitle: 'Download summaries offline', val: false)

            ],
          ),
          Column(
            children: [
              _buildSettingsItemWidget(icon: Icons.notifications_none_rounded, title: 'Notifications'),
              _buildSettingsItemWidget(icon: Icons.security, title: 'Privacy'),
              _buildSettingsItemWidget(icon: Icons.file_download_outlined, title: 'Download Settings'),
              _buildSettingsItemWidget(icon: Icons.help, title: 'Help & Support'),
              _buildSettingsItemWidget(icon: Icons.settings, title: 'App Settings'),
            ],
          ),

          _buildInviteLogoutBtn(icon: Icons.people_outline_rounded, title: 'Invite Friends'),
          _buildInviteLogoutBtn(icon: Icons.logout, title: 'Sign out', isLogout: true)

        ],
      ),
    );
  }

  Widget _buildInviteLogoutBtn({required IconData icon, required String title, bool isLogout = false}) {
    return SizedBox(
          height: 35,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: isLogout ? Colors.red.withValues(alpha: 0.1) : AppColors.textFieldFillColor.withValues(alpha: 0.4)),
                  borderRadius: BorderRadius.circular(10)
                )
              ),
              onPressed: (){}, child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 5,
            children: [
              Icon(icon, color:  isLogout ? Colors.red :Colors.grey,),
              Text(title, style: AppTextStyles.smallTextStyle.copyWith(color:  isLogout ? Colors.red : Colors.black45),)
            ],
          )),
        );
  }

  Widget _buildSettingsItemWidget({required IconData icon, required String title,}) {
    return Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(icon),
              title: Text(title, style: AppTextStyles.smallTextStyle.copyWith(fontWeight: FontWeight.w600),),
              trailing: Icon(Icons.navigate_next_rounded),
            ),
            Container(
              width: double.infinity,
              height: 1,
              color: AppColors.textFieldFillColor.withValues(alpha: 0.4),
            )
          ],
        );
  }

  ListTile _buildSettingSwitchWidget({required IconData icon, required String title, required String subTitle, required bool val}) {
    return ListTile(
          leading: Icon(icon),
          title: Text(title, style: AppTextStyles.smallTextStyle.copyWith(fontWeight: FontWeight.w600),),
          subtitle: Text(subTitle, style: AppTextStyles.smallTextStyle.copyWith(fontSize: 12),),
          trailing: SizedBox(child: CupertinoSwitch(value: val, onChanged: (val){})),
        );
  }

}