//import 'package:shared_preferences.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LifestyleTrackingSection extends StatefulWidget {
  final double weight;
  final int age;
  final TimeOfDay bedTime;

  const LifestyleTrackingSection({
    super.key,
    required this.weight,
    required this.age,
    required this.bedTime,
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
    _setupSleepTracking();
    _loadWaterIntakeCount();
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
    // Basic water intake calculation based on weight and age
    double baseIntake = widget.weight * 0.033; // 33ml per kg of body weight

    // Adjust based on age
    if (widget.age > 65) {
      baseIntake *= 0.9; // Slightly lower for elderly
    } else if (widget.age < 18) {
      baseIntake *= 1.1; // Slightly higher for younger people
    }

    return baseIntake; // Returns liters
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

  Future<void> _setupSleepTracking() async {
    // Start monitoring phone usage one hour before bedtime
    final now = TimeOfDay.now();
    final bedTimeHour = widget.bedTime.hour;
    final bedTimeMinute = widget.bedTime.minute;

    // Calculate time until one hour before bedtime
    final currentMinutes = now.hour * 60 + now.minute;
    final bedTimeMinutes = bedTimeHour * 60 + bedTimeMinute;
    final minutesUntilBedtime = bedTimeMinutes - currentMinutes - 60;

    if (minutesUntilBedtime > 0) {
      Future.delayed(Duration(minutes: minutesUntilBedtime), () {
        _startPhoneUsageTracking();
      });
    }
  }

  void _startPhoneUsageTracking() {
    _phoneUsageTimer = Timer.periodic(const Duration(minutes: 5), (timer) {
      // Check if screen is on/app is in foreground
      // This is a simplified version - in a real app you'd use device_info or similar
      if (WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed) {
        isPhoneInUse = true;
        _showSleepWarning();
      }
    });
  }

  Future<void> _showSleepWarning() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'sleep_reminder',
      'Sleep Reminders',
      channelDescription: 'Reminders for better sleep habits',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      1,
      'Better Sleep Habits',
      'Try to avoid phone use before bedtime for better sleep quality',
      platformChannelSpecifics,
    );
  }

  Future<void> _loadWaterIntakeCount() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      waterIntakeCount = prefs.getInt('water_intake_count') ?? 0;
    });
  }

  Future<void> _incrementWaterIntake() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      waterIntakeCount++;
    });
    await prefs.setInt('water_intake_count', waterIntakeCount);
  }

  @override
  Widget build(BuildContext context) {
    final dailyWaterTarget = calculateDailyWaterIntake();
    final glassesRecommended =
        (dailyWaterTarget * 1000 / 250).round(); // Assuming 250ml per glass

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Water Intake Section
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: const Color(0xFFEBECFF),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Daily Water Intake',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF8277FF),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Recommended: ${dailyWaterTarget.toStringAsFixed(1)} L ($glassesRecommended glasses)',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Current: $waterIntakeCount glasses',
                      style: const TextStyle(fontSize: 16),
                    ),
                    ElevatedButton(
                      onPressed: _incrementWaterIntake,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8277FF),
                      ),
                      child: const Text('+ Add Glass',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Sleep Tracking Section
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
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
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF8277FF),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Bedtime: ${widget.bedTime.format(context)}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Phone usage will be monitored one hour before bedtime',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _phoneUsageTimer?.cancel();
    super.dispose();
  }
}
