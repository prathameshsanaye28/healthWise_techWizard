import 'package:appinio_video_player/appinio_video_player.dart';
// Models
import 'package:flutter/material.dart';

class Exercise {
  final String name;
  final String description;
  final String videoUrl;
  final List<String> ageGroups;
  final int durationMinutes;
  final String difficulty;
  final String category;
  final IconData icon; // Added icon property

  Exercise({
    required this.name,
    required this.description,
    required this.videoUrl,
    required this.ageGroups,
    required this.durationMinutes,
    required this.difficulty,
    required this.category,
    required this.icon,
  });
}

class HealthWellnessTrackerScreen extends StatefulWidget {
  const HealthWellnessTrackerScreen({super.key});

  @override
  _HealthWellnessTrackerScreenState createState() =>
      _HealthWellnessTrackerScreenState();
}

class _HealthWellnessTrackerScreenState
    extends State<HealthWellnessTrackerScreen> {
  String selectedAgeGroup = 'all';
  String selectedDifficulty = 'all';
  String selectedCategory = 'all';

  final List<Exercise> exercises = [
    Exercise(
      name: 'Morning Yoga',
      description: 'Start your day with gentle yoga poses',
      videoUrl: 'assets/videos/stretching.mp4',
      ageGroups: ['teen', 'adult', 'middle'],
      durationMinutes: 15,
      difficulty: 'Easy',
      category: 'Yoga',
      icon: Icons.self_improvement,
    ),
    Exercise(
      name: 'Cardio Workout',
      description: 'High-energy cardio session',
      videoUrl: 'assets/videos/walking.mp4',
      ageGroups: ['teen', 'adult'],
      durationMinutes: 20,
      difficulty: 'Hard',
      category: 'Cardio',
      icon: Icons.directions_run,
    ),
    Exercise(
      name: 'Senior Stretching',
      description: 'Gentle stretching for seniors',
      videoUrl: 'assets/videos/stretching.mp4',
      ageGroups: ['senior'],
      durationMinutes: 10,
      difficulty: 'Easy',
      category: 'Stretching',
      icon: Icons.accessibility_new,
    ),
  ];

  List<Exercise> getFilteredExercises() {
    return exercises.where((exercise) {
      bool ageMatch = selectedAgeGroup == 'all' ||
          exercise.ageGroups.contains(selectedAgeGroup);
      bool difficultyMatch = selectedDifficulty == 'all' ||
          exercise.difficulty == selectedDifficulty;
      bool categoryMatch =
          selectedCategory == 'all' || exercise.category == selectedCategory;
      return ageMatch && difficultyMatch && categoryMatch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Color(0xFFFCEFF4), // Light pink background from the image
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Purple from the image
        title: Text(
          'Exercise Library',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildFilterSection(),
          Expanded(
            child: _buildExerciseList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          _buildFilterDropdown(
            value: selectedAgeGroup,
            label: 'Age Group',
            icon: Icons.people,
            items: [
              DropdownMenuItem(value: 'all', child: Text('All Ages')),
              DropdownMenuItem(value: 'teen', child: Text('Teen')),
              DropdownMenuItem(value: 'adult', child: Text('Adult')),
              DropdownMenuItem(value: 'middle', child: Text('Middle Age')),
              DropdownMenuItem(value: 'senior', child: Text('Senior')),
            ],
            onChanged: (value) => setState(() => selectedAgeGroup = value!),
          ),
          SizedBox(height: 12),
          _buildFilterDropdown(
            value: selectedDifficulty,
            label: 'Difficulty',
            icon: Icons.fitness_center,
            items: [
              DropdownMenuItem(value: 'all', child: Text('All Difficulties')),
              DropdownMenuItem(value: 'Easy', child: Text('Easy')),
              DropdownMenuItem(value: 'Medium', child: Text('Medium')),
              DropdownMenuItem(value: 'Hard', child: Text('Hard')),
            ],
            onChanged: (value) => setState(() => selectedDifficulty = value!),
          ),
          SizedBox(height: 12),
          _buildFilterDropdown(
            value: selectedCategory,
            label: 'Category',
            icon: Icons.category,
            items: [
              DropdownMenuItem(value: 'all', child: Text('All Categories')),
              DropdownMenuItem(value: 'Yoga', child: Text('Yoga')),
              DropdownMenuItem(value: 'Cardio', child: Text('Cardio')),
              DropdownMenuItem(value: 'Stretching', child: Text('Stretching')),
            ],
            onChanged: (value) => setState(() => selectedCategory = value!),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown({
    required String value,
    required String label,
    required IconData icon,
    required List<DropdownMenuItem<String>> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFEEE5FF), // Light purple from the image
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
          icon: Icon(icon, color: Color(0xFF452C55)),
          labelStyle: TextStyle(color: Color(0xFF452C55)),
        ),
        items: items,
        onChanged: onChanged,
        dropdownColor: Color(0xFFEEE5FF),
      ),
    );
  }

  Widget _buildExerciseList() {
    final filteredExercises = getFilteredExercises();
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: filteredExercises.length,
      itemBuilder: (context, index) {
        final exercise = filteredExercises[index];
        return Card(
          elevation: 4,
          margin: EdgeInsets.only(bottom: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ListTile(
            contentPadding: EdgeInsets.all(16),
            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Color(0xFFFF9966), // Orange from the image
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                exercise.icon,
                color: Colors.white,
                size: 30,
              ),
            ),
            title: Text(
              exercise.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF452C55),
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8),
                Text(
                  '${exercise.durationMinutes} minutes - ${exercise.difficulty}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                Text(
                  exercise.category,
                  style: TextStyle(
                    color: Color(0xFFFF9966),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            trailing: Container(
              decoration: BoxDecoration(
                color: Color(0xFFEEE5FF),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.all(8),
              child: Icon(
                Icons.play_arrow,
                color: Color(0xFF452C55),
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ExerciseVideoScreen(exercise: exercise),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class ExerciseVideoScreen extends StatefulWidget {
  final Exercise exercise;

  const ExerciseVideoScreen({super.key, required this.exercise});

  @override
  _ExerciseVideoScreenState createState() => _ExerciseVideoScreenState();
}

class _ExerciseVideoScreenState extends State<ExerciseVideoScreen> {
  late CustomVideoPlayerController _customVideoPlayerController;
  late VideoPlayerController _videoPlayerController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  void _initializeVideoPlayer() async {
    try {
      _videoPlayerController =
          VideoPlayerController.asset(widget.exercise.videoUrl)
            ..initialize().then((_) {
              setState(() {
                _isLoading = false;
              });
            });

      _customVideoPlayerController = CustomVideoPlayerController(
        context: context,
        videoPlayerController: _videoPlayerController,
        customVideoPlayerSettings: const CustomVideoPlayerSettings(
          showSeekButtons: true,
          showPlayButton: true,
          playButton: Icon(Icons.play_arrow),
          pauseButton: Icon(Icons.pause),
          enterFullscreenButton: Icon(Icons.fullscreen),
          exitFullscreenButton: Icon(Icons.fullscreen_exit),
        ),
      );
    } catch (e) {
      print('Error initializing video player: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _customVideoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.exercise.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: _buildVideoPlayer(),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                widget.exercise.description,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoPlayer() {
    if (_isLoading) {
      return Container(
        color: Colors.black12,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return CustomVideoPlayer(
      customVideoPlayerController: _customVideoPlayerController,
    );
  }
}