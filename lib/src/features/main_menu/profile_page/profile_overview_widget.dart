import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:read_nest/src/res/app_textstyle.dart';

class ProfileOverviewWidget extends StatelessWidget{
  const ProfileOverviewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildOverviewSection(),
      ],
    );
  }

  _buildOverviewSection() {
    return Column(
      spacing: 20,
      children: [
        Row(
          children: [
            Expanded(child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.black12,
                child: Center(child: Icon(Icons.menu_book_sharp),),
              ),
              title: Text("23", style: AppTextStyles.titleTextStyle,),
              subtitle: Text("Books read", style: AppTextStyles.smallTextStyle,),
            )),
            Expanded(child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.green.withValues(alpha: 0.1),
                child: Center(child: Icon(Icons.access_time_sharp, color: Colors.green,),),
              ),
              title: Text("4.2h", style: AppTextStyles.titleTextStyle,),
              subtitle: Text("This week", style: AppTextStyles.smallTextStyle,),
            )),
          ],
        ),
        Row(
          children: [
            Expanded(child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.purple.withValues(alpha: 0.1),
                child: Center(child: Icon(Icons.menu_book_sharp, color: Colors.purple,),),
              ),
              title: Text("46%", style: AppTextStyles.titleTextStyle,),
              subtitle: Text("Goal progress", style: AppTextStyles.smallTextStyle,),
            )),
            Expanded(child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.red.withValues(alpha: 0.1),
                child: Center(child: Icon(Icons.local_fire_department_outlined, color: Colors.red,),),
              ),
              title: Text("7", style: AppTextStyles.titleTextStyle,),
              subtitle: Text("Day Streak", style: AppTextStyles.smallTextStyle,),
            )),
          ],
        )
      ],
    );
  }
}