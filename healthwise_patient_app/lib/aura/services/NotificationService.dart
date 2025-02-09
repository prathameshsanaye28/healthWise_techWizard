import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../main.dart';
 // Import the navigatorKey and main.dart to access the navigator

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      flutterLocalNotificationsPlugin; // Use the instance from main.dart

  static Future<void> showStressNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'stress_channel', // channel id
      'Stress Notifications', // channel name
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _notifications.show(
      0, // notification id
      'Stress Detection', // notification title
      'We noticed signs of stress in your interaction patterns. Would you like to take a break?', // notification body
      platformChannelSpecifics,
      payload: 'calmNowScreen', // Payload to identify the screen to navigate to
    );
  }

  static Future<void> showAppUsageNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'usage_channel', // channel id
      'Usage Notifications', // channel name
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _notifications.show(
      1, // different notification id
      'App Usage Pattern', // notification title
      'You seem to be switching apps frequently. Need help focusing?', // notification body
      platformChannelSpecifics,
      payload: 'calmNowScreen', // Payload to identify the screen to navigate to
    );
  }
}
