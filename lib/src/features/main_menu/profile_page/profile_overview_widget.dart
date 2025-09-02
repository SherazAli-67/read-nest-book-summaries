import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:read_nest/src/res/app_colors.dart';
import 'package:read_nest/src/res/app_textstyle.dart';

class ProfileOverviewWidget extends StatelessWidget{
  const ProfileOverviewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        spacing: 20,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildOverviewSection(),
          _buildReadingGoalSection(),
          _buildWeeklyReadingChartSection(),
          _buildReadingByCategorySection(),
          _buildAchievementSection()
        ],
      ),
    );
  }

  Widget _buildWeeklyReadingChartSection() {
    return Padding(
          padding: const EdgeInsets.all(20),
          child: WeeklyReadingChart(
            data: [2, 4, 1, 5, 3, 4, 2], // books read Mon–Sun
          ),
        );
  }

  Widget _buildOverviewSection() {
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
                border: Border.all(color: Colors.grey)
              ),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
              child: Text('This Year', style: TextStyle(fontSize: 10),),
            )
          ],
        ),
        BookProgressWidget(booksRead: 23, goal: 50)
      ],
    );
  }

  Widget _buildReadingByCategorySection() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          Text("Reading by Category", style: AppTextStyles.regularTextStyle,),
          _buildCategoryItemWidget(Colors.green, 'Business', '5'),
          _buildCategoryItemWidget(Colors.red, 'Motivation', '3'),
          _buildCategoryItemWidget(Colors.purple, 'Self-Improvement', '1'),
          _buildCategoryItemWidget(Colors.orange, 'Inspiration', '1'),

        ],
      ),
    );
  }

  Widget _buildCategoryItemWidget(Color color, String title, String number) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            spacing: 10,
            children: [
              CircleAvatar(
                backgroundColor: color,
                radius: 5,
              ),
              Text(title, style: AppTextStyles.smallTextStyle,)
            ],
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColors.textFieldFillColor,
              borderRadius: BorderRadius.circular(5)
            ),
            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 2),
            child: Text(number),
          )
        ],
      );
  }

  Widget _buildAchievementSection() {
    return Padding(padding: EdgeInsets.all(10), child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        Text("Achievement", style: AppTextStyles.regularTextStyle,),
        Row(
          spacing: 20,
          children: [
            Expanded(
              child: _buildAchievementItemWidget(icon: Icons.menu_book_rounded, title: 'First Steps', subtitle: 'Read your first book summary'),
            ),
            Expanded(
              child: _buildAchievementItemWidget(icon: Icons.trending_up, title: 'Speed Reader', subtitle: 'Read 10 books in a week'),
            )
          ],
        ),
        Row(
          spacing: 20,
          children: [
            Expanded(
              child: _buildAchievementItemWidget(icon: Icons.local_fire_department_outlined, title: 'Streak Master', subtitle: 'Maintain a 30-day reading streak'),
            ),
            Expanded(
              child: _buildAchievementItemWidget(icon: Icons.star_border_rounded, title: 'Knowledge Seeker', subtitle: 'Read books from 5 different categories'),
            )
          ],
        )
      ],
    ),);
  }

  Widget _buildAchievementItemWidget({required IconData icon, required String title, required String subtitle}) {
    return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey),
                color: AppColors.textFieldFillColor.withValues(alpha: 0.3)
              ),
              padding: EdgeInsets.all(15),
              child: Column(
                spacing: 10,
                children: [
                  Row(
                    spacing: 10,
                    children: [
                      Icon(icon),
                      Expanded(child: Text(title, style: AppTextStyles.smallTextStyle.copyWith(fontWeight: FontWeight.w600),))
                    ],
                  ),
                  Text(subtitle, style: AppTextStyles.smallTextStyle,)
                ],
              ),
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

class WeeklyReadingChart extends StatelessWidget {
  final List<int> data; // books read each day (Mon–Sun)

  const WeeklyReadingChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "This Week's Reading",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),

        SizedBox(
          height: 200,
          child: BarChart(
            BarChartData(
              backgroundColor: Colors.white,
              alignment: BarChartAlignment.spaceAround,
              borderData: FlBorderData(show: false),
              gridData: FlGridData(show: false),

              titlesData: FlTitlesData(
                leftTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index < 0 || index >= days.length) return Container();
                      return Text(
                        days[index],
                        style: const TextStyle(fontSize: 12),
                      );
                    },
                  ),
                ),
              ),
              barGroups: List.generate(data.length, (index) {
                return BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      toY: data[index].toDouble(),
                      color: Colors.black87,
                      width: 20,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ],
    );
  }
}