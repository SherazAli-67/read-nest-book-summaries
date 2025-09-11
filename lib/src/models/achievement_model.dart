class Achievement {
  final String id;
  final String title;
  final String description;
  final AchievementType type;
  final int targetValue;
  final String? categoryName;
  final String iconUrl;
  final int pointsReward;
  final AchievementDifficulty difficulty;
  final DateTime? unlockedAt;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.targetValue,
    this.categoryName,
    required this.iconUrl,
    this.pointsReward = 10,
    this.difficulty = AchievementDifficulty.EASY,
    this.unlockedAt,
  });

  Achievement copyWith({
    String? id,
    String? title,
    String? description,
    AchievementType? type,
    int? targetValue,
    String? categoryName,
    String? iconUrl,
    int? pointsReward,
    AchievementDifficulty? difficulty,
    DateTime? unlockedAt,
  }) {
    return Achievement(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      targetValue: targetValue ?? this.targetValue,
      categoryName: categoryName ?? this.categoryName,
      iconUrl: iconUrl ?? this.iconUrl,
      pointsReward: pointsReward ?? this.pointsReward,
      difficulty: difficulty ?? this.difficulty,
      unlockedAt: unlockedAt ?? this.unlockedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type.toString(),
      'targetValue': targetValue,
      'categoryName': categoryName,
      'iconUrl': iconUrl,
      'pointsReward': pointsReward,
      'difficulty': difficulty.toString(),
      'unlockedAt': unlockedAt?.toIso8601String(),
    };
  }

  factory Achievement.fromMap(Map<String, dynamic> map) {
    return Achievement(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      type: AchievementType.values.firstWhere(
        (type) => type.toString() == map['type'],
        orElse: () => AchievementType.BOOKS_COMPLETED,
      ),
      targetValue: map['targetValue'] ?? 0,
      categoryName: map['categoryName'],
      iconUrl: map['iconUrl'] ?? '',
      pointsReward: map['pointsReward'] ?? 10,
      difficulty: AchievementDifficulty.values.firstWhere(
        (diff) => diff.toString() == map['difficulty'],
        orElse: () => AchievementDifficulty.EASY,
      ),
      unlockedAt: map['unlockedAt'] != null 
        ? DateTime.parse(map['unlockedAt']) 
        : null,
    );
  }

  // Helper methods
  bool get isUnlocked => unlockedAt != null;
  
  String get difficultyText {
    switch (difficulty) {
      case AchievementDifficulty.EASY:
        return 'Easy';
      case AchievementDifficulty.MEDIUM:
        return 'Medium';
      case AchievementDifficulty.HARD:
        return 'Hard';
      case AchievementDifficulty.LEGENDARY:
        return 'Legendary';
    }
  }

  String get typeDisplayName {
    switch (type) {
      case AchievementType.STREAK:
        return 'Reading Streak';
      case AchievementType.BOOKS_COMPLETED:
        return 'Books Completed';
      case AchievementType.CHAPTERS_READ:
        return 'Chapters Read';
      case AchievementType.TIME_SPENT:
        return 'Time Spent';
      case AchievementType.LISTENING_CHAMPION:
        return 'Listening Champion';
      case AchievementType.CATEGORY_MASTER:
        return 'Category Master';
      case AchievementType.SPEED_READER:
        return 'Speed Reader';
      case AchievementType.NIGHT_OWL:
        return 'Night Owl';
      case AchievementType.EARLY_BIRD:
        return 'Early Bird';
      case AchievementType.CONSISTENCY:
        return 'Consistency';
    }
  }
}

enum AchievementType {
  STREAK,
  BOOKS_COMPLETED,
  CHAPTERS_READ,
  TIME_SPENT,
  LISTENING_CHAMPION,
  CATEGORY_MASTER,
  SPEED_READER,
  NIGHT_OWL,
  EARLY_BIRD,
  CONSISTENCY,
}

enum AchievementDifficulty {
  EASY,
  MEDIUM,
  HARD,
  LEGENDARY,
}

class UserAchievement {
  final String achievementId;
  final DateTime unlockedAt;
  final String title;
  final String description;
  final int pointsEarned;

  UserAchievement({
    required this.achievementId,
    required this.unlockedAt,
    required this.title,
    required this.description,
    required this.pointsEarned,
  });

  Map<String, dynamic> toMap() {
    return {
      'achievementId': achievementId,
      'unlockedAt': unlockedAt.toIso8601String(),
      'title': title,
      'description': description,
      'pointsEarned': pointsEarned,
    };
  }

  factory UserAchievement.fromMap(Map<String, dynamic> map) {
    return UserAchievement(
      achievementId: map['achievementId'] ?? '',
      unlockedAt: map['unlockedAt'] != null 
        ? DateTime.parse(map['unlockedAt']) 
        : DateTime.now(),
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      pointsEarned: map['pointsEarned'] ?? 0,
    );
  }

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(unlockedAt);
    
    if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }
}
