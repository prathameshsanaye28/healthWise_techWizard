import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';

class StepsDetailsScreen extends StatefulWidget {
  static const routeName = '/steps-details';

  const StepsDetailsScreen({super.key});

  @override
  State<StepsDetailsScreen> createState() => _StepsDetailsScreenState();
}

class _StepsDetailsScreenState extends State<StepsDetailsScreen> {
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  String _status = 'unknown';
  String _steps = '0';
  bool _isLoading = true;
  String _error = '';
  final List<Activity> _activities = [];

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<bool> _checkActivityRecognitionPermission() async {
    bool granted = await Permission.activityRecognition.isGranted;
    if (!granted) {
      granted = await Permission.activityRecognition.request() ==
          PermissionStatus.granted;
    }
    return granted;
  }

  Future<void> initPlatformState() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      bool granted = await _checkActivityRecognitionPermission();
      if (!granted) {
        setState(() {
          _error = 'Permission required to track steps';
          _isLoading = false;
        });
        return;
      }

      _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
      _stepCountStream = Pedometer.stepCountStream;

      _pedestrianStatusStream
          .listen(onPedestrianStatusChanged)
          .onError(onPedestrianStatusError);
      _stepCountStream.listen(onStepCount).onError(onStepCountError);
    } catch (e) {
      setState(() {
        _error = 'Could not initialize step counting: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void onStepCount(StepCount event) {
    print('Step count: ${event.steps}');
    setState(() {
      _steps = event.steps.toString();
      if (_status == 'walking') {
        final now = DateTime.now();
        if (_activities.isEmpty ||
            now.difference(_activities.last.endTime).inMinutes >= 30) {
          _activities.add(Activity(
            startTime: now,
            endTime: now,
            steps: 0,
            distance: 0,
          ));
        }
        final lastActivity = _activities.last;
        _activities.last = Activity(
          startTime: lastActivity.startTime,
          endTime: now,
          steps: event.steps - int.parse(_steps),
          distance: ((event.steps - int.parse(_steps)) * 0.762).round() / 1000,
        );
      }
    });
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    print('Pedestrian status: ${event.status}');
    setState(() {
      _status = event.status;
    });
  }

  void onPedestrianStatusError(error) {
    print('Pedestrian status error: $error');
    setState(() {
      _status = 'unknown';
      _error = 'Pedestrian status not available';
    });
  }

  void onStepCountError(error) {
    print('Step count error: $error');
    setState(() {
      _steps = '0';
      _error = 'Step count not available';
    });
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF8277FF),
        ),
      );
    }

    if (_error.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              _error,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: initPlatformState,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8277FF),
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        const Text(
          'Great Work!',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),
        ),
        const Text(
          'Your Daily Tasks\nAlmost Done!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 30),
        // Steps Progress Indicator
        SizedBox(
          height: 200,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 200,
                height: 200,
                child: CircularProgressIndicator(
                  value: int.parse(_steps) / 10000,
                  strokeWidth: 10,
                  backgroundColor: Colors.grey.withOpacity(0.2),
                  color: const Color(0xFF8277FF),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _status == 'walking'
                        ? Icons.directions_walk
                        : _status == 'stopped'
                            ? Icons.accessibility_new
                            : Icons.error,
                    color: const Color(0xFF8277FF),
                  ),
                  Text(
                    _steps,
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Steps',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  if (_status != 'unknown')
                    Text(
                      _status,
                      style: TextStyle(
                        color: _status == 'walking'
                            ? const Color(0xFF8277FF)
                            : Colors.grey,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),
        // Activity Section
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'My Activity',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Row(
                children: [
                  Text(
                    'Today',
                    style: TextStyle(
                      color: Color(0xFF8277FF),
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: Color(0xFF8277FF),
                  ),
                ],
              ),
            ),
          ],
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _activities.length,
            itemBuilder: (context, index) {
              final activity = _activities[index];
              return ActivityCard(activity: activity);
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Text(
                    'Steps Details',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    color: const Color(0xFF8277FF),
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(child: _buildContent()),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: const Color(0xFF8277FF),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Workout',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Statistics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class Activity {
  final DateTime startTime;
  final DateTime endTime;
  final int steps;
  final double distance;

  Activity({
    required this.startTime,
    required this.endTime,
    required this.steps,
    required this.distance,
  });
}

class ActivityCard extends StatelessWidget {
  final Activity activity;

  const ActivityCard({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    final duration = activity.endTime.difference(activity.startTime);
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;

    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const Icon(Icons.directions_walk, color: Color(0xFF8277FF)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${DateFormat('h:mm a').format(activity.startTime)}-${DateFormat('h:mm a').format(activity.endTime)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Time',
                              style: TextStyle(color: Colors.grey),
                            ),
                            Text(
                              '${hours}h ${minutes}min',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Distance',
                              style: TextStyle(color: Colors.grey),
                            ),
                            Text(
                              '${activity.distance.toStringAsFixed(1)}km',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF8277FF).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '+${activity.steps}',
                style: const TextStyle(
                  color: Color(0xFF8277FF),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
