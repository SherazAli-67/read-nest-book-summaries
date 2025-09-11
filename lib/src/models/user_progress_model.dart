import 'package:read_nest/src/models/chapter_progress_model.dart';
import 'package:read_nest/src/models/reading_mode.dart';

class UserProgress {
  final String userID;
  final String bookID;
  final int currentChapter;
  final double progressPercentage;
  final int totalTimeSpentSeconds;
  final DateTime lastReadDate;
  final DateTime? startedDate;
  final DateTime? completedDate;
  final bool isCompleted;
  final ReadingMode lastMode;
  final Map<int, ChapterProgress> chapterProgress;

  UserProgress({
    required this.userID,
    required this.bookID,
    required this.currentChapter,
    required this.progressPercentage,
    required this.totalTimeSpentSeconds,
    required this.lastReadDate,
    this.startedDate,
    this.completedDate,
    required this.isCompleted,
    required this.lastMode,
    required this.chapterProgress,
  });

  factory UserProgress.initial({
    required String userID,
    required String bookID,
  }) {
    return UserProgress(
      userID: userID,
      bookID: bookID,
      currentChapter: 0,
      progressPercentage: 0.0,
      totalTimeSpentSeconds: 0,
      lastReadDate: DateTime.now(),
      startedDate: DateTime.now(),
      isCompleted: false,
      lastMode: ReadingMode.READING,
      chapterProgress: {},
    );
  }

  UserProgress copyWith({
    String? userID,
    String? bookID,
    int? currentChapter,
    double? progressPercentage,
    int? totalTimeSpentSeconds,
    DateTime? lastReadDate,
    DateTime? startedDate,
    DateTime? completedDate,
    bool? isCompleted,
    ReadingMode? lastMode,
    Map<int, ChapterProgress>? chapterProgress,
  }) {
    return UserProgress(
      userID: userID ?? this.userID,
      bookID: bookID ?? this.bookID,
      currentChapter: currentChapter ?? this.currentChapter,
      progressPercentage: progressPercentage ?? this.progressPercentage,
      totalTimeSpentSeconds: totalTimeSpentSeconds ?? this.totalTimeSpentSeconds,
      lastReadDate: lastReadDate ?? this.lastReadDate,
      startedDate: startedDate ?? this.startedDate,
      completedDate: completedDate ?? this.completedDate,
      isCompleted: isCompleted ?? this.isCompleted,
      lastMode: lastMode ?? this.lastMode,
      chapterProgress: chapterProgress ?? this.chapterProgress,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'bookID': bookID,
      'currentChapter': currentChapter,
      'progressPercentage': progressPercentage,
      'totalTimeSpentSeconds': totalTimeSpentSeconds,
      'lastReadDate': lastReadDate.toIso8601String(),
      'startedDate': startedDate?.toIso8601String(),
      'completedDate': completedDate?.toIso8601String(),
      'isCompleted': isCompleted,
      'lastMode': lastMode.toString(),
      'chapterProgress': chapterProgress.map(
        (key, value) => MapEntry(key.toString(), value.toMap()),
      ),
    };
  }

  factory UserProgress.fromMap(Map<String, dynamic> map) {
    final chapterProgressMap = <int, ChapterProgress>{};
    final chapterProgressData = map['chapterProgress'] as Map<String, dynamic>? ?? {};
    
    chapterProgressData.forEach((key, value) {
      chapterProgressMap[int.parse(key)] = ChapterProgress.fromMap(value as Map<String, dynamic>);
    });

    return UserProgress(
      userID: map['userID'] ?? '',
      bookID: map['bookID'] ?? '',
      currentChapter: map['currentChapter'] ?? 0,
      progressPercentage: (map['progressPercentage'] ?? 0.0).toDouble(),
      totalTimeSpentSeconds: map['totalTimeSpentSeconds'] ?? 0,
      lastReadDate: map['lastReadDate'] != null 
        ? DateTime.parse(map['lastReadDate']) 
        : DateTime.now(),
      startedDate: map['startedDate'] != null 
        ? DateTime.parse(map['startedDate']) 
        : null,
      completedDate: map['completedDate'] != null 
        ? DateTime.parse(map['completedDate']) 
        : null,
      isCompleted: map['isCompleted'] ?? false,
      lastMode: ReadingMode.values.firstWhere(
        (mode) => mode.toString() == map['lastMode'],
        orElse: () => ReadingMode.READING,
      ),
      chapterProgress: chapterProgressMap,
    );
  }

  // Helper methods
  int get completedChaptersCount => 
    chapterProgress.values.where((chapter) => chapter.isCompleted).length;

  List<int> get completedChapterIndexes => 
    chapterProgress.entries
      .where((entry) => entry.value.isCompleted)
      .map((entry) => entry.key)
      .toList()..sort();

  int get readingTimeInMinutes => (totalTimeSpentSeconds / 60).round();

  String get formattedTotalTime {
    final hours = totalTimeSpentSeconds ~/ 3600;
    final minutes = (totalTimeSpentSeconds % 3600) ~/ 60;
    
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }
}
