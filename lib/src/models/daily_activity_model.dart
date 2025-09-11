import 'package:intl/intl.dart';
import 'package:read_nest/src/models/reading_mode.dart';

class DailyActivity {
  final String userID;
  final DateTime date;
  final int totalTimeSpent;
  final int chaptersRead;
  final int chaptersListened;
  final List<String> booksAccessed;
  final Map<String, int> timePerBook;
  final Map<ReadingMode, int> timePerMode;

  DailyActivity({
    required this.userID,
    required this.date,
    required this.totalTimeSpent,
    required this.chaptersRead,
    required this.chaptersListened,
    required this.booksAccessed,
    required this.timePerBook,
    required this.timePerMode,
  });

  factory DailyActivity.empty(DateTime date, {String? userID}) {
    return DailyActivity(
      userID: userID ?? '',
      date: date,
      totalTimeSpent: 0,
      chaptersRead: 0,
      chaptersListened: 0,
      booksAccessed: [],
      timePerBook: {},
      timePerMode: {},
    );
  }

  factory DailyActivity.initial({
    required String userID,
    required DateTime date,
  }) {
    return DailyActivity(
      userID: userID,
      date: date,
      totalTimeSpent: 0,
      chaptersRead: 0,
      chaptersListened: 0,
      booksAccessed: [],
      timePerBook: {},
      timePerMode: {
        ReadingMode.READING: 0,
        ReadingMode.LISTENING: 0,
      },
    );
  }

  DailyActivity copyWith({
    String? userID,
    DateTime? date,
    int? totalTimeSpent,
    int? chaptersRead,
    int? chaptersListened,
    List<String>? booksAccessed,
    Map<String, int>? timePerBook,
    Map<ReadingMode, int>? timePerMode,
  }) {
    return DailyActivity(
      userID: userID ?? this.userID,
      date: date ?? this.date,
      totalTimeSpent: totalTimeSpent ?? this.totalTimeSpent,
      chaptersRead: chaptersRead ?? this.chaptersRead,
      chaptersListened: chaptersListened ?? this.chaptersListened,
      booksAccessed: booksAccessed ?? List.from(this.booksAccessed),
      timePerBook: timePerBook ?? Map.from(this.timePerBook),
      timePerMode: timePerMode ?? Map.from(this.timePerMode),
    );
  }

  DailyActivity addActivity({
    required String bookID,
    required ReadingMode mode,
    required int timeSpentSeconds,
    bool? chapterCompleted,
  }) {
    final newBooksAccessed = Set<String>.from(booksAccessed)..add(bookID);
    final newTimePerBook = Map<String, int>.from(timePerBook);
    newTimePerBook[bookID] = (newTimePerBook[bookID] ?? 0) + timeSpentSeconds;

    final newTimePerMode = Map<ReadingMode, int>.from(timePerMode);
    newTimePerMode[mode] = (newTimePerMode[mode] ?? 0) + timeSpentSeconds;

    int newChaptersRead = chaptersRead;
    int newChaptersListened = chaptersListened;

    if (chapterCompleted == true) {
      if (mode == ReadingMode.READING) {
        newChaptersRead++;
      } else {
        newChaptersListened++;
      }
    }

    return copyWith(
      totalTimeSpent: totalTimeSpent + timeSpentSeconds,
      chaptersRead: newChaptersRead,
      chaptersListened: newChaptersListened,
      booksAccessed: newBooksAccessed.toList(),
      timePerBook: newTimePerBook,
      timePerMode: newTimePerMode,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'date': DateFormat('yyyy-MM-dd').format(date),
      'totalTimeSpent': totalTimeSpent,
      'chaptersRead': chaptersRead,
      'chaptersListened': chaptersListened,
      'booksAccessed': booksAccessed,
      'timePerBook': timePerBook,
      'timePerMode': timePerMode.map(
        (key, value) => MapEntry(key.toString(), value),
      ),
    };
  }

  factory DailyActivity.fromMap(Map<String, dynamic> map) {
    final timePerModeData = map['timePerMode'] as Map<String, dynamic>? ?? {};
    final timePerModeMap = <ReadingMode, int>{};
    
    timePerModeData.forEach((key, value) {
      final mode = ReadingMode.values.firstWhere(
        (m) => m.toString() == key,
        orElse: () => ReadingMode.READING,
      );
      timePerModeMap[mode] = value as int;
    });

    return DailyActivity(
      userID: map['userID'] ?? '',
      date: map['date'] != null 
        ? DateFormat('yyyy-MM-dd').parse(map['date'])
        : DateTime.now(),
      totalTimeSpent: map['totalTimeSpent'] ?? 0,
      chaptersRead: map['chaptersRead'] ?? 0,
      chaptersListened: map['chaptersListened'] ?? 0,
      booksAccessed: List<String>.from(map['booksAccessed'] ?? []),
      timePerBook: Map<String, int>.from(map['timePerBook'] ?? {}),
      timePerMode: timePerModeMap,
    );
  }

  // Helper methods
  bool get hasActivity => totalTimeSpent > 0 || totalChapters > 0;
  int get totalChapters => chaptersRead + chaptersListened;
  int get uniqueBooksCount => booksAccessed.length;

  String get dateKey => DateFormat('yyyy-MM-dd').format(date);
  
  String get formattedTime {
    final hours = totalTimeSpent ~/ 3600;
    final minutes = (totalTimeSpent % 3600) ~/ 60;
    
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }

  ReadingMode? get preferredMode {
    final readingTime = timePerMode[ReadingMode.READING] ?? 0;
    final listeningTime = timePerMode[ReadingMode.LISTENING] ?? 0;
    
    if (readingTime == 0 && listeningTime == 0) return null;
    return readingTime >= listeningTime ? ReadingMode.READING : ReadingMode.LISTENING;
  }
}
