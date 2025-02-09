import 'dart:math';
import 'package:flutter/material.dart';
import 'package:heathwise_watchos/games/color/zengarden_screen.dart';
import 'package:heathwise_watchos/lifestyle/lifetstyle_screen.dart';
import 'package:heathwise_watchos/lifestyle/steps_details_screen.dart';
import 'package:heathwise_watchos/watersleeptrack.dart';
import 'package:heathwise_watchos/weather.dart';
import 'package:wear_plus/wear_plus.dart';

import 'calm_now_trigger.dart';

class WatchHomeScreen extends StatefulWidget {
  @override
  _WatchHomeScreenState createState() => _WatchHomeScreenState();
}

class _WatchHomeScreenState extends State<WatchHomeScreen> {
  int heartRate = 75;
  int bloodPressureSystolic = 120;
  int bloodPressureDiastolic = 80;
  int spo2 = 98;
  int temperature = 37;

  @override
  void initState() {
    super.initState();
    _generateDummyData();
  }

  void _generateDummyData() {
    // Start generating dummy data periodically
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        heartRate = 60 + Random().nextInt(40);
        bloodPressureSystolic = 110 + Random().nextInt(20);
        bloodPressureDiastolic = 70 + Random().nextInt(15);
        spo2 = 95 + Random().nextInt(4);
        temperature = 36 + Random().nextInt(3);
      });
      _generateDummyData(); // Re-run the function to keep updating
    });
  }

  @override
  Widget build(BuildContext context) {
    return WatchShape(
      builder: (BuildContext context, WearShape shape, Widget? child) {
        return AmbientMode(
          builder: (context, mode, child) {
            return mode == WearMode.active
                ? ActiveWatchFace(
                    heartRate, bloodPressureSystolic, bloodPressureDiastolic, spo2, temperature)
                : AmbientWatchFace();
          },
        );
      },
    );
  }
}

class ActiveWatchFace extends StatelessWidget {
  final int heartRate;
  final int bloodPressureSystolic;
  final int bloodPressureDiastolic;
  final int spo2;
  final int temperature;
  
 

  ActiveWatchFace(
      this.heartRate, this.bloodPressureSystolic, this.bloodPressureDiastolic, this.spo2, this.temperature);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
     print(heartRate);
    return Scaffold(
      appBar: PreferredSize(
  preferredSize: Size.fromHeight(30.0), 
      child: AppBar(
        title: Text("Healthwise", style: TextStyle(fontSize: 12)),
        actions: [
          IconButton(
            onPressed: () {
              
            },
            icon: Icon(Icons.notifications, size: 12),
          ),
        ],
      ),),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildInfoTile("Heart Rate", "$heartRate bpm", size),
              _buildInfoTile("Blood Pressure", "$bloodPressureSystolic/$bloodPressureDiastolic", size),
              _buildInfoTile("Oxygen Saturation", "$spo2%", size),
              _buildInfoTile("Temperature", "$temperature°C", size),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CalmNowScreen()),
                  );
                },
                child: Text("Calm Now"),
              ),
              // SizedBox(height: 4),
              // ElevatedButton(
              //   onPressed: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(builder: (context) => StepsDetailsScreen()),
              //     );
              //   },
              //   child: Text("Lifestyle"),
              // ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ZenGardenScreen()),
                  );
                },
                child: Text("Relaxing Games"),
              ),
               ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LifestyleTrackingSection(weight: 55, age:45,bedTime:  TimeOfDay(hour: 15, minute: 0),  wakeUpTime: 6)),
                  );
                },
                child: Text("Water Intake"),
              ),
              //  ElevatedButton(
              //   onPressed: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(builder: (context) => WeatherPage(),
              //     ),);
              //   },
              //   child: Text("Weather Bot"),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile(String label, String value, Size size) {
    return Container(
      width: size.width * 0.8,
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: Colors.blueGrey[900],
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: TextStyle(color: Colors.white70, fontSize: 12),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AmbientWatchFace extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Ambient Mode",
          style: TextStyle(color: Colors.white70, fontSize: 14),
        ),
      ),
    );
  }
}
