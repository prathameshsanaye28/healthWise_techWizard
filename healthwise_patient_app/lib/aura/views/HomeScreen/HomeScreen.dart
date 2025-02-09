import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../components/app_drawer.dart';
import '../../localization/locales.dart';
import '../../models/task.dart';
import '../../models/user.dart' as ModelUser;
import '../../models/user.dart';
import '../../resources/user_provider.dart';
import '../JournalScreen4.dart';
import '../calm_now/calm_now_screen.dart';
import '../games/relaxing_game/Screens/game_screen.dart';
import '../health_wellness_tracker.dart';
import '../music_screen/app.dart';
import '../therapist_screen.dart';

// Custom Toggle Switch Widget
class CustomToggleSwitch extends StatelessWidget {
  final bool isCalmMode;
  final Function(bool) onToggle;

  const CustomToggleSwitch({
    super.key,
    required this.isCalmMode,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onToggle(!isCalmMode),
      child: Container(
        width: 70,
        height: 35,
        decoration: BoxDecoration(
          color: const Color(0xFFE6E6FA),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            AnimatedAlign(
              duration: const Duration(milliseconds: 200),
              alignment:
                  isCalmMode ? Alignment.centerLeft : Alignment.centerRight,
              child: Container(
                width: 35,
                height: 35,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Center(
                  child: Icon(
                    isCalmMode ? Icons.spa : Icons.flash_on,
                    size: 20,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true;
  bool _isCalmMode = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Task> _tasks = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.refreshUser();
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      _loadTasks(userProvider.getUser!.uid);
    }
  }

  Future<void> _loadTasks(String userId) async {
    final QuerySnapshot snapshot = await _firestore
        .collection('tasks')
        .where('userId', isEqualTo: userId)
        .get();
    final tasks = snapshot.docs.map((doc) => Task.fromDocument(doc)).toList();
    setState(() {
      _tasks = tasks;
    });
  }

  Future<void> _addTask(String title, String priority) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final newTask = Task(
      id: '',
      title: title,
      priority: priority,
      userId: userProvider.getUser!.uid,
    );
    final docRef = await _firestore.collection('tasks').add(newTask.toMap());
    setState(() {
      _tasks.add(newTask.copyWith(id: docRef.id));
    });
  }

  Future<void> _toggleTaskCompletion(Task task) async {
    final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
    await _firestore
        .collection('tasks')
        .doc(task.id)
        .update(updatedTask.toMap());
    setState(() {
      _tasks = _tasks.map((t) => t.id == task.id ? updatedTask : t).toList();
    });
  }

  void _showAddTaskDialog() {
    final TextEditingController titleController = TextEditingController();
    String priority = 'Low';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Task Title'),
              ),
              DropdownButton<String>(
                value: priority,
                onChanged: (value) {
                  setState(() {
                    priority = value!;
                  });
                },
                items: ['Low', 'Medium', 'High']
                    .map((priority) => DropdownMenuItem(
                          value: priority,
                          child: Text(priority),
                        ))
                    .toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _addTask(titleController.text, priority);
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ModelUser.Patient? user = Provider.of<UserProvider>(context).getUser;

    if (_isLoading || user == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          const SizedBox(width: 10),
          CustomToggleSwitch(
            isCalmMode: _isCalmMode,
            onToggle: (value) {
              setState(() {
                _isCalmMode = value;
              });
            },
          ),
          const SizedBox(width: 10),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CalmNowScreen()),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFFBE2CC),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 20),
                      Text(
                        LocaleData.calmNow.getString(context),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.self_improvement,
                          color: Color.fromARGB(255, 0, 0, 0),
                          weight: 5,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CalmNowScreen()),
                          );
                        },
                        tooltip: LocaleData.calmNow
                            .getString(context), // Add tooltip
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 10),
        ],
      ),
      drawer: const AppDrawer(currentRoute: '/home'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 0.0),
              _buildMoodIcons(user.fullname),
              const SizedBox(height: 20.0),
              _buildTherapySessions(),
              const SizedBox(height: 20.0),
              _buildActivities(),
              const SizedBox(height: 20.0),
              _buildTasks(),
            ],
          ),
        ),
      ),
      backgroundColor: _isCalmMode
          ? const Color(0xFFF5F5F5)
          : Colors.white, // Change background based on mode
    );
  }

  Widget _buildHeader(String photoUrl, String name) {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(photoUrl),
          radius: 20.0,
        ),
      ],
    );
  }

  Widget _buildMoodIcons(String name) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${LocaleData.welcomeBack.getString(context)},\n$name!', // Update this line
                  style: TextStyle(
                    color: _isCalmMode
                        ? const Color(0xFF2E4052)
                        : const Color.fromRGBO(55, 27, 52, 1),
                    fontSize: 26.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  LocaleData.howAreYouFeeling
                      .getString(context), // Update this line
                  style: TextStyle(
                    color: _isCalmMode
                        ? const Color(0xFF2E4052)
                        : const Color.fromRGBO(55, 27, 52, 1),
                    fontSize: 20.0,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildMoodIcon(
              iconPath: 'assets/icons/happy_icon.svg',
              label: LocaleData.happy.getString(context), // Update this line
              bgColor: _isCalmMode
                  ? const Color(0xFFB8E3E9)
                  : const Color(0xFFEF5DA8),
            ),
            _buildMoodIcon(
              iconPath: 'assets/icons/calm_icon.svg',
              label: LocaleData.calm.getString(context), // Update this line
              bgColor: _isCalmMode
                  ? const Color(0xFFC5E8B8)
                  : const Color(0xFFAEAFF7),
            ),
            _buildMoodIcon(
              iconPath: 'assets/icons/relax_icon.svg',
              label: LocaleData.low.getString(context), // Update this line
              bgColor: _isCalmMode
                  ? const Color(0xFFE8D5B8)
                  : const Color(0xFFF09A59),
            ),
            _buildMoodIcon(
              iconPath: 'assets/icons/focus_icon.svg',
              label: LocaleData.stressed.getString(context), // Update this line
              bgColor: _isCalmMode
                  ? const Color(0xFFB8C5E8)
                  : const Color(0xFFA0E3E2),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMoodIcon({
    required String iconPath,
    required String label,
    required Color bgColor,
  }) {
    return Column(
      children: [
        Container(
          height: 70,
          width: 70,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            color: bgColor,
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: SvgPicture.asset(
              iconPath,
              width: 32.0,
              height: 32.0,
            ),
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          label,
          style: TextStyle(
            color:
                _isCalmMode ? const Color(0xFF2E4052) : const Color(0xFF60554D),
            fontSize: 14.0,
          ),
          overflow: TextOverflow.ellipsis, // Add text overflow handling
        ),
      ],
    );
  }

  Widget _buildTherapySessions() {
    final Patient? user = Provider.of<UserProvider>(context).getUser;

    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: _isCalmMode ? const Color(0xFFE8D5B8) : const Color(0xFFFBE2CC),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocaleData.therapySessions
                    .getString(context), // Update this line
                style: TextStyle(
                  color: _isCalmMode
                      ? const Color(0xFF2E4052)
                      : const Color(0xFF573926),
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                LocaleData.openUp.getString(context), // Update this line
                style: TextStyle(
                  color: _isCalmMode
                      ? const Color(0xFF2E4052)
                      : const Color(0xFF60554D),
                  fontSize: 11.0,
                ),
                overflow: TextOverflow.ellipsis, // Add text overflow handling
              ),
              Text(
                LocaleData.matterMost.getString(context), // Update this line
                style: TextStyle(
                  color: _isCalmMode
                      ? const Color(0xFF2E4052)
                      : const Color(0xFF60554D),
                  fontSize: 11.0,
                ),
                overflow: TextOverflow.ellipsis, // Add text overflow handling
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TherapistScreen(
                          userUid: user!.uid,
                        ),
                      ));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isCalmMode
                      ? const Color(0xFF92A8D1)
                      : const Color(0xFFF09A59),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                ),
                child: Row(
                  children: [
                    Text(LocaleData.bookNow
                        .getString(context)), // Update this line
                    const SizedBox(width: 8.0),
                    SvgPicture.asset("assets/icons/book_icon.svg"),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(width: 10),
          Column(
            children: [
              Image.asset(
                "assets/icons/meetup_icon.png",
                height: 90,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActivities() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const DiaryScreen()));
          },
          child: _buildActivityIcon(
            iconPath: 'assets/icons/journal_icon.svg',
            label: LocaleData.journal.getString(context), // Update this line
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const MusicAppScreen()));
          },
          child: _buildActivityIcon(
            iconPath: 'assets/icons/music_icon.svg',
            label: LocaleData.music.getString(context), // Update this line
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const HealthWellnessTrackerScreen()));
          },
          child: _buildActivityIcon(
            iconPath: 'assets/icons/meditation_icon.svg',
            label: LocaleData.meditation.getString(context), // Update this line
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => const GameScreen()));
          },
          child: _buildActivityIcon(
            iconPath: 'assets/icons/relaxing_games_icon.svg',
            label: LocaleData.games.getString(context), // Update this line
          ),
        ),
      ],
    );
  }

  Widget _buildActivityIcon({
    required String iconPath,
    required String label,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8.0),
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(27.0),
            color: _isCalmMode
                ? const Color.fromRGBO(230, 230, 250, 0.68)
                : const Color.fromRGBO(255, 225, 241, 0.68),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset(
              iconPath,
              width: 24.0,
              height: 24.0,
              color: _isCalmMode
                  ? const Color(0xFF92A8D1)
                  : const Color(0xFFD30A9A),
            ),
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          label,
          style: TextStyle(
            color:
                _isCalmMode ? const Color(0xFF2E4052) : const Color(0xFF60554D),
            fontSize: 14.0,
          ),
          overflow: TextOverflow.ellipsis, // Add text overflow handling
        ),
      ],
    );
  }

  Widget _buildTasks() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              LocaleData.yourTasks.getString(context), // Update this line
              style: TextStyle(
                color: _isCalmMode ? const Color(0xFF2E4052) : Colors.black,
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: _showAddTaskDialog,
            ),
          ],
        ),
        const SizedBox(height: 16.0),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _tasks.map((task) => _buildTaskItem(task)).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildTaskItem(Task task) {
    return GestureDetector(
      onTap: () => _toggleTaskCompletion(task),
      child: Container(
        height: 120,
        width: 200,
        decoration: BoxDecoration(
          color: task.isCompleted
              ? Colors.grey
              : _isCalmMode
                  ? const Color.fromRGBO(230, 230, 250, 0.31)
                  : const Color.fromRGBO(198, 199, 255, 0.31),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          children: [
            const SizedBox(width: 16.0),
            Icon(
              task.isCompleted
                  ? Icons.check_circle
                  : Icons.check_circle_outline,
              color: _isCalmMode
                  ? const Color(0xFF2E4052)
                  : const Color(0xFF60554D),
              size: 24.0,
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Text(
                task.title,
                style: TextStyle(
                  color: _isCalmMode
                      ? const Color(0xFF2E4052)
                      : const Color(0xFF60554D),
                  fontSize: 16.0,
                ),
                overflow: TextOverflow.ellipsis, // Add text overflow handling
              ),
            ),
          ],
        ),
      ),
    );
  }
}
