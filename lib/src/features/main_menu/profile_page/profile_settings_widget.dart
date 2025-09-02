import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:read_nest/src/res/app_textstyle.dart';

class ProfileSettingsWidget extends StatelessWidget{
  const ProfileSettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
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
          )
        ],
      ),
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