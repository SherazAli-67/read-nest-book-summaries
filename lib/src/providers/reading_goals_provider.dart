import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../models/reading_goal_model.dart';
import '../models/user_goal_model.dart';
import '../services/reading_goals_service.dart';

class ReadingGoalsProvider extends ChangeNotifier {
  List<ReadingGoal> _goalTemplates = [];
  List<UserGoal> _activeGoals = [];
  UserGoal? _primaryGoal;
  Map<String, int> _goalStats = {};

  bool _isLoading = false;
  bool _isLoadingUserGoals = false;
  String? _error;

  // Getters
  List<ReadingGoal> get goalTemplates => _goalTemplates;
  List<UserGoal> get activeGoals => _activeGoals;
  UserGoal? get primaryGoal => _primaryGoal;
  Map<String, int> get goalStats => _goalStats;

  bool get isLoading => _isLoading;
  bool get isLoadingUserGoals => _isLoadingUserGoals;
  String? get error => _error;

  // Get current user ID
  String? get _currentUserId => FirebaseAuth.instance.currentUser?.uid;

  // Fetch all goal templates from Firebase
  Future<void> fetchGoalTemplates({bool forceRefresh = false}) async {
    _error = null;
    _isLoading = true;
    notifyListeners();

    try {
      debugPrint("Fetching goal templates...");
      _goalTemplates = await ReadingGoalsService.getGoalTemplates();
      debugPrint("Successfully fetched ${_goalTemplates.length} goal templates");
    } catch (e) {
      debugPrint("Error fetching goal templates: $e");
      _error = e.toString();
      
      // If no templates from server, use predefined ones as fallback
      if (_goalTemplates.isEmpty) {
        _goalTemplates = ReadingGoal.getPredefinedGoals();
        debugPrint("Using predefined goals as fallback");
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fetch user's active goals
  Future<void> fetchUserGoals({bool forceRefresh = false}) async {
    if (_currentUserId == null) return;

    _error = null;
    _isLoadingUserGoals = true;
    notifyListeners();

    try {
      debugPrint("Fetching user goals...");
      _activeGoals = await ReadingGoalsService.getUserActiveGoals(_currentUserId!);
      
      // Get primary goal (most recent active goal)
      if (_activeGoals.isNotEmpty) {
        _activeGoals.sort((a, b) => b.createdOn.compareTo(a.createdOn));
        _primaryGoal = _activeGoals.first;
      } else {
        _primaryGoal = null;
      }

      // Fetch goal stats
      _goalStats = await ReadingGoalsService.getUserGoalStats(_currentUserId!);

      debugPrint("Successfully fetched ${_activeGoals.length} user goals");
    } catch (e) {
      debugPrint("Error fetching user goals: $e");
      _error = e.toString();
    } finally {
      _isLoadingUserGoals = false;
      notifyListeners();
    }
  }

  // Create a new user goal from template
  Future<bool> createUserGoal({
    required ReadingGoal template,
    int? customTargetValue,
    String? customTimeframe,
  }) async {
    if (_currentUserId == null) {
      _error = "User not authenticated";
      notifyListeners();
      return false;
    }

    try {
      debugPrint("Creating user goal: ${template.title}");
      
      final userGoal = await ReadingGoalsService.createUserGoal(
        userId: _currentUserId!,
        template: template,
        customTargetValue: customTargetValue,
        customTimeframe: customTimeframe,
      );

      // Update local state
      _activeGoals.insert(0, userGoal);
      _primaryGoal = userGoal;

      debugPrint("Successfully created user goal: ${userGoal.title}");
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint("Error creating user goal: $e");
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Update goal progress
  Future<void> updateGoalProgress({
    required String userGoalId,
    int? progressIncrement,
    int? minutesIncrement,
    String? bookId,
  }) async {
    if (_currentUserId == null) return;

    try {
      await ReadingGoalsService.updateGoalProgress(
        userId: _currentUserId!,
        userGoalId: userGoalId,
        progressIncrement: progressIncrement,
        minutesIncrement: minutesIncrement,
        bookId: bookId,
      );

      // Refresh user goals to get updated data
      await fetchUserGoals(forceRefresh: true);
    } catch (e) {
      debugPrint("Error updating goal progress: $e");
      _error = e.toString();
      notifyListeners();
    }
  }

  // Track reading activity (called when user completes a book)
  Future<void> trackReadingActivity({
    required String bookId,
    required int minutesRead,
  }) async {
    if (_currentUserId == null) return;

    try {
      debugPrint("Tracking reading activity: book=$bookId, minutes=$minutesRead");
      
      await ReadingGoalsService.trackReadingActivity(
        userId: _currentUserId!,
        bookId: bookId,
        minutesRead: minutesRead,
      );

      // Refresh user goals to reflect updates
      await fetchUserGoals(forceRefresh: true);
      
      debugPrint("Reading activity tracked successfully");
    } catch (e) {
      debugPrint("Error tracking reading activity: $e");
    }
  }

  // Pause/Resume a goal
  Future<bool> updateGoalStatus({
    required String userGoalId,
    required String status,
  }) async {
    if (_currentUserId == null) return false;

    try {
      await ReadingGoalsService.updateGoalStatus(
        userId: _currentUserId!,
        userGoalId: userGoalId,
        status: status,
      );

      // Update local state
      final goalIndex = _activeGoals.indexWhere((g) => g.userGoalId == userGoalId);
      if (goalIndex != -1) {
        _activeGoals[goalIndex] = _activeGoals[goalIndex].copyWith(status: status);
        
        // Update primary goal if needed
        if (_primaryGoal?.userGoalId == userGoalId) {
          _primaryGoal = _activeGoals[goalIndex];
        }
      }

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint("Error updating goal status: $e");
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Delete a user goal
  Future<bool> deleteUserGoal(String userGoalId) async {
    if (_currentUserId == null) return false;

    try {
      await ReadingGoalsService.deleteUserGoal(
        userId: _currentUserId!,
        userGoalId: userGoalId,
      );

      // Update local state
      _activeGoals.removeWhere((g) => g.userGoalId == userGoalId);
      
      // Update primary goal
      if (_primaryGoal?.userGoalId == userGoalId) {
        _primaryGoal = _activeGoals.isNotEmpty ? _activeGoals.first : null;
      }

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint("Error deleting user goal: $e");
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Check if user has a specific goal type active
  bool hasActiveGoalOfType(String goalType) {
    return _activeGoals.any((goal) => 
      goal.goalType == goalType && 
      goal.isActive
    );
  }

  // Get active goal by type
  UserGoal? getActiveGoalByType(String goalType) {
    try {
      return _activeGoals.firstWhere((goal) => 
        goal.goalType == goalType && 
        goal.isActive
      );
    } catch (e) {
      return null;
    }
  }

  // Get goal template by ID
  ReadingGoal? getGoalTemplate(String goalId) {
    try {
      return _goalTemplates.firstWhere((goal) => goal.goalId == goalId);
    } catch (e) {
      return null;
    }
  }

  // Calculate overall progress across all goals
  double get overallProgress {
    if (_activeGoals.isEmpty) return 0.0;
    
    double totalProgress = 0.0;
    for (final goal in _activeGoals) {
      totalProgress += goal.progressPercentage;
    }
    
    return totalProgress / _activeGoals.length;
  }

  // Get total books read this month
  int get booksReadThisMonth {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    
    int totalBooks = 0;
    for (final goal in _activeGoals) {
      // Count books completed this month
      final monthlyBooks = goal.booksCompleted.length; // Simplified for now
      totalBooks += monthlyBooks;
    }
    
    return totalBooks;
  }

  // Get suggested next goal based on user's reading pattern
  ReadingGoal? getSuggestedNextGoal() {
    if (_goalTemplates.isEmpty) return null;
    
    // Simple logic: suggest a goal that user doesn't have active
    final activeGoalTypes = _activeGoals.map((g) => g.goalType).toSet();
    
    for (final template in _goalTemplates) {
      if (!activeGoalTypes.contains(template.type)) {
        return template;
      }
    }
    
    return null;
  }

  // Refresh all data
  Future<void> refreshData() async {
    await Future.wait([
      fetchGoalTemplates(forceRefresh: true),
      fetchUserGoals(forceRefresh: true),
    ]);
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Initialize provider (call this when user logs in)
  Future<void> initialize() async {
    if (_currentUserId == null) return;
    
    await Future.wait([
      fetchGoalTemplates(),
      fetchUserGoals(),
    ]);
  }

  // Clear all data (call this when user logs out)
  void clearData() {
    _goalTemplates = [];
    _activeGoals = [];
    _primaryGoal = null;
    _goalStats = {};
    _isLoading = false;
    _isLoadingUserGoals = false;
    _error = null;
    notifyListeners();
  }
}
