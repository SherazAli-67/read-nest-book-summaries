class UserGoal {
  final String userGoalId;
  final String userId;
  final String baseGoalId; // Reference to ReadingGoal
  final String goalType;
  final String title;
  final String description;
  final String targetType;
  final int targetValue;
  final String timeframe;
  final DateTime startDate;
  final DateTime endDate;
  final int currentProgress;
  final int minutesRead;
  final List<String> booksCompleted;
  final String status; // "active", "completed", "paused", "expired"
  final DateTime createdOn;
  final DateTime? completedOn;

  UserGoal({
    required this.userGoalId,
    required this.userId,
    required this.baseGoalId,
    required this.goalType,
    required this.title,
    required this.description,
    required this.targetType,
    required this.targetValue,
    required this.timeframe,
    required this.startDate,
    required this.endDate,
    this.currentProgress = 0,
    this.minutesRead = 0,
    this.booksCompleted = const [],
    this.status = 'active',
    required this.createdOn,
    this.completedOn,
  });

  Map<String, dynamic> toMap() {
    return {
      'userGoalId': userGoalId,
      'userId': userId,
      'baseGoalId': baseGoalId,
      'goalType': goalType,
      'title': title,
      'description': description,
      'targetType': targetType,
      'targetValue': targetValue,
      'timeframe': timeframe,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'currentProgress': currentProgress,
      'minutesRead': minutesRead,
      'booksCompleted': booksCompleted,
      'status': status,
      'createdOn': createdOn.toIso8601String(),
      'completedOn': completedOn?.toIso8601String(),
    };
  }

  factory UserGoal.fromMap(Map<String, dynamic> map) {
    return UserGoal(
      userGoalId: map['userGoalId'] ?? '',
      userId: map['userId'] ?? '',
      baseGoalId: map['baseGoalId'] ?? '',
      goalType: map['goalType'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      targetType: map['targetType'] ?? 'books',
      targetValue: map['targetValue'] ?? 1,
      timeframe: map['timeframe'] ?? 'monthly',
      startDate: DateTime.parse(map['startDate']),
      endDate: DateTime.parse(map['endDate']),
      currentProgress: map['currentProgress'] ?? 0,
      minutesRead: map['minutesRead'] ?? 0,
      booksCompleted: List<String>.from(map['booksCompleted'] ?? []),
      status: map['status'] ?? 'active',
      createdOn: map['createdOn'] != null ? DateTime.parse(map['createdOn']) : DateTime.now(),
      completedOn: map['completedOn'] != null ? DateTime.parse(map['completedOn']) : null,
    );
  }

  // Helper methods
  double get progressPercentage {
    if (targetValue == 0) return 0.0;
    return (currentProgress / targetValue).clamp(0.0, 1.0);
  }

  bool get isCompleted => status == 'completed' || currentProgress >= targetValue;

  bool get isExpired => DateTime.now().isAfter(endDate) && !isCompleted;

  bool get isActive => status == 'active' && !isExpired;

  int get remainingTarget => (targetValue - currentProgress).clamp(0, targetValue);

  int get daysRemaining {
    final now = DateTime.now();
    if (now.isAfter(endDate)) return 0;
    return endDate.difference(now).inDays;
  }

  // Create a copy with updated values
  UserGoal copyWith({
    String? userGoalId,
    String? userId,
    String? baseGoalId,
    String? goalType,
    String? title,
    String? description,
    String? targetType,
    int? targetValue,
    String? timeframe,
    DateTime? startDate,
    DateTime? endDate,
    int? currentProgress,
    int? minutesRead,
    List<String>? booksCompleted,
    String? status,
    DateTime? createdOn,
    DateTime? completedOn,
  }) {
    return UserGoal(
      userGoalId: userGoalId ?? this.userGoalId,
      userId: userId ?? this.userId,
      baseGoalId: baseGoalId ?? this.baseGoalId,
      goalType: goalType ?? this.goalType,
      title: title ?? this.title,
      description: description ?? this.description,
      targetType: targetType ?? this.targetType,
      targetValue: targetValue ?? this.targetValue,
      timeframe: timeframe ?? this.timeframe,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      currentProgress: currentProgress ?? this.currentProgress,
      minutesRead: minutesRead ?? this.minutesRead,
      booksCompleted: booksCompleted ?? this.booksCompleted,
      status: status ?? this.status,
      createdOn: createdOn ?? this.createdOn,
      completedOn: completedOn ?? this.completedOn,
    );
  }

  // Calculate end date based on timeframe and start date
  static DateTime calculateEndDate(DateTime startDate, String timeframe) {
    switch (timeframe.toLowerCase()) {
      case 'daily':
        return startDate.add(const Duration(days: 1));
      case 'weekly':
        return startDate.add(const Duration(days: 7));
      case 'monthly':
        return DateTime(startDate.year, startDate.month + 1, startDate.day);
      case 'yearly':
        return DateTime(startDate.year + 1, startDate.month, startDate.day);
      default:
        return startDate.add(const Duration(days: 30)); // Default to 30 days
    }
  }
}
