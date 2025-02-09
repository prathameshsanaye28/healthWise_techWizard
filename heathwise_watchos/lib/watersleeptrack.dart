import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LifestyleTrackingSection extends StatefulWidget {
  final double weight;
  final int age;
  final TimeOfDay bedTime;

  const LifestyleTrackingSection({
    super.key,
    required this.weight,
    required this.age,
    required this.bedTime,
    required int wakeUpTime,
  });

  @override
  State<LifestyleTrackingSection> createState() =>
      _LifestyleTrackingSectionState();
}

class _LifestyleTrackingSectionState extends State<LifestyleTrackingSection> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  int waterIntakeCount = 0;
  DateTime? lastNotificationTime;
  Timer? _phoneUsageTimer;
  bool isPhoneInUse = false;

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _setupWaterReminders();
  }

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  double calculateDailyWaterIntake() {
    double baseIntake = widget.weight * 0.033;
    if (widget.age > 65) {
      baseIntake *= 0.9;
    } else if (widget.age < 18) {
      baseIntake *= 1.1;
    }
    return baseIntake;
  }

  Future<void> _setupWaterReminders() async {
    Timer.periodic(const Duration(hours: 2), (timer) async {
      if (lastNotificationTime == null ||
          DateTime.now().difference(lastNotificationTime!) >
              const Duration(minutes: 10)) {
        await _showWaterReminder();
      }
    });
  }

  Future<void> _showWaterReminder() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'water_reminder',
      'Water Reminders',
      channelDescription: 'Reminders to drink water',
      importance: Importance.high,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Time to Hydrate!',
      'Remember to drink a glass of water',
      platformChannelSpecifics,
    );
    lastNotificationTime = DateTime.now();
  }

  Future<void> _incrementWaterIntake() async {
    print('Before increment: $waterIntakeCount');
    setState(() {
      waterIntakeCount++;
    });
    print('After increment: $waterIntakeCount');
  }

  @override
  Widget build(BuildContext context) {
    final dailyWaterTarget = calculateDailyWaterIntake();
    final glassesRecommended =
        (dailyWaterTarget * 1000 / 250).round(); // Assuming 250ml per glass

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(20.0), // Set custom height
        child: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, size: 12),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text(
            'Lifestyle Tracking',
            style: TextStyle(fontSize: 8),
          ),
          backgroundColor: const Color(0xFF8277FF),
          elevation: 0,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: const Color(0xFFEBECFF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Daily Water Intake',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF8277FF),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Recommended: ${dailyWaterTarget.toStringAsFixed(1)} L ($glassesRecommended glasses)',
                    style: const TextStyle(fontSize: 10),
                  ),
                  const SizedBox(height: 8),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Current: $waterIntakeCount glasses',
                        style: const TextStyle(fontSize: 10),
                      ),
                      GestureDetector(
                        onTap: _incrementWaterIntake, // Calls the function when tapped
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 3, horizontal: 8), // Adjust padding
                          decoration: BoxDecoration(
                            color: const Color(0xFF8277FF), // Background color
                            borderRadius: BorderRadius.circular(4), // Rounded corners
                          ),
                          child: const Text(
                            '+ Add Glass',
                            style: TextStyle(
                              color: Colors.white, // Text color
                              fontSize: 8, // Adjust font size
                              fontWeight: FontWeight.bold, // Bold text
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Sleep Schedule',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF8277FF),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Bedtime: ${widget.bedTime.format(context)}',
                    style: const TextStyle(fontSize: 10),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Phone usage will be monitored one hour before bedtime',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _phoneUsageTimer?.cancel();
    super.dispose();
  }
}