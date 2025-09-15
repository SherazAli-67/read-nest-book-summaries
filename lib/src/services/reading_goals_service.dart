import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../models/reading_goal_model.dart';
import '../models/user_goal_model.dart';

class ReadingGoalsService {
  static final _firestore = FirebaseFirestore.instance;
  static final _goalTemplatesCollection = _firestore.collection('reading_goal_templates');

  // Fetch all available goal templates
  static Future<List<ReadingGoal>> getGoalTemplates() async {
    try {
      debugPrint('Fetching goal templates...');
      
      final snapshot = await _goalTemplatesCollection
          .where('isActive', isEqualTo: true)
          .get();
      
      List<ReadingGoal> goals = snapshot.docs
          .map((doc) => ReadingGoal.fromMap(doc.data()))
          .toList();
      
      debugPrint('Found ${goals.length} goal templates');
      return goals;
    } catch (e) {
      debugPrint('Error fetching goal templates: $e');
      throw Exception('Failed to fetch goal templates: $e');
    }
  }

  // Get user's active goals
  static Future<List<UserGoal>> getUserActiveGoals(String userId) async {
    try {
      debugPrint('Fetching active goals for user: $userId');
      
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('active_goals')
          .where('status', isEqualTo: 'active')
          .get();
      
      List<UserGoal> goals = snapshot.docs
          .map((doc) => UserGoal.fromMap(doc.data()))
          .toList();
      
      debugPrint('Found ${goals.length} active goals for user');
      return goals;
    } catch (e) {
      debugPrint('Error fetching user active goals: $e');
      throw Exception('Failed to fetch user goals: $e');
    }
  }

  // Get user's goal history (completed/expired)
  static Future<List<UserGoal>> getUserGoalHistory(String userId) async {
    try {
      debugPrint('Fetching goal history for user: $userId');
      
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('active_goals')
          .where('status', whereIn: ['completed', 'expired', 'paused'])
          .orderBy('createdOn', descending: true)
          .get();
      
      List<UserGoal> goals = snapshot.docs
          .map((doc) => UserGoal.fromMap(doc.data()))
          .toList();
      
      debugPrint('Found ${goals.length} historical goals for user');
      return goals;
    } catch (e) {
      debugPrint('Error fetching user goal history: $e');
      throw Exception('Failed to fetch user goal history: $e');
    }
  }

  // Create a new user goal from a template
  static Future<UserGoal> createUserGoal({
    required String userId,
    required ReadingGoal template,
    int? customTargetValue,
    String? customTimeframe,
  }) async {
    try {
      debugPrint('Creating user goal from template: ${template.title}');
      
      final userGoalRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('active_goals')
          .doc();
      
      final now = DateTime.now();
      final targetValue = customTargetValue ?? template.targetValue;
      final timeframe = customTimeframe ?? template.timeframe;
      final endDate = UserGoal.calculateEndDate(now, timeframe);
      
      final userGoal = UserGoal(
        userGoalId: userGoalRef.id,
        userId: userId,
        baseGoalId: template.goalId,
        goalType: template.type,
        title: template.title,
        description: template.description,
        targetType: template.targetType,
        targetValue: targetValue,
        timeframe: timeframe,
        startDate: now,
        endDate: endDate,
        createdOn: now,
      );
      
      await userGoalRef.set(userGoal.toMap());
      debugPrint('Successfully created user goal: ${userGoal.title}');
      
      return userGoal;
    } catch (e) {
      debugPrint('Error creating user goal: $e');
      throw Exception('Failed to create user goal: $e');
    }
  }

  // Update user goal progress
  static Future<void> updateGoalProgress({
    required String userId,
    required String userGoalId,
    int? progressIncrement,
    int? minutesIncrement,
    String? bookId,
  }) async {
    try {
      debugPrint('Updating goal progress: $userGoalId');
      
      final goalRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('active_goals')
          .doc(userGoalId);
      
      final goalDoc = await goalRef.get();
      if (!goalDoc.exists) {
        throw Exception('Goal not found');
      }
      
      final currentGoal = UserGoal.fromMap(goalDoc.data()!);
      Map<String, dynamic> updates = {};
      
      // Update progress
      if (progressIncrement != null) {
        final newProgress = currentGoal.currentProgress + progressIncrement;
        updates['currentProgress'] = newProgress;
        
        // Check if goal is completed
        if (newProgress >= currentGoal.targetValue) {
          updates['status'] = 'completed';
          updates['completedOn'] = DateTime.now().toIso8601String();
        }
      }
      
      // Update minutes read
      if (minutesIncrement != null) {
        updates['minutesRead'] = currentGoal.minutesRead + minutesIncrement;
      }
      
      // Add completed book
      if (bookId != null && !currentGoal.booksCompleted.contains(bookId)) {
        final updatedBooks = List<String>.from(currentGoal.booksCompleted)..add(bookId);
        updates['booksCompleted'] = updatedBooks;
      }
      
      if (updates.isNotEmpty) {
        await goalRef.update(updates);
        debugPrint('Successfully updated goal progress');
      }
    } catch (e) {
      debugPrint('Error updating goal progress: $e');
      throw Exception('Failed to update goal progress: $e');
    }
  }

  // Pause/Resume a goal
  static Future<void> updateGoalStatus({
    required String userId,
    required String userGoalId,
    required String status,
  }) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('active_goals')
          .doc(userGoalId)
          .update({'status': status});
      
      debugPrint('Updated goal status to: $status');
    } catch (e) {
      debugPrint('Error updating goal status: $e');
      throw Exception('Failed to update goal status: $e');
    }
  }

  // Delete a user goal
  static Future<void> deleteUserGoal({
    required String userId,
    required String userGoalId,
  }) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('active_goals')
          .doc(userGoalId)
          .delete();
      
      debugPrint('Successfully deleted user goal: $userGoalId');
    } catch (e) {
      debugPrint('Error deleting user goal: $e');
      throw Exception('Failed to delete user goal: $e');
    }
  }

  // Get user's primary active goal (for profile display)
  static Future<UserGoal?> getUserPrimaryGoal(String userId) async {
    try {
      final goals = await getUserActiveGoals(userId);
      if (goals.isEmpty) return null;
      
      // Return the most recently created active goal
      goals.sort((a, b) => b.createdOn.compareTo(a.createdOn));
      return goals.first;
    } catch (e) {
      debugPrint('Error getting primary goal: $e');
      return null;
    }
  }

  // Auto-track reading progress
  static Future<void> trackReadingActivity({
    required String userId,
    required String bookId,
    required int minutesRead,
  }) async {
    try {
      debugPrint('Tracking reading activity for user: $userId, book: $bookId');
      
      final activeGoals = await getUserActiveGoals(userId);
      
      for (final goal in activeGoals) {
        Map<String, dynamic> updates = {};
        
        // Update based on target type
        if (goal.targetType == 'books') {
          // For book-based goals, only update if this book hasn't been completed for this goal yet
          if (!goal.booksCompleted.contains(bookId)) {
            // Add book to completed list and increment progress
            final updatedBooksCompleted = [...goal.booksCompleted, bookId];
            final newProgress = updatedBooksCompleted.length;
            
            updates = {
              'currentProgress': newProgress,
              'minutesRead': goal.minutesRead + minutesRead,
              'booksCompleted': updatedBooksCompleted,
            };
            
            // Check if goal is completed
            if (newProgress >= goal.targetValue) {
              updates['status'] = 'completed';
              updates['completedOn'] = DateTime.now().toIso8601String();
            }
            
            debugPrint('Book-based goal updated: ${goal.title}, progress: $newProgress/${goal.targetValue}');
          } else {
            // Book already completed for this goal, just update reading time
            updates = {
              'minutesRead': goal.minutesRead + minutesRead,
            };
            debugPrint('Book already completed for goal: ${goal.title}, only updating minutes');
          }
        } else if (goal.targetType == 'minutes') {
          // Time-based goal: increment minutes and update progress
          final newMinutes = goal.minutesRead + minutesRead;
          updates = {
            'minutesRead': newMinutes,
            'currentProgress': newMinutes, // For time-based goals, progress = minutes
          };
          
          // Check if goal is completed
          if (newMinutes >= goal.targetValue) {
            updates['status'] = 'completed';
            updates['completedOn'] = DateTime.now().toIso8601String();
          }
          
          debugPrint('Time-based goal updated: ${goal.title}, progress: $newMinutes/${goal.targetValue} minutes');
        }
        
        if (updates.isNotEmpty) {
          await _firestore
              .collection('users')
              .doc(userId)
              .collection('active_goals')
              .doc(goal.userGoalId)
              .update(updates);
          
          debugPrint('Successfully updated goal: ${goal.title}');
        }
      }
    } catch (e) {
      debugPrint('Error tracking reading activity: $e');
      throw Exception('Failed to track reading activity: $e');
    }
  }

  // Get goal statistics for user
  static Future<Map<String, int>> getUserGoalStats(String userId) async {
    try {
      final activeGoals = await getUserActiveGoals(userId);
      final historyGoals = await getUserGoalHistory(userId);
      
      int totalGoals = activeGoals.length + historyGoals.length;
      int completedGoals = historyGoals.where((g) => g.status == 'completed').length;
      int totalBooksRead = 0;
      int totalMinutesRead = 0;
      
      for (final goal in [...activeGoals, ...historyGoals]) {
        totalBooksRead += goal.booksCompleted.length;
        totalMinutesRead += goal.minutesRead;
      }
      
      return {
        'totalGoals': totalGoals,
        'activeGoals': activeGoals.length,
        'completedGoals': completedGoals,
        'totalBooksRead': totalBooksRead,
        'totalMinutesRead': totalMinutesRead,
      };
    } catch (e) {
      debugPrint('Error getting goal stats: $e');
      return {};
    }
  }
}
