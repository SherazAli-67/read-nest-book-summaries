import 'package:read_nest/src/models/reading_mode.dart';

class ChapterProgress {
  final int chapterIndex;
  final bool isCompleted;
  final int timeSpentSeconds;
  final ReadingMode completedWith;
  final DateTime? completedDate;
  final DateTime? startedDate;

  ChapterProgress({
    required this.chapterIndex,
    required this.isCompleted,
    required this.timeSpentSeconds,
    required this.completedWith,
    this.completedDate,
    this.startedDate,
  });

  factory ChapterProgress.initial({
    required int chapterIndex,
    required ReadingMode mode,
  }) {
    return ChapterProgress(
      chapterIndex: chapterIndex,
      isCompleted: false,
      timeSpentSeconds: 0,
      completedWith: mode,
      startedDate: DateTime.now(),
    );
  }

  ChapterProgress copyWith({
    int? chapterIndex,
    bool? isCompleted,
    int? timeSpentSeconds,
    ReadingMode? completedWith,
    DateTime? completedDate,
    DateTime? startedDate,
  }) {
    return ChapterProgress(
      chapterIndex: chapterIndex ?? this.chapterIndex,
      isCompleted: isCompleted ?? this.isCompleted,
      timeSpentSeconds: timeSpentSeconds ?? this.timeSpentSeconds,
      completedWith: completedWith ?? this.completedWith,
      completedDate: completedDate ?? this.completedDate,
      startedDate: startedDate ?? this.startedDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'chapterIndex': chapterIndex,
      'isCompleted': isCompleted,
      'timeSpentSeconds': timeSpentSeconds,
      'completedWith': completedWith.toString(),
      'completedDate': completedDate?.toIso8601String(),
      'startedDate': startedDate?.toIso8601String(),
    };
  }

  factory ChapterProgress.fromMap(Map<String, dynamic> map) {
    return ChapterProgress(
      chapterIndex: map['chapterIndex'] ?? 0,
      isCompleted: map['isCompleted'] ?? false,
      timeSpentSeconds: map['timeSpentSeconds'] ?? 0,
      completedWith: ReadingMode.values.firstWhere(
        (mode) => mode.toString() == map['completedWith'],
        orElse: () => ReadingMode.READING,
      ),
      completedDate: map['completedDate'] != null 
        ? DateTime.parse(map['completedDate']) 
        : null,
      startedDate: map['startedDate'] != null 
        ? DateTime.parse(map['startedDate']) 
        : null,
    );
  }

  // Helper methods
  int get timeInMinutes => (timeSpentSeconds / 60).round();

  String get formattedTime {
    final hours = timeSpentSeconds ~/ 3600;
    final minutes = (timeSpentSeconds % 3600) ~/ 60;
    final seconds = timeSpentSeconds % 60;
    
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }
}
