import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:read_nest/src/models/book_model.dart';
import 'package:read_nest/src/res/app_colors.dart';
import 'package:read_nest/src/res/app_textstyle.dart';
import 'package:read_nest/src/widgets/on_boarding_dot_widget.dart';

class SummaryListeningPage extends StatefulWidget {
  const SummaryListeningPage({super.key, required Book book}) : _book = book;
  final Book _book;

  @override
  State<SummaryListeningPage> createState() => _SummaryListeningPageState();
}

class _SummaryListeningPageState extends State<SummaryListeningPage>
    with TickerProviderStateMixin {
  late AudioPlayer _audioPlayer;
  int _currentSectionIndex = 0;
  bool _isPlaying = false;
  bool _isLoading = false;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;
  double _playbackSpeed = 1.0;
  Timer? _positionTimer;

  @override
  void initState() {
    super.initState();
    _initializeAudioPlayer();
  }

  void _initializeAudioPlayer() {
    _audioPlayer = AudioPlayer();

    // Listen to player state changes
    _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      setState(() {
        _isPlaying = state == PlayerState.playing;
        _isLoading = state == PlayerState.playing ? false : _isLoading;
      });
    });

    // Listen to audio duration changes
    _audioPlayer.onDurationChanged.listen((Duration duration) {
      setState(() {
        _totalDuration = duration;
      });
    });

    // Listen to position changes
    _audioPlayer.onPositionChanged.listen((Duration position) {
      setState(() {
        _currentPosition = position;
      });
    });

    // Listen to playback completion
    _audioPlayer.onPlayerComplete.listen((_) {
      _onSectionCompleted();
    });

    // Load the first section
    _loadCurrentSection();
  }

  Future<void> _loadCurrentSection() async {
    if (widget._book.sections.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final section = widget._book.sections[_currentSectionIndex];
      if (section.contentLink.isNotEmpty) {
        await _audioPlayer.setSourceUrl(section.contentLink);
        await _audioPlayer.setPlaybackRate(_playbackSpeed);
      }
    } catch (e) {
      _showErrorSnackBar('Error loading audio: ${e.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<void> _playPause() async {
    try {
      if (_isPlaying) {
        await _audioPlayer.pause();
      } else {
        await _audioPlayer.resume();
      }
    } catch (e) {
      _showErrorSnackBar('Playback error: ${e.toString()}');
    }
  }

  Future<void> _seekToPosition(Duration position) async {
    await _audioPlayer.seek(position);
  }

  Future<void> _skipForward() async {
    final newPosition = _currentPosition + const Duration(seconds: 10);
    final maxPosition = _totalDuration;
    await _seekToPosition(newPosition > maxPosition ? maxPosition : newPosition);
  }

  Future<void> _skipBackward() async {
    final newPosition = _currentPosition - const Duration(seconds: 10);
    await _seekToPosition(newPosition < Duration.zero ? Duration.zero : newPosition);
  }

  Future<void> _previousSection() async {
    if (_currentSectionIndex > 0) {
      setState(() {
        _currentSectionIndex--;
        _currentPosition = Duration.zero;
      });
      await _loadCurrentSection();
      if (_isPlaying) {
        await _audioPlayer.resume();
      }
    }
  }

  Future<void> _nextSection() async {
    if (_currentSectionIndex < widget._book.sections.length - 1) {
      setState(() {
        _currentSectionIndex++;
        _currentPosition = Duration.zero;
      });
      await _loadCurrentSection();
      if (_isPlaying) {
        await _audioPlayer.resume();
      }
    }
  }

  void _onSectionCompleted() {
    if (_currentSectionIndex < widget._book.sections.length - 1) {
      _nextSection();
    } else {
      setState(() {
        _isPlaying = false;
        _currentPosition = Duration.zero;
      });
    }
  }

  Future<void> _changePlaybackSpeed(double speed) async {
    setState(() {
      _playbackSpeed = speed;
    });
    await _audioPlayer.setPlaybackRate(speed);
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _positionTimer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final currentSection = widget._book.sections.isNotEmpty 
        ? widget._book.sections[_currentSectionIndex] 
        : null;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.bookmark_border_rounded),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            spacing: 20,
            children: [
              // Book Cover Image
              Center(
                child: Hero(
                  tag: 'bookImage-${widget._book.bookID}',
                  child: Container(
                    width: size.width * 0.7,
                    height: size.width * 0.7,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: CachedNetworkImage(
                        imageUrl: widget._book.image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              
              // Section and Book Info
              Column(
                children: [
                  // Current Section Title
                  Text(
                    currentSection?.title ?? 'Loading...',
                    style: AppTextStyles.regularTextStyle.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 8),

                  // Book Name and Author
                  Text(
                    '${widget._book.bookName} • ${widget._book.author}',
                    style: AppTextStyles.smallTextStyle.copyWith(
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 12),

                  // Section Progress
                  Text(
                    'Section ${_currentSectionIndex + 1} of ${widget._book.sections.length}',
                    style: AppTextStyles.smallTextStyle.copyWith(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Progress Bar
                  Column(
                    children: [
                      Slider(
                        value: _totalDuration.inSeconds > 0
                            ? _currentPosition.inSeconds / _totalDuration.inSeconds
                            : 0.0,
                        onChanged: (value) {
                          final position = Duration(
                            seconds: (value * _totalDuration.inSeconds).round(),
                          );
                          _seekToPosition(position);
                        },
                        activeColor: Colors.black,
                        inactiveColor: AppColors.textFieldFillColor,
                      ),

                      // Time Display
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _formatDuration(_currentPosition),
                              style: AppTextStyles.smallTextStyle.copyWith(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                            Text(
                              _formatDuration(_totalDuration),
                              style: AppTextStyles.smallTextStyle.copyWith(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // Main Controls
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Previous Section
                      IconButton(
                        onPressed: _currentSectionIndex > 0 ? _previousSection : null,
                        icon: Icon(
                          Icons.skip_previous_rounded,
                          size: 35,
                          color: _currentSectionIndex > 0 ? Colors.black : Colors.grey,
                        ),
                      ),

                      // Play/Pause Button
                      Container(
                        width: 80,
                        height: 80,
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          onPressed: _isLoading ? null : _playPause,
                          icon: _isLoading
                              ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                              : Icon(
                            _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ),

                      // Next Section
                      IconButton(
                        onPressed: _currentSectionIndex < widget._book.sections.length - 1
                            ? _nextSection
                            : null,
                        icon: Icon(
                          Icons.skip_next_rounded,
                          size: 35,
                          color: _currentSectionIndex < widget._book.sections.length - 1
                              ? Colors.black
                              : Colors.grey,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Secondary Controls (10s back/forward)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.textFieldFillColor,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: IconButton(
                          onPressed: _skipBackward,
                          icon: const Icon(Icons.replay_10_rounded),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.textFieldFillColor,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: IconButton(
                          onPressed: _skipForward,
                          icon: const Icon(Icons.forward_10_rounded),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Speed Control
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [0.5, 1.0, 1.25, 1.5, 2.0].map((speed) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: TextButton(
                          onPressed: () => _changePlaybackSpeed(speed),
                          style: TextButton.styleFrom(
                            backgroundColor: _playbackSpeed == speed
                                ? Colors.black
                                : AppColors.textFieldFillColor,
                            foregroundColor: _playbackSpeed == speed
                                ? Colors.white
                                : Colors.black,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            minimumSize: Size.zero,
                          ),
                          child: Text(
                            '${speed}x',
                            style: AppTextStyles.smallTextStyle.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
              
              // Section Progress Dots
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: OnBoardingDotWidget(
                  dotsLength: widget._book.sections.length,
                  isDarkTheme: false,
                  currentPage: _currentSectionIndex,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
