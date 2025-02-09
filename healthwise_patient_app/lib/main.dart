import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:healthwise_patient_app/aura/views/calm_now/calm_now_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'aura/components/consts.dart';
import 'aura/localization/locales.dart';
import 'aura/resources/user_provider.dart';
import 'aura/views/analysis_screens/analysis_screen.dart';
import 'aura/views/auth_screens/login.dart';
import 'firebase_options.dart';
import 'patient_base/navigator_screen.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initializeNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings(
          '@mipmap/ic_launcher'); // Update icon path if necessary

  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onDidReceiveNotificationResponse:
          onDidReceiveNotificationResponse); // Add the callback here

  if (Platform.isAndroid) {
    // Request notifications permission on Android using permission_handler
    final status = await Permission.notification.request();
    if (status.isGranted) {
      print("Notification permissions granted on Android.");
    } else {
      print("Notification permissions denied on Android.");
    }
  } else if (Platform.isIOS) {
    // Request notifications permission on iOS
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }
}

// Callback when notification is tapped
Future<void> onDidReceiveNotificationResponse(
    NotificationResponse notificationResponse) async {
  final String? payload = notificationResponse.payload;
  if (payload != null && payload == 'calmNowScreen') {
    // Navigate to CalmNowScreen when the notification is tapped
    Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(builder: (_) => CalmNowScreen()),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeNotifications(); // Request notification permission here
  Gemini.init(apiKey: gemini_api_key);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //addTherapistsData();
  await FlutterLocalization.instance
      .ensureInitialized(); // Ensure FlutterLocalization is initialized

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FlutterLocalization localization = FlutterLocalization.instance;

  @override
  void initState() {
    configureLocalization();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => AppUsageProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => TextAnalysisProvider(),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          fontFamily: 'Poppins',
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        supportedLocales: localization.supportedLocales,
        localizationsDelegates: localization.localizationsDelegates,
        home: user !=
                // null ? MainLayoutScreen() : const LoginScreen(),
                null
            ? const PatientAppNavigatorScreen()
            : const LoginScreen(),
        navigatorKey: navigatorKey, // Add the navigator key here
      ),
    );
  }

  void configureLocalization() {
    localization.init(mapLocales: LOCALES, initLanguageCode: 'en');
    localization.onTranslatedLanguage = onTranslatedLanguage;
  }

  void onTranslatedLanguage(Locale? locale) {
    setState(() {});
  }
}

// The navigator key to use for navigation inside onDidReceiveNotificationResponse
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
