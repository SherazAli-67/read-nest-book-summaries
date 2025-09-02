import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:read_nest/src/res/app_colors.dart';
import 'package:read_nest/src/res/app_textstyle.dart';

class ProfileActivityWidget extends StatelessWidget{
  const ProfileActivityWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 20,
        children: [
          Text('Recent Activity', style: AppTextStyles.regularTextStyle,),
          Column(
            spacing: 5,
            children: [
              _buildActivityItemWidget(icon: Icons.menu_book_rounded, title: 'Completed Atomic Habits', subTitle: '2 hours ago • Self-Help'),
              _buildActivityItemWidget(icon: Icons.menu_book_outlined, title: 'Added to favorites Think and Grow Rich', subTitle: '1 day ago • Business'),
              _buildActivityItemWidget(icon: Icons.menu_book_outlined, title: 'Started reading Deep Work', subTitle: '2 days ago • Business'),
              _buildActivityItemWidget(icon: Icons.menu_book_outlined, title: 'Completed Mindset', subTitle: '3 days ago • Motivation'),
            ],
          ),
          Text("All Achievements", style: AppTextStyles.regularTextStyle,),
          Column(
            spacing: 15,
            children: [
              _buildAchievementListTileItem(icon: Icons.menu_book_rounded, title: 'First Steps', subTitle: 'Read your first book summary'),
              _buildAchievementListTileItem(icon: Icons.trending_up, title: 'Speed Reader', subTitle: 'Read 10 books in a week'),
              ActivityProgressCard(icon: Icons.star_border_rounded,title: 'Knowledge Seeker', subtitle: 'Read books from 5 different categories', current: 3, total: 5),
              ActivityProgressCard(icon: Icons.celebration,title: 'Bookworm', subtitle: 'Read 100 book summaries', current: 23, total: 100),
              ActivityProgressCard(icon: Icons.widgets_rounded,title: 'Wisdom Collector', subtitle: 'Save 50 key insights', current: 35, total: 50),

            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementListTileItem({required IconData icon, required String title, required String subTitle}) {
    return Container(
              decoration: BoxDecoration(
                color: AppColors.textFieldFillColor.withValues(alpha: 0.3),
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10)
              ),
              child: _buildActivityItemWidget(icon: icon, title: title, subTitle: subTitle),
            );
  }

  Widget _buildActivityItemWidget({required IconData icon, required String title, required String subTitle}) {
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


class ActivityProgressCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final int current;
  final int total;
  final IconData icon;

  const ActivityProgressCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.current,
    required this.total,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final double progress = current / total;
    final int percentage = (progress * 100).round();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row with Icon + Texts
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left icon
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  shape: BoxShape.circle,
                ),
                child:  Icon(icon,
                    size: 20, color: Colors.grey),
              ),
              const SizedBox(width: 12),

              // Title + Subtitle
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Progress info (7/30 --- 23%)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("$current / $total",
                  style: const TextStyle(fontSize: 13)),
              Text("$percentage%",
                  style: const TextStyle(fontSize: 13)),
            ],
          ),

          const SizedBox(height: 6),

          // Animated Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: progress),
              duration: const Duration(seconds: 1),
              curve: Curves.easeInOut,
              builder: (context, value, _) => LinearProgressIndicator(
                value: value,
                minHeight: 8,
                backgroundColor: Colors.grey.shade300,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.black87),
              ),
            ),
          ),
        ],
      ),
    );
  }
}