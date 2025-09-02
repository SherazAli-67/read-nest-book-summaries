import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:read_nest/src/res/app_colors.dart';
import 'package:read_nest/src/res/app_textstyle.dart';

class ProfileActivityWidget extends StatelessWidget{
  const ProfileActivityWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Recent Activity', style: AppTextStyles.regularTextStyle,),
          const SizedBox(height: 20,),
          Column(
            spacing: 5,
            children: [
              _buildActivityItemWidget(icon: Icons.menu_book_rounded, title: 'Completed Atomic Habits', subTitle: '2 hours ago • Self-Help'),
              _buildActivityItemWidget(icon: Icons.menu_book_outlined, title: 'Added to favorites Think and Grow Rich', subTitle: '1 day ago • Business'),
              _buildActivityItemWidget(icon: Icons.menu_book_outlined, title: 'Started reading Deep Work', subTitle: '2 days ago • Business'),
              _buildActivityItemWidget(icon: Icons.menu_book_outlined, title: 'Completed Mindset', subTitle: '3 days ago • Motivation'),

            ],
          )
        ],
      ),
    );
  }

  ListTile _buildActivityItemWidget({required IconData icon, required String title, required String subTitle}) {
    return ListTile(
          leading: CircleAvatar(
            backgroundColor: AppColors.textFieldFillColor,
            child: Icon(icon),
          ),
          title: Text(title, style: AppTextStyles.smallTextStyle.copyWith(fontWeight: FontWeight.w600),),
          subtitle: Text(subTitle, style: AppTextStyles.smallTextStyle.copyWith(fontSize: 12, color: Colors.grey),),
        );
  }

}