// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class MainTracker extends StatefulWidget {
//   final UserData? userData; // Make userData nullable

//   const MainTracker({super.key, this.userData});

//   @override
//   _MainTrackerState createState() => _MainTrackerState();
// }

// class _MainTrackerState extends State<MainTracker> {
//   int _glassesConsumed = 0;
//   Timer? _waterReminderTimer;
//   Timer? _screenTimeCheckTimer;
//   DateTime? _lastNotificationTime;
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   @override
//   void initState() {
//     super.initState();
//     _initializeNotifications();
//     setupWaterReminders();
//     setupScreenTimeMonitoring();
//   }

//   Future<void> _initializeNotifications() async {
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('@mipmap/ic_launcher');
//     const DarwinInitializationSettings initializationSettingsIOS =
//         DarwinInitializationSettings(
//       requestSoundPermission: false,
//       requestBadgePermission: false,
//       requestAlertPermission: false,
//     );
//     const InitializationSettings initializationSettings =
//         InitializationSettings(
//       android: initializationSettingsAndroid,
//       iOS: initializationSettingsIOS,
//     );
//     await flutterLocalNotificationsPlugin.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse: onNotificationTap,
//     );
//   }

//   void onNotificationTap(NotificationResponse response) {
//     if (response.payload == 'water') {
//       setState(() {
//         _glassesConsumed++;
//       });
//     }
//   }

//   void setupWaterReminders() {
//     _waterReminderTimer = Timer.periodic(
//       const Duration(hours: 2),
//       (timer) {
//         final now = TimeOfDay.now();
//         if (isWithinWakeHours(now)) {
//           showWaterReminder();
//         }
//       },
//     );
//   }

//   void setupScreenTimeMonitoring() {
//     _screenTimeCheckTimer = Timer.periodic(
//       const Duration(minutes: 1),
//       (timer) async {
//         final now = TimeOfDay.now();
//         if (isNearBedtime(now)) {
//           final isScreenActive = await checkScreenUsage();
//           if (isScreenActive && canShowNotification()) {
//             showScreenTimeWarning();
//             _lastNotificationTime = DateTime.now();
//           }
//         }
//       },
//     );
//   }

//   Future<void> showWaterReminder() async {
//     const AndroidNotificationDetails androidPlatformChannelSpecifics =
//         AndroidNotificationDetails(
//       'water_reminders',
//       'Water Reminders',
//       channelDescription: 'Reminds you to drink water regularly',
//       importance: Importance.max,
//       priority: Priority.high,
//       sound: RawResourceAndroidNotificationSound('notification_sound'),
//       enableVibration: true,
//     );

//     const NotificationDetails platformChannelSpecifics =
//         NotificationDetails(android: androidPlatformChannelSpecifics);

//     await flutterLocalNotificationsPlugin.show(
//       0,
//       'Time to hydrate!',
//       'Remember to drink a glass of water.',
//       platformChannelSpecifics,
//       payload: 'water',
//     );
//   }

//   Future<void> showScreenTimeWarning() async {
//     const AndroidNotificationDetails androidPlatformChannelSpecifics =
//         AndroidNotificationDetails(
//       'screen_time',
//       'Screen Time Warnings',
//       channelDescription: 'Warns about screen time before bed',
//       importance: Importance.max,
//       priority: Priority.high,
//       sound: RawResourceAndroidNotificationSound('notification_sound'),
//       enableVibration: true,
//     );

//     const NotificationDetails platformChannelSpecifics =
//         NotificationDetails(android: androidPlatformChannelSpecifics);

//     await flutterLocalNotificationsPlugin.show(
//       1,
//       'Bedtime approaching',
//       'Consider putting down your phone and preparing for sleep.',
//       platformChannelSpecifics,
//       payload: 'screen',
//     );
//   }

//   bool isWithinWakeHours(TimeOfDay now) {
//     // Provide default wake hours if userData is null
//     final wakeUpTime =
//         widget.userData?.wakeUpTime ?? TimeOfDay(hour: 8, minute: 0);
//     final bedtime = widget.userData?.bedtime ?? TimeOfDay(hour: 22, minute: 0);
//     return now.hour >= wakeUpTime.hour && now.hour < bedtime.hour;
//   }

//   bool isNearBedtime(TimeOfDay now) {
//     // Provide default bedtime if userData is null
//     final bedtime = widget.userData?.bedtime ?? TimeOfDay(hour: 22, minute: 0);
//     return now.hour == bedtime.hour && now.minute >= bedtime.minute - 30;
//   }

//   bool canShowNotification() {
//     if (_lastNotificationTime == null) return true;
//     return DateTime.now().difference(_lastNotificationTime!).inMinutes >= 15;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Health Tracker'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'Water Consumed: $_glassesConsumed glasses',
//               style: TextStyle(fontSize: 20),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 setState(() {
//                   _glassesConsumed++;
//                 });
//               },
//               child: Text('Add a Glass of Water'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _waterReminderTimer?.cancel();
//     _screenTimeCheckTimer?.cancel();
//     super.dispose();
//   }
// }

// class UserData {
//   final String name;
//   final int dailyWaterGoal;
//   final TimeOfDay wakeUpTime;
//   final TimeOfDay bedtime;

//   UserData({
//     required this.name,
//     required this.dailyWaterGoal,
//     required this.wakeUpTime,
//     required this.bedtime,
//   });
// }

// const MethodChannel platform =
//     MethodChannel('com.example.aura_techwizard/channel');

// Future<bool> checkScreenUsage() async {
//   try {
//     final bool isActive = await platform.invokeMethod('isScreenActive');
//     return isActive;
//   } on PlatformException {
//     return false;
//   }
// }
