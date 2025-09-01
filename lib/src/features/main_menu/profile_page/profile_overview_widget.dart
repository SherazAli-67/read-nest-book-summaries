import 'package:flutter/material.dart';
import 'package:read_nest/src/res/app_textstyle.dart';

class ProfileOverviewWidget extends StatelessWidget{
  const ProfileOverviewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 20,
      children: [
        _buildOverviewSection(),
        _buildReadingGoalSection()
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

  Widget _buildReadingGoalSection() {
    return Column(
      spacing: 20,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: Text("Reading Goal", style: AppTextStyles.regularTextStyle,)),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.black45)
              ),
              padding: EdgeInsets.all(2),
              child: Text('This Year', style: TextStyle(fontSize: 10),),
            )
          ],
        ),
        BookProgressWidget(booksRead: 23, goal: 50)
      ],
    );
  }
}

class BookProgressWidget extends StatelessWidget {
  final int booksRead;
  final int goal;

  const BookProgressWidget({
    super.key,
    required this.booksRead,
    required this.goal,
  });

  @override
  Widget build(BuildContext context) {
    final int remaining = goal - booksRead;
    final double progress = booksRead / goal;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top row with books read and goal
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "$booksRead books read",
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            Text(
              "$goal goal",
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ],
        ),

        const SizedBox(height: 8),

        // Animated Progress bar
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: progress),
            duration: const Duration(seconds: 1),
            curve: Curves.easeInOut,
            builder: (context, value, _) => LinearProgressIndicator(
              value: value,
              minHeight: 10,
              backgroundColor: Colors.grey.shade300,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.black87),
            ),
          ),
        ),

        const SizedBox(height: 8),

        // Remaining books text
        Text(
          "$remaining books remaining to reach your goal",
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}