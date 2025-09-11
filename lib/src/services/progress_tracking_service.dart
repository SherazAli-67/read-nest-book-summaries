import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:read_nest/src/models/achievement_model.dart';
import 'package:read_nest/src/models/chapter_progress_model.dart';
import 'package:read_nest/src/models/daily_activity_model.dart';
import 'package:read_nest/src/models/reading_mode.dart';
import 'package:read_nest/src/models/user_progress_model.dart';
import 'package:read_nest/src/models/user_stats_model.dart';
import 'package:read_nest/src/res/firebase_const.dart';
import 'package:read_nest/src/services/books_service.dart';

class ProgressTrackingService {
  static final _firestore = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;

  // Collection references
  static CollectionReference get _userProgressRef => 
    _firestore.collection(FirebaseConst.usersCollection)
      .doc(_auth.currentUser!.uid)
      .collection(FirebaseConst.userProgressCollection);
      
  static DocumentReference get _userStatsRef => 
    _firestore.collection(FirebaseConst.usersCollection)
      .doc(_auth.currentUser!.uid)
      .collection(FirebaseConst.userStatsCollection)
      .doc('stats');

  static CollectionReference get _dailyActivityRef =>
    _firestore.collection(FirebaseConst.usersCollection)
      .doc(_auth.currentUser!.uid)
      .collection(FirebaseConst.dailyActivityCollection);

  static CollectionReference get _achievementsRef =>
    _firestore.collection(FirebaseConst.usersCollection)
      .doc(_auth.currentUser!.uid)
      .collection(FirebaseConst.achievementsCollection);

  /// Update reading progress - called from reading/listening pages
  static Future<void> updateReadingProgress({
    required String bookID,
    required int currentChapter,
    required int timeSpentSeconds,
    required ReadingMode mode,
    double? customProgress,
    int? totalChapters,
  }) async {
    try {
      final userID = _auth.currentUser!.uid;
      final now = DateTime.now();
      
      // Get current progress or create new
      final progressDoc = await _userProgressRef.doc(bookID).get();
      UserProgress progress;
      
      if (progressDoc.exists) {
        progress = UserProgress.fromMap(progressDoc.data() as Map<String, dynamic>);
      } else {
        progress = UserProgress.initial(userID: userID, bookID: bookID);
      }
      
      // Calculate progress percentage
      double progressPercentage = customProgress ?? 0.0;
      if (customProgress == null && totalChapters != null) {
        progressPercentage = ((currentChapter + 1) / totalChapters).clamp(0.0, 1.0);
      }
      
      // Update progress
      progress = progress.copyWith(
        currentChapter: currentChapter,
        totalTimeSpentSeconds: progress.totalTimeSpentSeconds + timeSpentSeconds,
        lastReadDate: now,
        lastMode: mode,
        progressPercentage: progressPercentage,
      );
      
      // Update chapter-specific progress
      final updatedChapterProgress = Map<int, ChapterProgress>.from(progress.chapterProgress);
      final existingChapterProgress = updatedChapterProgress[currentChapter];
      
      if (existingChapterProgress != null) {
        updatedChapterProgress[currentChapter] = existingChapterProgress.copyWith(
          timeSpentSeconds: existingChapterProgress.timeSpentSeconds + timeSpentSeconds,
          completedWith: mode,
        );
      } else {
        updatedChapterProgress[currentChapter] = ChapterProgress.initial(
          chapterIndex: currentChapter,
          mode: mode,
        ).copyWith(timeSpentSeconds: timeSpentSeconds);
      }
      
      progress = progress.copyWith(chapterProgress: updatedChapterProgress);
      
      // Save to Firestore using batch
      final batch = _firestore.batch();
      batch.set(_userProgressRef.doc(bookID), progress.toMap());
      
      // Update daily activity
      await _updateDailyActivity(timeSpentSeconds, mode, bookID);
      
      await batch.commit();
      
      // Check for achievements asynchronously
      _checkAchievements();
      
    } catch (e) {
      debugPrint('Failed to update reading progress: $e');
      throw Exception('Failed to update reading progress: $e');
    }
  }

  /// Complete a chapter - marks chapter as completed
  static Future<void> completeChapter({
    required String bookID,
    required int chapterIndex,
    required ReadingMode mode,
    required int timeSpentSeconds,
    int? totalChapters,
  }) async {
    try {
      final progressDoc = await _userProgressRef.doc(bookID).get();
      if (!progressDoc.exists) return;
      
      final progress = UserProgress.fromMap(progressDoc.data() as Map<String, dynamic>);
      final updatedChapterProgress = Map<int, ChapterProgress>.from(progress.chapterProgress);
      
      // Mark chapter as completed
      final existingChapter = updatedChapterProgress[chapterIndex];
      updatedChapterProgress[chapterIndex] = (existingChapter ?? ChapterProgress.initial(
        chapterIndex: chapterIndex,
        mode: mode,
      )).copyWith(
        isCompleted: true,
        timeSpentSeconds: timeSpentSeconds,
        completedWith: mode,
        completedDate: DateTime.now(),
      );
      
      final updatedProgress = progress.copyWith(
        chapterProgress: updatedChapterProgress,
        lastReadDate: DateTime.now(),
      );
      
      await _userProgressRef.doc(bookID).set(updatedProgress.toMap());
      
      // Check if book is completed
      if (totalChapters != null) {
        final completedChapters = updatedChapterProgress.values.where((ch) => ch.isCompleted).length;
        
        if (completedChapters == totalChapters) {
          await completeBook(bookID: bookID, mode: mode);
        }
      }
      
      // Update stats and check achievements
      await _updateUserStats(chapterCompleted: true, mode: mode);
      await _updateDailyActivity(0, mode, bookID, chapterCompleted: true);
      
      _checkAchievements();
      
    } catch (e) {
      debugPrint('Failed to complete chapter: $e');
      throw Exception('Failed to complete chapter: $e');
    }
  }

  /// Complete a book - handles book completion logic
  static Future<void> completeBook({
    required String bookID,
    required ReadingMode mode,
  }) async {
    try {
      final progressDoc = await _userProgressRef.doc(bookID).get();
      if (!progressDoc.exists) return;
      
      final progress = UserProgress.fromMap(progressDoc.data() as Map<String, dynamic>);
      
      // Mark book as completed
      final completedProgress = progress.copyWith(
        isCompleted: true,
        completedDate: DateTime.now(),
        progressPercentage: 1.0,
      );
      
      await _userProgressRef.doc(bookID).set(completedProgress.toMap());
      
      // Update user stats
      await _updateUserStats(bookCompleted: true, mode: mode);
      
      _checkAchievements();
      
    } catch (e) {
      debugPrint('Failed to complete book: $e');
      throw Exception('Failed to complete book: $e');
    }
  }

  /// Calculate reading streaks - Updates reading streaks
  static Future<void> calculateStreaks() async {
    try {
      final userID = _auth.currentUser!.uid;
      final today = DateTime.now();
      final yesterday = today.subtract(const Duration(days: 1));
      
      // Get current stats
      final statsDoc = await _userStatsRef.get();
      UserStats stats = statsDoc.exists 
        ? UserStats.fromMap(statsDoc.data() as Map<String, dynamic>)
        : UserStats.initial(userID: userID);
      
      // Get today's and yesterday's activity
      final todayActivity = await _getDailyActivity(today);
      final yesterdayActivity = await _getDailyActivity(yesterday);
      
      // Streak calculation logic
      int newCurrentStreak = stats.currentStreak;
      int newLongestStreak = stats.longestStreak;
      DateTime? newLastActivityDate = stats.lastActivityDate;
      
      if (todayActivity.hasActivity) {
        newLastActivityDate = today;
        
        // If yesterday had activity OR this is the first day, continue/start streak
        if (yesterdayActivity.hasActivity || stats.currentStreak == 0) {
          newCurrentStreak = stats.currentStreak + 1;
        } else {
          // Gap detected, reset streak
          newCurrentStreak = 1;
        }
        
        // Update longest streak if current exceeds it
        if (newCurrentStreak > newLongestStreak) {
          newLongestStreak = newCurrentStreak;
        }
      } else {
        // No activity today
        if (stats.lastActivityDate != null) {
          final daysSinceLastActivity = today.difference(stats.lastActivityDate!).inDays;
          
          // Break streak if more than 1 day gap
          if (daysSinceLastActivity > 1) {
            newCurrentStreak = 0;
          }
        }
      }
      
      // Update stats
      final updatedStats = stats.copyWith(
        currentStreak: newCurrentStreak,
        longestStreak: newLongestStreak,
        lastActivityDate: newLastActivityDate,
      );
      
      await _userStatsRef.set(updatedStats.toMap());
      
    } catch (e) {
      debugPrint('Failed to calculate streaks: $e');
      throw Exception('Failed to calculate streaks: $e');
    }
  }

  /// Check achievements - Triggers achievement checks
  static Future<void> checkAchievements() async {
    try {
      // final userID = _auth.currentUser!.uid;
      
      // Get current stats
      final statsDoc = await _userStatsRef.get();
      if (!statsDoc.exists) return;
      
      final stats = UserStats.fromMap(statsDoc.data() as Map<String, dynamic>);
      final newAchievements = <String>[];
      
      // Define achievement conditions
      final achievements = _getAchievementDefinitions();
      
      for (final achievement in achievements) {
        // Skip if already unlocked
        if (stats.unlockedAchievements.contains(achievement.id)) continue;
        
        bool shouldUnlock = false;
        
        switch (achievement.type) {
          case AchievementType.STREAK:
            shouldUnlock = stats.currentStreak >= achievement.targetValue;
            break;
            
          case AchievementType.BOOKS_COMPLETED:
            shouldUnlock = stats.totalBooksCompleted >= achievement.targetValue;
            break;
            
          case AchievementType.CHAPTERS_READ:
            shouldUnlock = stats.totalChaptersRead >= achievement.targetValue;
            break;
            
          case AchievementType.TIME_SPENT:
            shouldUnlock = stats.totalTimeSpentSeconds >= achievement.targetValue;
            break;
            
          case AchievementType.LISTENING_CHAMPION:
            shouldUnlock = stats.totalChaptersListened >= achievement.targetValue;
            break;
            
          case AchievementType.CATEGORY_MASTER:
            shouldUnlock = await _checkCategoryMastery(achievement.categoryName!, achievement.targetValue);
            break;
            
          case AchievementType.SPEED_READER:
            shouldUnlock = await _checkReadingSpeed(achievement.targetValue);
            break;
            
          case AchievementType.NIGHT_OWL:
            shouldUnlock = await _checkNightReading();
            break;
            
          case AchievementType.EARLY_BIRD:
            shouldUnlock = await _checkEarlyReading();
            break;
            
          case AchievementType.CONSISTENCY:
            shouldUnlock = stats.longestStreak >= achievement.targetValue;
            break;
        }
        
        if (shouldUnlock) {
          newAchievements.add(achievement.id);
          
          // Save achievement unlock record
          await _achievementsRef.doc(achievement.id).set(UserAchievement(
            achievementId: achievement.id,
            unlockedAt: DateTime.now(),
            title: achievement.title,
            description: achievement.description,
            pointsEarned: achievement.pointsReward,
          ).toMap());
        }
      }
      
      // Update user stats with new achievements
      if (newAchievements.isNotEmpty) {
        final updatedAchievements = [...stats.unlockedAchievements, ...newAchievements];
        await _userStatsRef.update({
          'unlockedAchievements': updatedAchievements,
        });
        
        debugPrint('New achievements unlocked: $newAchievements');
      }
      
    } catch (e) {
      debugPrint('Failed to check achievements: $e');
      throw Exception('Failed to check achievements: $e');
    }
  }

  /// Get user's last read summary
  static Future<UserProgress?> getLastReadSummary() async {
    try {
      final snapshot = await _userProgressRef
        .orderBy('lastReadDate', descending: true)
        .limit(1)
        .get();
        
      if (snapshot.docs.isEmpty) return null;
      
      return UserProgress.fromMap(snapshot.docs.first.data() as Map<String, dynamic>);
    } catch (e) {
      debugPrint('Failed to get last read summary: $e');
      throw Exception('Failed to get last read summary: $e');
    }
  }

  /// Get comprehensive reading statistics
  static Future<UserStats> getReadingStats() async {
    try {
      final statsDoc = await _userStatsRef.get();
      if (!statsDoc.exists) {
        final initialStats = UserStats.initial(userID: _auth.currentUser!.uid);
        await _userStatsRef.set(initialStats.toMap());
        return initialStats;
      }
      
      return UserStats.fromMap(statsDoc.data() as Map<String, dynamic>);
    } catch (e) {
      debugPrint('Failed to get reading stats: $e');
      throw Exception('Failed to get reading stats: $e');
    }
  }

  /// Get user progress for a specific book
  static Future<UserProgress?> getBookProgress(String bookID) async {
    try {
      final doc = await _userProgressRef.doc(bookID).get();
      if (!doc.exists) return null;
      
      return UserProgress.fromMap(doc.data() as Map<String, dynamic>);
    } catch (e) {
      debugPrint('Failed to get book progress: $e');
      return null;
    }
  }

  /// Get completed books with completion dates
  static Future<List<UserProgress>> getCompletedBooksWithDates() async {
    try {
      final snapshot = await _userProgressRef
        .where('isCompleted', isEqualTo: true)
        .orderBy('completedDate', descending: true)
        .get();
        
      return snapshot.docs
        .map((doc) => UserProgress.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
    } catch (e) {
      debugPrint('Failed to get completed books: $e');
      return [];
    }
  }

  /// Get all user achievements
  static Future<List<UserAchievement>> getUserAchievements() async {
    try {
      final snapshot = await _achievementsRef
        .orderBy('unlockedAt', descending: true)
        .get();
        
      return snapshot.docs
        .map((doc) => UserAchievement.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
    } catch (e) {
      debugPrint('Failed to get user achievements: $e');
      return [];
    }
  }

  // Helper methods
  static Future<void> _updateUserStats({
    bool chapterCompleted = false,
    bool bookCompleted = false,
    required ReadingMode mode,
  }) async {
    try {
      final statsDoc = await _userStatsRef.get();
      UserStats stats = statsDoc.exists 
        ? UserStats.fromMap(statsDoc.data() as Map<String, dynamic>)
        : UserStats.initial(userID: _auth.currentUser!.uid);

      int newTotalBooksCompleted = stats.totalBooksCompleted;
      int newTotalChaptersRead = stats.totalChaptersRead;
      int newTotalChaptersListened = stats.totalChaptersListened;

      if (bookCompleted) {
        newTotalBooksCompleted++;
      }

      if (chapterCompleted) {
        if (mode == ReadingMode.READING) {
          newTotalChaptersRead++;
        } else {
          newTotalChaptersListened++;
        }
      }

      final updatedStats = stats.copyWith(
        totalBooksCompleted: newTotalBooksCompleted,
        totalChaptersRead: newTotalChaptersRead,
        totalChaptersListened: newTotalChaptersListened,
      );

      await _userStatsRef.set(updatedStats.toMap());
    } catch (e) {
      debugPrint('Failed to update user stats: $e');
    }
  }

  static Future<void> _updateDailyActivity(
    int timeSpentSeconds, 
    ReadingMode mode, 
    String bookID, {
    bool chapterCompleted = false,
  }) async {
    try {
      final today = DateTime.now();
      final dateKey = DateFormat('yyyy-MM-dd').format(today);
      
      final activityDoc = await _dailyActivityRef.doc(dateKey).get();
      DailyActivity activity;
      
      if (activityDoc.exists) {
        activity = DailyActivity.fromMap(activityDoc.data() as Map<String, dynamic>);
      } else {
        activity = DailyActivity.initial(
          userID: _auth.currentUser!.uid,
          date: today,
        );
      }
      
      final updatedActivity = activity.addActivity(
        bookID: bookID,
        mode: mode,
        timeSpentSeconds: timeSpentSeconds,
        chapterCompleted: chapterCompleted,
      );
      
      await _dailyActivityRef.doc(dateKey).set(updatedActivity.toMap());
    } catch (e) {
      debugPrint('Failed to update daily activity: $e');
    }
  }

  static Future<DailyActivity> _getDailyActivity(DateTime date) async {
    try {
      final dateStr = DateFormat('yyyy-MM-dd').format(date);
      final activityDoc = await _dailyActivityRef.doc(dateStr).get();
      
      return activityDoc.exists 
        ? DailyActivity.fromMap(activityDoc.data()! as Map<String, dynamic>)
        : DailyActivity.empty(date, userID: _auth.currentUser!.uid);
    } catch (e) {
      debugPrint('Failed to get daily activity: $e');
      return DailyActivity.empty(date, userID: _auth.currentUser!.uid);
    }
  }

  // Achievement checking helper methods
  static Future<bool> _checkCategoryMastery(String categoryName, int targetValue) async {
    try {
      final completedBooksSnapshot = await _userProgressRef
        .where('isCompleted', isEqualTo: true)
        .get();
      
      int categoryCount = 0;
      for (final doc in completedBooksSnapshot.docs) {
        final progress = UserProgress.fromMap(doc.data() as Map<String, dynamic>);
        try {
          final books = await BooksService.getAllBooks();
          final book = books.firstWhere((b) => b.bookID == progress.bookID);
          if (book.categories.contains(categoryName)) {
            categoryCount++;
          }
        } catch (e) {
          // Book not found, skip
          continue;
        }
      }
      
      return categoryCount >= targetValue;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> _checkReadingSpeed(int targetSeconds) async {
    try {
      final completedBooksSnapshot = await _userProgressRef
        .where('isCompleted', isEqualTo: true)
        .get();
      
      for (final doc in completedBooksSnapshot.docs) {
        final progress = UserProgress.fromMap(doc.data() as Map<String, dynamic>);
        if (progress.totalTimeSpentSeconds <= targetSeconds) {
          return true;
        }
      }
      
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> _checkNightReading() async {
    // Simplified check - in practice you'd track reading times more precisely
    return true;
  }

  static Future<bool> _checkEarlyReading() async {
    // Simplified check - in practice you'd track reading times more precisely
    return true;
  }

  // Achievement definitions
  static List<Achievement> _getAchievementDefinitions() {
    return [
      Achievement(
        id: 'first_book',
        title: 'Getting Started',
        description: 'Complete your first book summary',
        type: AchievementType.BOOKS_COMPLETED,
        targetValue: 1,
        iconUrl: 'assets/achievements/first_book.png',
        pointsReward: 50,
        difficulty: AchievementDifficulty.EASY,
      ),
      Achievement(
        id: 'book_collector',
        title: 'Book Collector',
        description: 'Complete 5 book summaries',
        type: AchievementType.BOOKS_COMPLETED,
        targetValue: 5,
        iconUrl: 'assets/achievements/book_collector.png',
        pointsReward: 100,
        difficulty: AchievementDifficulty.MEDIUM,
      ),
      Achievement(
        id: 'streak_7',
        title: '7-Day Streak',
        description: 'Read for 7 consecutive days',
        type: AchievementType.STREAK,
        targetValue: 7,
        iconUrl: 'assets/achievements/streak_7.png',
        pointsReward: 100,
        difficulty: AchievementDifficulty.MEDIUM,
      ),
      Achievement(
        id: 'listening_champion',
        title: 'Listening Champion',
        description: 'Complete 10 chapters by listening',
        type: AchievementType.LISTENING_CHAMPION,
        targetValue: 10,
        iconUrl: 'assets/achievements/listening_champion.png',
        pointsReward: 150,
        difficulty: AchievementDifficulty.MEDIUM,
      ),
    ];
  }

  /// Async achievement checking (fire and forget)
  static void _checkAchievements() {
    checkAchievements().catchError((e) {
      debugPrint('Background achievement check failed: $e');
    });
  }
}
