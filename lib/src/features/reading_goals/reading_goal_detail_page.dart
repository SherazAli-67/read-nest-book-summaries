import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:read_nest/src/widgets/book_card_shimmer.dart';
import '../../models/reading_goal_model.dart';
import '../../models/user_goal_model.dart';
import '../../models/book_model.dart';
import '../../providers/reading_goals_provider.dart';
import '../../providers/books_provider.dart';
import '../../services/books_service.dart';
import '../../res/app_textstyle.dart';
import '../../res/app_colors.dart';
import '../../widgets/book_card_widget.dart';

class ReadingGoalDetailPage extends StatefulWidget {
  final ReadingGoal goal;

  const ReadingGoalDetailPage({
    super.key,
    required this.goal,
  });

  @override
  State<ReadingGoalDetailPage> createState() => _ReadingGoalDetailPageState();
}

class _ReadingGoalDetailPageState extends State<ReadingGoalDetailPage>
    with TickerProviderStateMixin {
  late AnimationController _progressAnimationController;
  late Animation<double> _progressAnimation;
  
  String _selectedCategory = 'All';
  List<Book> _suggestedBooks = [];
  bool _loadingBooks = true;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _loadSuggestedBooks();
    
    // Fetch user goals to get progress
    WidgetsBinding.instance.addPostFrameCallback((_)=> context.read<ReadingGoalsProvider>().fetchUserGoals());
  }

  void _setupAnimations() {
    _progressAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressAnimationController,
      curve: Curves.easeInOut,
    ));
    
    _progressAnimationController.forward();
  }

  Future<void> _loadSuggestedBooks() async {
    setState(() => _loadingBooks = true);
    
    try {
      // Get all books and filter by goal's suggested categories
      final allBooks = await BooksService.getAllBooks();
      
      _suggestedBooks = allBooks.where((book) {
        return book.categories.any((category) => 
          widget.goal.suggestedCategories.contains(category)
        );
      }).take(20).toList();
      
      // If no books found in suggested categories, show some popular books
      if (_suggestedBooks.isEmpty) {
        final popularBooks = context.read<BooksProvider>().trendingBooks;
        _suggestedBooks = popularBooks.take(10).toList();
      }
      
    } catch (e) {
      debugPrint('Error loading suggested books: $e');
      // Fallback to trending books
      _suggestedBooks = context.read<BooksProvider>().trendingBooks.take(10).toList();
    } finally {
      setState(() => _loadingBooks = false);
    }
  }

  @override
  void dispose() {
    _progressAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildGoalOverview(),
                _buildUserProgressSection(),
                _buildSuggestedBooksSection(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      pinned: true,
      backgroundColor: widget.goal.color.withValues(alpha: 0.1),
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                widget.goal.color.withValues(alpha: 0.2),
                widget.goal.color.withValues(alpha: 0.05),
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Icon(
                    widget.goal.icon,
                    size: 48,
                    color: widget.goal.color,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back_rounded, color: widget.goal.color),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildGoalOverview() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.goal.title,
                      style: AppTextStyles.titleTextStyle.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.goal.description,
                      style: AppTextStyles.regularTextStyle.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Consumer<ReadingGoalsProvider>(
                builder: (context, provider, _) {
                  final isActive = provider.hasActiveGoalOfType(widget.goal.type);
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isActive ? widget.goal.color : Colors.grey,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      isActive ? 'ACTIVE' : 'INACTIVE',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildDetailCards(),
        ],
      ),
    );
  }

  Widget _buildDetailCards() {
    return Row(
      children: [
        Expanded(
          child: _buildDetailCard(
            'Target',
            widget.goal.targetType == 'books'
                ? '${widget.goal.targetValue} books'
                : '${widget.goal.targetValue} minutes',
            Icons.ac_unit_rounded,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildDetailCard(
            'Timeframe',
            widget.goal.timeframe.toUpperCase(),
            Icons.schedule_rounded,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildDetailCard(
            'Difficulty',
            widget.goal.difficulty.toUpperCase(),
            Icons.fitness_center_rounded,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: widget.goal.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: widget.goal.color, size: 24),
          const SizedBox(height: 8),
          Text(
            title,
            style: AppTextStyles.smallTextStyle.copyWith(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTextStyles.smallTextStyle.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildUserProgressSection() {
    return Consumer<ReadingGoalsProvider>(
      builder: (context, provider, _) {
        final userGoal = provider.getActiveGoalByType(widget.goal.type);
        final hasActiveGoal = userGoal != null;
        
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.trending_up_rounded,
                    color: widget.goal.color,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    hasActiveGoal ? 'Your Progress' : 'Ready to Start?',
                    style: AppTextStyles.regularTextStyle.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              
              if (hasActiveGoal) ...[
                _buildProgressBar(userGoal),
                const SizedBox(height: 16),
                _buildProgressStats(userGoal),
                const SizedBox(height: 20),
                _buildProgressActions(userGoal, provider),
              ] else ...[
                _buildStartGoalPrompt(provider),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildProgressBar(UserGoal userGoal) {
    final progress = userGoal.progressPercentage;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${userGoal.currentProgress} / ${userGoal.targetValue}',
              style: AppTextStyles.smallTextStyle.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${(progress * 100).round()}%',
              style: AppTextStyles.smallTextStyle.copyWith(
                color: widget.goal.color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        AnimatedBuilder(
          animation: _progressAnimation,
          builder: (context, child) {
            return LinearProgressIndicator(
              value: progress * _progressAnimation.value,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(widget.goal.color),
              minHeight: 8,
            );
          },
        ),
      ],
    );
  }

  Widget _buildProgressStats(UserGoal userGoal) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Remaining',
            '${userGoal.remainingTarget}',
            userGoal.targetType == 'books' ? 'books' : 'mins',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Days Left',
            '${userGoal.daysRemaining}',
            'days',
          ),
        ),
        if (userGoal.targetType == 'books') ...[
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'Books Read',
              '${userGoal.booksCompleted.length}',
              'books',
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildStatCard(String title, String value, String unit) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.textFieldFillColor.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: AppTextStyles.regularTextStyle.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Text(
            unit,
            style: AppTextStyles.smallTextStyle.copyWith(
              fontSize: 10,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: AppTextStyles.smallTextStyle.copyWith(
              fontSize: 11,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressActions(UserGoal userGoal, ReadingGoalsProvider provider) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              // TODO: Navigate to goal management page
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Goal management coming soon'),
                  backgroundColor: widget.goal.color,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.goal.color,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.settings_rounded, size: 18),
            label: const Text('Manage Goal'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: userGoal.status == 'active'
                ? () => _pauseGoal(userGoal, provider)
                : () => _resumeGoal(userGoal, provider),
            style: OutlinedButton.styleFrom(
              foregroundColor: widget.goal.color,
              side: BorderSide(color: widget.goal.color),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: Icon(
              userGoal.status == 'active' ? Icons.pause_rounded : Icons.play_arrow_rounded,
              size: 18,
            ),
            label: Text(userGoal.status == 'active' ? 'Pause' : 'Resume'),
          ),
        ),
      ],
    );
  }

  Widget _buildStartGoalPrompt(ReadingGoalsProvider provider) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: widget.goal.color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Icon(
                Icons.rocket_launch_rounded,
                color: widget.goal.color,
                size: 48,
              ),
              const SizedBox(height: 12),
              Text(
                'Start Your Reading Journey',
                style: AppTextStyles.regularTextStyle.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Begin this goal and track your progress as you read amazing books!',
                style: AppTextStyles.smallTextStyle.copyWith(
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => _startGoal(provider),
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.goal.color,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.play_arrow_rounded),
            label: const Text('Start This Goal'),
          ),
        ),
      ],
    );
  }

  Widget _buildSuggestedBooksSection() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.auto_stories_rounded,
                color: widget.goal.color,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Recommended Books',
                style: AppTextStyles.regularTextStyle.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildCategoryTabs(),
          const SizedBox(height: 16),
          _buildBooksGrid(),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs() {
    final categories = ['All', ...widget.goal.suggestedCategories];
    
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = _selectedCategory == category;
          
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ChoiceChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedCategory = category;
                });
              },
              selectedColor: widget.goal.color.withValues(alpha: 0.2),
              backgroundColor: Colors.grey[200],
              labelStyle: TextStyle(
                color: isSelected ? widget.goal.color : Colors.grey[600],
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBooksGrid() {
    if (_loadingBooks) {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: 6,
        itemBuilder: (context, index) => const GridBookCardShimmer(),
      );
    }

    final filteredBooks = _selectedCategory == 'All'
        ? _suggestedBooks
        : _suggestedBooks.where((book) =>
            book.categories.contains(_selectedCategory)).toList();

    if (filteredBooks.isEmpty) {
      return SizedBox(
        height: 200,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.book_outlined, size: 48, color: Colors.grey[400]),
              const SizedBox(height: 8),
              Text(
                'No books found in this category',
                style: AppTextStyles.smallTextStyle.copyWith(color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: filteredBooks.length.clamp(0, 8),
      itemBuilder: (context, index) {
        final book = filteredBooks[index];
        return BookCard(
          book: book,
        );
      },
    );
  }

  // Goal management actions
  Future<void> _startGoal(ReadingGoalsProvider provider) async {
    final success = await provider.createUserGoal(template: widget.goal);
    
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Started ${widget.goal.title} goal!'),
          backgroundColor: widget.goal.color,
        ),
      );
      setState(() {}); // Refresh the UI
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to start goal. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _pauseGoal(UserGoal userGoal, ReadingGoalsProvider provider) async {
    final success = await provider.updateGoalStatus(
      userGoalId: userGoal.userGoalId,
      status: 'paused',
    );
    
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Goal paused'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  Future<void> _resumeGoal(UserGoal userGoal, ReadingGoalsProvider provider) async {
    final success = await provider.updateGoalStatus(
      userGoalId: userGoal.userGoalId,
      status: 'active',
    );
    
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Goal resumed'),
          backgroundColor: widget.goal.color,
        ),
      );
    }
  }
}
