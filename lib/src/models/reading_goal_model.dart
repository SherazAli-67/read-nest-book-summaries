import 'package:flutter/material.dart';

class ReadingGoal {
  final String goalId;
  final String type;
  final String title;
  final String description;
  final String targetType; // "books" or "minutes"
  final int targetValue;
  final String timeframe; // "daily", "weekly", "monthly", "yearly"
  final List<String> suggestedCategories;
  final String difficulty; // "easy", "medium", "hard"
  final IconData icon;
  final Color color;
  final DateTime createdOn;
  final bool isActive;

  ReadingGoal({
    required this.goalId,
    required this.type,
    required this.title,
    required this.description,
    required this.targetType,
    required this.targetValue,
    required this.timeframe,
    required this.suggestedCategories,
    required this.difficulty,
    required this.icon,
    required this.color,
    required this.createdOn,
    this.isActive = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'goalId': goalId,
      'type': type,
      'title': title,
      'description': description,
      'targetType': targetType,
      'targetValue': targetValue,
      'timeframe': timeframe,
      'suggestedCategories': suggestedCategories,
      'difficulty': difficulty,
      'iconCodePoint': icon.codePoint,
      'colorValue': color.value,
      'createdOn': createdOn.toIso8601String(),
      'isActive': isActive,
    };
  }

  factory ReadingGoal.fromMap(Map<String, dynamic> map) {
    return ReadingGoal(
      goalId: map['goalId'] ?? '',
      type: map['type'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      targetType: map['targetType'] ?? 'books',
      targetValue: map['targetValue'] ?? 1,
      timeframe: map['timeframe'] ?? 'monthly',
      suggestedCategories: List<String>.from(map['suggestedCategories'] ?? []),
      difficulty: map['difficulty'] ?? 'medium',
      icon: IconData(map['iconCodePoint'] ?? Icons.book.codePoint, fontFamily: 'MaterialIcons'),
      color: Color(map['colorValue'] ?? Colors.blue.value),
      createdOn: map['createdOn'] != null ? DateTime.parse(map['createdOn']) : DateTime.now(),
      isActive: map['isActive'] ?? true,
    );
  }

  // Static method to create predefined goals
  static List<ReadingGoal> getPredefinedGoals() {
    final now = DateTime.now();
    return [
      ReadingGoal(
        goalId: 'weekend_reads',
        type: 'Weekend Reads',
        title: 'Weekend Reads',
        description: 'Complete 2-3 short books every weekend',
        targetType: 'books',
        targetValue: 8, // 2 books * 4 weekends
        timeframe: 'monthly',
        suggestedCategories: ['Quick Reads', 'Motivation', 'Self-Help'],
        difficulty: 'easy',
        icon: Icons.weekend,
        color: Colors.green,
        createdOn: now,
      ),
      ReadingGoal(
        goalId: 'deep_dives',
        type: 'Deep Dives',
        title: 'Deep Dives',
        description: 'Dive deep into comprehensive, longer books',
        targetType: 'books',
        targetValue: 4, // 1 book per week
        timeframe: 'monthly',
        suggestedCategories: ['Business', 'Philosophy', 'Biography'],
        difficulty: 'hard',
        icon: Icons.psychology,
        color: Colors.purple,
        createdOn: now,
      ),
      ReadingGoal(
        goalId: 'career_boost',
        type: 'Career Boost',
        title: 'Career Boost',
        description: 'Focus on professional development and business books',
        targetType: 'books',
        targetValue: 6,
        timeframe: 'monthly',
        suggestedCategories: ['Business', 'Leadership', 'Career', 'Money & Investments'],
        difficulty: 'medium',
        icon: Icons.trending_up,
        color: Colors.orange,
        createdOn: now,
      ),
      ReadingGoal(
        goalId: 'life_balance',
        type: 'Life Balance',
        title: 'Life Balance',
        description: 'Achieve better work-life balance through mindful reading',
        targetType: 'books',
        targetValue: 5,
        timeframe: 'monthly',
        suggestedCategories: ['Self-Help', 'Health', 'Mindfulness', 'Motivation'],
        difficulty: 'medium',
        icon: Icons.balance,
        color: Colors.teal,
        createdOn: now,
      ),
      ReadingGoal(
        goalId: 'quick_wins',
        type: 'Quick Wins',
        title: 'Quick Wins',
        description: 'Read bite-sized summaries during short breaks',
        targetType: 'minutes',
        targetValue: 300, // 5 hours per month
        timeframe: 'monthly',
        suggestedCategories: ['Quick Reads'],
        difficulty: 'easy',
        icon: Icons.flash_on,
        color: Colors.amber,
        createdOn: now,
      ),
      ReadingGoal(
        goalId: 'monthly_challenge',
        type: 'Monthly Challenge',
        title: 'Monthly Challenge',
        description: 'Set and achieve ambitious monthly reading targets',
        targetType: 'books',
        targetValue: 12,
        timeframe: 'monthly',
        suggestedCategories: ['Business', 'Self-Help', 'Motivation', 'Leadership'],
        difficulty: 'hard',
        icon: Icons.emoji_events,
        color: Colors.red,
        createdOn: now,
      ),
    ];
  }
}
