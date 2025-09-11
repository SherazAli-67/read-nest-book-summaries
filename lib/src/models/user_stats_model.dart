class UserStats {
  final String userID;
  final int currentStreak;
  final int longestStreak;
  final DateTime? lastActivityDate;
  final int totalBooksCompleted;
  final int totalChaptersRead;
  final int totalChaptersListened;
  final int totalTimeSpentSeconds;
  final List<String> unlockedAchievements;
  final Map<String, dynamic> monthlyStats;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserStats({
    required this.userID,
    required this.currentStreak,
    required this.longestStreak,
    this.lastActivityDate,
    required this.totalBooksCompleted,
    required this.totalChaptersRead,
    required this.totalChaptersListened,
    required this.totalTimeSpentSeconds,
    required this.unlockedAchievements,
    required this.monthlyStats,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserStats.initial({required String userID}) {
    return UserStats(
      userID: userID,
      currentStreak: 0,
      longestStreak: 0,
      totalBooksCompleted: 0,
      totalChaptersRead: 0,
      totalChaptersListened: 0,
      totalTimeSpentSeconds: 0,
      unlockedAchievements: [],
      monthlyStats: {},
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  UserStats copyWith({
    String? userID,
    int? currentStreak,
    int? longestStreak,
    DateTime? lastActivityDate,
    int? totalBooksCompleted,
    int? totalChaptersRead,
    int? totalChaptersListened,
    int? totalTimeSpentSeconds,
    List<String>? unlockedAchievements,
    Map<String, dynamic>? monthlyStats,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserStats(
      userID: userID ?? this.userID,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      lastActivityDate: lastActivityDate ?? this.lastActivityDate,
      totalBooksCompleted: totalBooksCompleted ?? this.totalBooksCompleted,
      totalChaptersRead: totalChaptersRead ?? this.totalChaptersRead,
      totalChaptersListened: totalChaptersListened ?? this.totalChaptersListened,
      totalTimeSpentSeconds: totalTimeSpentSeconds ?? this.totalTimeSpentSeconds,
      unlockedAchievements: unlockedAchievements ?? this.unlockedAchievements,
      monthlyStats: monthlyStats ?? this.monthlyStats,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'lastActivityDate': lastActivityDate?.toIso8601String(),
      'totalBooksCompleted': totalBooksCompleted,
      'totalChaptersRead': totalChaptersRead,
      'totalChaptersListened': totalChaptersListened,
      'totalTimeSpentSeconds': totalTimeSpentSeconds,
      'unlockedAchievements': unlockedAchievements,
      'monthlyStats': monthlyStats,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory UserStats.fromMap(Map<String, dynamic> map) {
    return UserStats(
      userID: map['userID'] ?? '',
      currentStreak: map['currentStreak'] ?? 0,
      longestStreak: map['longestStreak'] ?? 0,
      lastActivityDate: map['lastActivityDate'] != null 
        ? DateTime.parse(map['lastActivityDate']) 
        : null,
      totalBooksCompleted: map['totalBooksCompleted'] ?? 0,
      totalChaptersRead: map['totalChaptersRead'] ?? 0,
      totalChaptersListened: map['totalChaptersListened'] ?? 0,
      totalTimeSpentSeconds: map['totalTimeSpentSeconds'] ?? 0,
      unlockedAchievements: List<String>.from(map['unlockedAchievements'] ?? []),
      monthlyStats: Map<String, dynamic>.from(map['monthlyStats'] ?? {}),
      createdAt: map['createdAt'] != null 
        ? DateTime.parse(map['createdAt']) 
        : DateTime.now(),
      updatedAt: map['updatedAt'] != null 
        ? DateTime.parse(map['updatedAt']) 
        : DateTime.now(),
    );
  }

  // Helper methods
  int get totalChaptersCompleted => totalChaptersRead + totalChaptersListened;
  
  double get averageTimePerBook => totalBooksCompleted > 0 
    ? totalTimeSpentSeconds / totalBooksCompleted 
    : 0.0;

  int get timeInMinutes => (totalTimeSpentSeconds / 60).round();
  
  int get timeInHours => (totalTimeSpentSeconds / 3600).round();

  String get formattedTotalTime {
    final hours = totalTimeSpentSeconds ~/ 3600;
    final minutes = (totalTimeSpentSeconds % 3600) ~/ 60;
    
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }

  // Streak status
  bool get hasActiveStreak => currentStreak > 0;
  bool get isStreakAtRisk {
    if (lastActivityDate == null) return false;
    final daysSinceActivity = DateTime.now().difference(lastActivityDate!).inDays;
    return daysSinceActivity >= 1;
  }
}
