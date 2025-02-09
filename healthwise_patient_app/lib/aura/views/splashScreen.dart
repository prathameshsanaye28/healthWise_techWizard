import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen>
    with SingleTickerProviderStateMixin {
  final double _logoOpacity = 0.0;
  final double _animationOpacity = 0.0;
  final auth = FirebaseAuth.instance;

  // @override
  // void initState() {
  //   super.initState();
  //   _playSplashSequence();
  // }

  // void _playSplashSequence() {
  //   // Step 1: Fade in Lottie animation in the first 2 seconds
  //   Future.delayed(const Duration(milliseconds: 100), () {
  //     setState(() {
  //       _animationOpacity = 1.0;
  //     });
  //   });

  //   // Step 2: Fade in and out logo after 2 seconds
  //   Future.delayed(const Duration(seconds: 3), () {
  //     setState(() {
  //       _logoOpacity = 1.0;
  //     });

  //     Future.delayed(const Duration(seconds: 5), () {
  //       setState(() {
  //         _logoOpacity = 0.0;
  //       });
  //     });
  //   });

  //   // Step 3: Navigate to the next page after 4 seconds
  //   Future.delayed(const Duration(seconds: 4), () {
  //     // if (auth.currentUser == null) {
  //     //   Get.offAll(() => LoginScreen());
  //     // } else {
  //     //   Get.offAll(() => MainLayoutScreen());
  //     // }
  //     Get.offAll(()=>MainLayoutScreen());
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SplashScreen'),
      ),
      body: const Center(),
    );
  }
}
