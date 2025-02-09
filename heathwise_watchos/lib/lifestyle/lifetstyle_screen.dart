
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'steps_details_screen.dart';

final List<MapEntry<DateTime, int>> dailySteps = [
  MapEntry(DateTime(2024, 10, 11), 6000),
  MapEntry(DateTime(2024, 10, 12), 8000),
  MapEntry(DateTime(2024, 10, 13), 5000),
  MapEntry(DateTime(2024, 10, 14), 10000),
  MapEntry(DateTime(2024, 10, 15), 7234),
  MapEntry(DateTime(2024, 10, 16), 9000),
  MapEntry(DateTime(2024, 10, 17), 6500),
];

class LifestlyeScreen extends StatelessWidget {
  const LifestlyeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lifestyle Analysis"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 12,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: Container(
                height: media.width * 0.4,
                decoration: BoxDecoration(
                  color: const Color(0xFFEBECFF),
                  borderRadius: BorderRadius.circular(media.width * 0.065),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 100,
                        width: 100,
                        child: Image.asset('assets/images/CardCircle.png'),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 24.0, top: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Step Count',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF8277FF),
                              ),
                            ),
                            const Text(
                              'this counts your \n daily steps',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: SizedBox(
                                height: 35,
                                width: 100,
                                child: RoundButton(
                                  title: "Tap Here",
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const StepsDetailsScreen(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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

TimeOfDay _stringToTimeOfDay(String time) {
  final format = DateFormat("HH:mm"); // Adjusted for "HH:mm" format
  final dateTime = format.parse(time);
  return TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
}

enum RoundButtonType { primaryBG, secondaryBG }

class RoundButton extends StatelessWidget {
  final String title;
  final RoundButtonType type;
  final Function() onPressed;

  const RoundButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.type = RoundButtonType.secondaryBG,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF92A3FD), Color(0xFF8277FF)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 2, offset: Offset(0, 2))
        ],
      ),
      child: MaterialButton(
        minWidth: double.maxFinite,
        height: 50,
        onPressed: onPressed,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        textColor: Colors.black,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.white,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
