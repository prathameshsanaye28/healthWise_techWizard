import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:url_launcher/url_launcher.dart';

class AppColors {
  static const Color paleGreen = Color.fromRGBO(243, 253, 232, 1.0);  // F3FDE8
  static const Color lightGreen = Color.fromRGBO(156, 219, 166, 1.0);  // 9CDBA6
  static const Color mediumGreen = Color.fromRGBO(222, 249, 196, 0.81);  // DEF9C4
  static const Color darkGreen = Color.fromRGBO(156, 219, 166, 0.81);  // 4CAF50
  static const Color lightGray = Color.fromRGBO(159, 148, 148, 1.0);  // 9F9494
  static const Color mediumGray = Color.fromRGBO(95, 88, 88, 1.0);  // 7C6C6C
  static const Color darkGray = Color.fromRGBO(217, 217, 217, 1.0);  // D9D9D9
  static const Color lightPink = Color.fromRGBO(255, 177, 196, 1.0);  // FFB1C4
  static const Color veryLightPink = Color.fromRGBO(255, 246, 246, 1.0);  // FFF6F6
  static const Color lightRed = Color.fromRGBO(255, 221, 221, 1.0);  // FFDDDD
  
}
class CalmNowScreen extends StatefulWidget {
  @override
  _CalmNowScreenState createState() => _CalmNowScreenState();
}

class _CalmNowScreenState extends State<CalmNowScreen> {
  int _breathCount = 0;
  bool _isBreathing = false;
  Timer? _breathingTimer;
  Timer? _hapticTimer;

  final List<String> _affirmations = [
    "You are safe",
    "This moment will pass",
    "Take it one breath at a time",
  ];

  final Map<String, String> emergencyContacts = {
    'AASRA': '91-9820466726',
    'Vandrevala Foundation': '1860-2662-345',
  };

  @override
  void dispose() {
    _breathingTimer?.cancel();
    _hapticTimer?.cancel();
    super.dispose();
  }

  void _startBreathingExercise() {
    setState(() {
      _isBreathing = true;
      _breathCount = 0;
    });

    HapticFeedback.mediumImpact();
    _breathingTimer = Timer.periodic(Duration(seconds: 4), (timer) {
      setState(() {
        _breathCount++;
        if (_breathCount >= 12) {
          _isBreathing = false;
          timer.cancel();
          _hapticTimer?.cancel();
          HapticFeedback.heavyImpact();
        }
      });
    });

    _hapticTimer = Timer.periodic(Duration(milliseconds: 500), (timer) {
      if (_isBreathing) {
        if (_breathCount.isEven) {
          _breatheInHaptic();
        } else {
          _breatheOutHaptic();
        }
      } else {
        timer.cancel();
      }
    });
  }

  void _stopBreathingExercise() {
    setState(() {
      _isBreathing = false;
      _breathCount = 0;
    });
    _breathingTimer?.cancel();
    _hapticTimer?.cancel();
  }

  Future<void> _breatheInHaptic() async {
    await HapticFeedback.lightImpact();
  }

  Future<void> _breatheOutHaptic() async {
    await HapticFeedback.selectionClick();
  }


  Widget _buildBreathingCircle() {
    return AnimatedContainer(
      duration: Duration(seconds: 4),
      width: _breathCount.isEven ? 100.0 : 75.0,
      height: _breathCount.isEven ? 100.0 : 75.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.lightGreen.withOpacity(0.3),
        border: Border.all(color: AppColors.lightGreen, width: 2.0),
      ),
      child: Center(
        child: Text(
          _breathCount.isEven ? "Breathe In" : "Breathe Out",
          style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: AppColors.darkGreen),
        ),
      ),
    );
  }

  // Future<void> _makePhoneCall(String phoneNumber) async {
  //   final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
  //   await launchUrl(launchUri);
  // }

  Widget _buildEmergencyCall() {
    return Card(
      color: AppColors.paleGreen,
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Need immediate help?", style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold)),
            ...emergencyContacts.entries.map((contact) {
              return ElevatedButton.icon(
                icon: Icon(Icons.phone),
                label: Text("${contact.key}: ${contact.value}",
                  style: TextStyle(fontSize: 8),
                ),
                onPressed: () => {},
               // _makePhoneCall(contact.value),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:PreferredSize(
  preferredSize: Size.fromHeight(30.0), 

      child: 
        AppBar(
          title: Text("Calm Now",
                    style: TextStyle(fontSize: 12),), 
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, size: 12),
            onPressed: () {
              Navigator.pop(context);
            },),
          ),

      ),
      body: ListView(
        padding: EdgeInsets.all(12),
        children: [
          // Emergency Call Card
          _buildEmergencyCall(),

          // Breathing Exercise
          Card(
            color: AppColors.paleGreen,
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                children: [
                  Text("Breathing Exercise", style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  _isBreathing
                      ? Column(
                          children: [
                            _buildBreathingCircle(),
                            SizedBox(height: 8),
                            ElevatedButton.icon(
                              icon: Icon(Icons.stop),
                              label: Text("Stop"),
                              onPressed: _stopBreathingExercise,
                            ),
                          ],
                        )
                      : ElevatedButton.icon(
                          icon: Icon(Icons.air),
                          label: Text("Start"),
                          onPressed: _startBreathingExercise,
                        ),
                ],
              ),
            ),
          ),

          // Positive Affirmations
          Card(
            color: AppColors.paleGreen,
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                children: [
                  Text("Positive Affirmations", style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold)),
                  ..._affirmations.map((affirmation) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: Text(affirmation, style: TextStyle(fontSize: 7, color: AppColors.mediumGray)),
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
          
          // // Music Section
          // Card(
          //   color: AppColors.paleGreen,
          //   child: Padding(
          //     padding: EdgeInsets.all(8),
          //     child: ElevatedButton.icon(
          //       icon: Icon(Icons.music_note),
          //       label: Text("Go to Music Section", 
          //       style: TextStyle(fontSize: 8),
          //       ),
          //       onPressed: () {
          //         // Navigator.push(
          //         //   context,
          //         //   MaterialPageRoute(builder: (context) => MusicAppScreen()),
          //         // );
          //       },
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}