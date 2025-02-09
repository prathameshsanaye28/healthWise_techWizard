import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/user.dart';
import '../../resources/user_provider.dart';
import 'sleep_water_tracking.dart';
import 'steps_details_sceen.dart';

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
    final Patient? user = Provider.of<UserProvider>(context).getUser;
    var media = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lifestyle Analysis"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 12,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                height: media.width * 0.5,
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 3)
                  ],
                ),
                child: MyBarGraph(
                  dailySteps: dailySteps,
                ),
              ),
            ),
            LifestyleTrackingSection(
              weight: user!.weight, // Pass from user data
              age: user.age, // Pass from user data
              //bedTime: user!.bedTime, // Pass from user data
              bedTime: _stringToTimeOfDay(user.bedTime),
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
        gradient: const LinearGradient(
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

class MyBarGraph extends StatelessWidget {
  final List<MapEntry<DateTime, int>> dailySteps;

  const MyBarGraph({super.key, required this.dailySteps});

  @override
  Widget build(BuildContext context) {
    BarData myBarData = BarData(dailySteps: dailySteps);
    myBarData.initializeBarData();

    return BarChart(
      BarChartData(
        maxY: 20000,
        minY: 0,
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        barGroups: myBarData.barData.map((data) {
          return BarChartGroupData(
            x: myBarData.barData.indexOf(data),
            barRods: [
              BarChartRodData(
                toY: data.y.toDouble(),
                color: const Color(0xFF6976EB),
                width: 18,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          );
        }).toList(),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                int index = value.toInt();
                if (index >= 0 && index < myBarData.barData.length) {
                  String formattedDate =
                      DateFormat('dd').format(myBarData.barData[index].x);
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      formattedDate,
                      style: const TextStyle(color: Colors.black, fontSize: 10),
                    ),
                  );
                }
                return Container();
              },
              reservedSize: 38,
            ),
          ),
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
      ),
    );
  }
}

class BarData {
  final List<MapEntry<DateTime, int>> dailySteps;

  BarData({required this.dailySteps});

  List<Individual_Bar> barData = [];

  void initializeBarData() {
    barData = dailySteps.map((entry) {
      return Individual_Bar(x: entry.key, y: entry.value);
    }).toList();
  }
}

class Individual_Bar {
  final DateTime x;
  final int y;

  Individual_Bar({required this.x, required this.y});
}

// // import 'package:aura_techwizard/views/lifestyle/sleep_water_tracking.dart';
// // import 'package:aura_techwizard/views/lifestyle/steps_details_sceen.dart';
// // import 'package:aura_techwizard/views/lifestyle/onboarding_screen.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:fl_chart/fl_chart.dart';
// // import 'package:flutter/material.dart';
// // import 'package:intl/intl.dart';

// // final List<MapEntry<DateTime, int>> dailySteps = [
// //   MapEntry(DateTime(2024, 10, 11), 6000),
// //   MapEntry(DateTime(2024, 10, 12), 8000),
// //   MapEntry(DateTime(2024, 10, 13), 5000),
// //   MapEntry(DateTime(2024, 10, 14), 10000),
// //   MapEntry(DateTime(2024, 10, 15), 7234),
// //   MapEntry(DateTime(2024, 10, 16), 9000),
// //   MapEntry(DateTime(2024, 10, 17), 6500),
// // ];

// // class LifestlyeScreen extends StatelessWidget {
// //   const LifestlyeScreen({super.key});

// //   Future<Map<String, dynamic>?> _getUserData() async {
// //     final user = FirebaseAuth.instance.currentUser;
// //     if (user != null) {
// //       final doc = await FirebaseFirestore.instance
// //           .collection('patients')
// //           .doc(user.uid)
// //           .get();
// //       return doc.data();
// //     }
// //     return null;
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     var media = MediaQuery.of(context).size;
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text("Lifestyle Analysis"),
// //         actions: [
// //           IconButton(
// //             icon: const Icon(Icons.edit),
// //             onPressed: () async {
// //               final userData = await _getUserData();
// //               Navigator.push(
// //                 context,
// //                 MaterialPageRoute(
// //                   builder: (context) => OnboardingScreen(
// //                     isEditing: true,
// //                     userData: userData,
// //                   ),
// //                 ),
// //               );
// //             },
// //           ),
// //         ],
// //       ),
// //       body: FutureBuilder<Map<String, dynamic>?>(
// //         future: _getUserData(),
// //         builder: (context, snapshot) {
// //           if (snapshot.connectionState == ConnectionState.waiting) {
// //             return const Center(child: CircularProgressIndicator());
// //           }

// //           final userData = snapshot.data;
// //           return Column(
// //             children: [
// //               if (userData != null) ...[
// //                 Padding(
// //                   padding: const EdgeInsets.all(16.0),
// //                   child: Card(
// //                     child: Padding(
// //                       padding: const EdgeInsets.all(16.0),
// //                       child: Column(
// //                         crossAxisAlignment: CrossAxisAlignment.start,
// //                         children: [
// //                           Text(
// //                             'Welcome, ${userData['name']}!',
// //                             style: Theme.of(context).textTheme.titleLarge,
// //                           ),
// //                           SizedBox(height: 8),
// //                           Text('Age: ${userData['age']} years'),
// //                           Text('Weight: ${userData['weight']} kg'),
// //                           Text('Height: ${userData['height']} cm'),
// //                         ],
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //               Padding(
// //                 padding: const EdgeInsets.only(top: 24.0),
// //                 child: Container(
// //                   height: media.width * 0.4,
// //                   decoration: BoxDecoration(
// //                     color: const Color(0xFFEBECFF),
// //                     borderRadius: BorderRadius.circular(media.width * 0.065),
// //                   ),
// //                   child: Padding(
// //                     padding: const EdgeInsets.all(8.0),
// //                     child: Row(
// //                       mainAxisAlignment: MainAxisAlignment.start,
// //                       children: [
// //                         SizedBox(
// //                           height: 100,
// //                           width: 100,
// //                           child: Image.asset('assets/images/CardCircle.png'),
// //                         ),
// //                         Padding(
// //                           padding: const EdgeInsets.only(left: 24.0, top: 8.0),
// //                           child: Column(
// //                             crossAxisAlignment: CrossAxisAlignment.start,
// //                             children: [
// //                               const Text(
// //                                 'Step Count',
// //                                 style: TextStyle(
// //                                   fontSize: 24,
// //                                   fontWeight: FontWeight.bold,
// //                                   color: Color(0xFF8277FF),
// //                                 ),
// //                               ),
// //                               const Text(
// //                                 'this counts your \n daily steps',
// //                                 style: TextStyle(
// //                                   fontSize: 12,
// //                                   fontWeight: FontWeight.w500,
// //                                 ),
// //                               ),
// //                               Padding(
// //                                 padding: const EdgeInsets.only(top: 8.0),
// //                                 child: SizedBox(
// //                                   height: 35,
// //                                   width: 100,
// //                                   child: RoundButton(
// //                                     title: "Tap Here",
// //                                     onPressed: () {
// //                                       Navigator.push(
// //                                         context,
// //                                         MaterialPageRoute(
// //                                           builder: (context) =>
// //                                               const StepsDetailsScreen(),
// //                                         ),
// //                                       );
// //                                     },
// //                                   ),
// //                                 ),
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //               Padding(
// //                 padding: const EdgeInsets.only(top: 20.0),
// //                 child: Container(
// //                   height: media.width * 0.5,
// //                   padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 0),
// //                   decoration: BoxDecoration(
// //                     color: Colors.white,
// //                     borderRadius: BorderRadius.circular(15),
// //                     boxShadow: const [
// //                       BoxShadow(color: Colors.black12, blurRadius: 3)
// //                     ],
// //                   ),
// //                   child: MyBarGraph(
// //                     dailySteps: dailySteps,
// //                   ),
// //                 ),
// //               ),
// //             LifestyleTrackingSection(
// //             weight: userData!.weight, // Pass from user data
// //             age: userData.age, // Pass from user data
// //             bedTime: userData.bedTime, // Pass from user data
// //           ),
// //             ],
// //           );
// //         },
// //       ),
// //     );
// //   }
// // }
// // enum RoundButtonType { primaryBG, secondaryBG }

// // class RoundButton extends StatelessWidget {
// //   final String title;
// //   final RoundButtonType type;
// //   final Function() onPressed;

// //   const RoundButton({
// //     super.key,
// //     required this.title,
// //     required this.onPressed,
// //     this.type = RoundButtonType.secondaryBG,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       decoration: BoxDecoration(
// //         gradient: LinearGradient(
// //           colors: [Color(0xFF92A3FD), Color(0xFF8277FF)],
// //           begin: Alignment.centerLeft,
// //           end: Alignment.centerRight,
// //         ),
// //         borderRadius: BorderRadius.circular(25),
// //         boxShadow: const [
// //           BoxShadow(color: Colors.black26, blurRadius: 2, offset: Offset(0, 2))
// //         ],
// //       ),
// //       child: MaterialButton(
// //         minWidth: double.maxFinite,
// //         height: 50,
// //         onPressed: onPressed,
// //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
// //         textColor: Colors.black,
// //         child: Text(
// //           title,
// //           style: const TextStyle(
// //             fontSize: 11,
// //             color: Colors.white,
// //             fontWeight: FontWeight.w400,
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// // class MyBarGraph extends StatelessWidget {
// //   final List<MapEntry<DateTime, int>> dailySteps;

// //   const MyBarGraph({super.key, required this.dailySteps});

// //   @override
// //   Widget build(BuildContext context) {
// //     BarData myBarData = BarData(dailySteps: dailySteps);
// //     myBarData.initializeBarData();

// //     return BarChart(
// //       BarChartData(
// //         maxY: 20000,
// //         minY: 0,
// //         gridData: const FlGridData(show: false),
// //         borderData: FlBorderData(show: false),
// //         barGroups: myBarData.barData.map((data) {
// //           return BarChartGroupData(
// //             x: myBarData.barData.indexOf(data),
// //             barRods: [
// //               BarChartRodData(
// //                 toY: data.y.toDouble(),
// //                 color: const Color(0xFF6976EB),
// //                 width: 18,
// //                 borderRadius: BorderRadius.circular(4),
// //               ),
// //             ],
// //           );
// //         }).toList(),
// //         titlesData: FlTitlesData(
// //           bottomTitles: AxisTitles(
// //             sideTitles: SideTitles(
// //               showTitles: true,
// //               getTitlesWidget: (value, meta) {
// //                 int index = value.toInt();
// //                 if (index >= 0 && index < myBarData.barData.length) {
// //                   String formattedDate =
// //                       DateFormat('dd').format(myBarData.barData[index].x);
// //                   return Padding(
// //                     padding: const EdgeInsets.only(top: 8.0),
// //                     child: Text(
// //                       formattedDate,
// //                       style: const TextStyle(color: Colors.black, fontSize: 10),
// //                     ),
// //                   );
// //                 }
// //                 return Container();
// //               },
// //               reservedSize: 38,
// //             ),
// //           ),
// //           leftTitles: const AxisTitles(
// //             sideTitles: SideTitles(showTitles: false),
// //           ),
// //           rightTitles: const AxisTitles(
// //             sideTitles: SideTitles(showTitles: false),
// //           ),
// //           topTitles: const AxisTitles(
// //             sideTitles: SideTitles(showTitles: false),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// // class BarData {
// //   final List<MapEntry<DateTime, int>> dailySteps;

// //   BarData({required this.dailySteps});

// //   List<Individual_Bar> barData = [];

// //   void initializeBarData() {
// //     barData = dailySteps.map((entry) {
// //       return Individual_Bar(x: entry.key, y: entry.value);
// //     }).toList();
// //   }
// // }

// // class Individual_Bar {
// //   final DateTime x;
// //   final int y;

// //   Individual_Bar({required this.x, required this.y});
// // }
// // // Rest of the code (RoundButton, MyBarGraph, BarData, Individual_Bar) remains unchanged



// import 'package:aura_techwizard/views/lifestyle/steps_details_sceen.dart';
// import 'package:aura_techwizard/views/lifestyle/onboarding_screen.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// final List<MapEntry<DateTime, int>> dailySteps = [
//   MapEntry(DateTime(2024, 10, 11), 6000),
//   MapEntry(DateTime(2024, 10, 12), 8000),
//   MapEntry(DateTime(2024, 10, 13), 5000),
//   MapEntry(DateTime(2024, 10, 14), 10000),
//   MapEntry(DateTime(2024, 10, 15), 7234),
//   MapEntry(DateTime(2024, 10, 16), 9000),
//   MapEntry(DateTime(2024, 10, 17), 6500),
// ];

// class LifestyleTrackingSection extends StatelessWidget {
//   final double weight;
//   final int age;
//   final Map<String, int> bedTime;

//   const LifestyleTrackingSection({
//     Key? key,
//     required this.weight,
//     required this.age,
//     required this.bedTime,
//   }) : super(key: key);

//   String _formatTime(Map<String, int> time) {
//     final hour = time['hour'] ?? 0;
//     final minute = time['minute'] ?? 0;
//     return TimeOfDay(hour: hour, minute: minute).format(GlobalKey<NavigatorState>().currentContext ?? GlobalContext.context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(15),
//         boxShadow: const [
//           BoxShadow(color: Colors.black12, blurRadius: 3)
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Lifestyle Tracking',
//             style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                   color: const Color(0xFF8277FF),
//                   fontWeight: FontWeight.bold,
//                 ),
//           ),
//           const SizedBox(height: 16),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               _buildMetricCard(
//                 context,
//                 'Weight',
//                 '$weight kg',
//                 Icons.monitor_weight_outlined,
//               ),
//               _buildMetricCard(
//                 context,
//                 'Age',
//                 '$age years',
//                 Icons.calendar_today,
//               ),
//               _buildMetricCard(
//                 context,
//                 'Bedtime',
//                 _formatTime(bedTime),
//                 Icons.bedtime_outlined,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildMetricCard(
//     BuildContext context,
//     String label,
//     String value,
//     IconData icon,
//   ) {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: const Color(0xFFEBECFF),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         children: [
//           Icon(icon, color: const Color(0xFF8277FF)),
//           const SizedBox(height: 8),
//           Text(
//             label,
//             style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                   color: Colors.grey[600],
//                 ),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             value,
//             style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                   fontWeight: FontWeight.bold,
//                 ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class GlobalContext {
//   static final GlobalKey<NavigatorState> _key = GlobalKey<NavigatorState>();
//   static BuildContext get context => _key.currentContext!;

//   static GlobalKey<NavigatorState> get key => _key;
// }

// class LifestlyeScreen extends StatelessWidget {
//   const LifestlyeScreen({super.key});

//   Future<Map<String, dynamic>?> _getUserData() async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       final doc = await FirebaseFirestore.instance
//           .collection('patients')
//           .doc(user.uid)
//           .get();
//       return doc.data();
//     }
//     return null;
//   }

//   @override
//   Widget build(BuildContext context) {
//     var media = MediaQuery.of(context).size;
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Lifestyle Analysis"),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.edit),
//             onPressed: () async {
//               final userData = await _getUserData();
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => OnboardingScreen(
//                     isEditing: true,
//                     userData: userData,
//                   ),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//       body: FutureBuilder<Map<String, dynamic>?>(
//         future: _getUserData(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (!snapshot.hasData || snapshot.data == null) {
//             return const Center(child: Text('No user data found'));
//           }

//           final userData = snapshot.data!;
          
//           return SingleChildScrollView(
//             child: Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Card(
//                     child: Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Welcome, ${userData['name']}!',
//                             style: Theme.of(context).textTheme.titleLarge,
//                           ),
//                           SizedBox(height: 8),
//                           Text('Age: ${userData['age']} years'),
//                           Text('Weight: ${userData['weight']} kg'),
//                           Text('Height: ${userData['height']} cm'),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(top: 24.0),
//                   child: Container(
//                     height: media.width * 0.4,
//                     decoration: BoxDecoration(
//                       color: const Color(0xFFEBECFF),
//                       borderRadius: BorderRadius.circular(media.width * 0.065),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           SizedBox(
//                             height: 100,
//                             width: 100,
//                             child: Image.asset('assets/images/CardCircle.png'),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(left: 24.0, top: 8.0),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 const Text(
//                                   'Step Count',
//                                   style: TextStyle(
//                                     fontSize: 24,
//                                     fontWeight: FontWeight.bold,
//                                     color: Color(0xFF8277FF),
//                                   ),
//                                 ),
//                                 const Text(
//                                   'this counts your \n daily steps',
//                                   style: TextStyle(
//                                     fontSize: 12,
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.only(top: 8.0),
//                                   child: SizedBox(
//                                     height: 35,
//                                     width: 100,
//                                     child: RoundButton(
//                                       title: "Tap Here",
//                                       onPressed: () {
//                                         Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                             builder: (context) =>
//                                                 const StepsDetailsScreen(),
//                                           ),
//                                         );
//                                       },
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(top: 20.0),
//                   child: Container(
//                     height: media.width * 0.5,
//                     padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 0),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(15),
//                       boxShadow: const [
//                         BoxShadow(color: Colors.black12, blurRadius: 3)
//                       ],
//                     ),
//                     child: MyBarGraph(
//                       dailySteps: dailySteps,
//                     ),
//                   ),
//                 ),
//                 LifestyleTrackingSection(
//                   weight: (userData['weight'] as num).toDouble(),
//                   age: (userData['age'] as num).toInt(),
//                   bedTime: Map<String, int>.from(userData['bedTime'] as Map),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
// enum RoundButtonType { primaryBG, secondaryBG }

// class RoundButton extends StatelessWidget {
//   final String title;
//   final RoundButtonType type;
//   final Function() onPressed;

//   const RoundButton({
//     super.key,
//     required this.title,
//     required this.onPressed,
//     this.type = RoundButtonType.secondaryBG,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [Color(0xFF92A3FD), Color(0xFF8277FF)],
//           begin: Alignment.centerLeft,
//           end: Alignment.centerRight,
//         ),
//         borderRadius: BorderRadius.circular(25),
//         boxShadow: const [
//           BoxShadow(color: Colors.black26, blurRadius: 2, offset: Offset(0, 2))
//         ],
//       ),
//       child: MaterialButton(
//         minWidth: double.maxFinite,
//         height: 50,
//         onPressed: onPressed,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
//         textColor: Colors.black,
//         child: Text(
//           title,
//           style: const TextStyle(
//             fontSize: 11,
//             color: Colors.white,
//             fontWeight: FontWeight.w400,
//           ),
//         ),
//       ),
//     );
//   }
// }

// class MyBarGraph extends StatelessWidget {
//   final List<MapEntry<DateTime, int>> dailySteps;

//   const MyBarGraph({super.key, required this.dailySteps});

//   @override
//   Widget build(BuildContext context) {
//     BarData myBarData = BarData(dailySteps: dailySteps);
//     myBarData.initializeBarData();

//     return BarChart(
//       BarChartData(
//         maxY: 20000,
//         minY: 0,
//         gridData: const FlGridData(show: false),
//         borderData: FlBorderData(show: false),
//         barGroups: myBarData.barData.map((data) {
//           return BarChartGroupData(
//             x: myBarData.barData.indexOf(data),
//             barRods: [
//               BarChartRodData(
//                 toY: data.y.toDouble(),
//                 color: const Color(0xFF6976EB),
//                 width: 18,
//                 borderRadius: BorderRadius.circular(4),
//               ),
//             ],
//           );
//         }).toList(),
//         titlesData: FlTitlesData(
//           bottomTitles: AxisTitles(
//             sideTitles: SideTitles(
//               showTitles: true,
//               getTitlesWidget: (value, meta) {
//                 int index = value.toInt();
//                 if (index >= 0 && index < myBarData.barData.length) {
//                   String formattedDate =
//                       DateFormat('dd').format(myBarData.barData[index].x);
//                   return Padding(
//                     padding: const EdgeInsets.only(top: 8.0),
//                     child: Text(
//                       formattedDate,
//                       style: const TextStyle(color: Colors.black, fontSize: 10),
//                     ),
//                   );
//                 }
//                 return Container();
//               },
//               reservedSize: 38,
//             ),
//           ),
//           leftTitles: const AxisTitles(
//             sideTitles: SideTitles(showTitles: false),
//           ),
//           rightTitles: const AxisTitles(
//             sideTitles: SideTitles(showTitles: false),
//           ),
//           topTitles: const AxisTitles(
//             sideTitles: SideTitles(showTitles: false),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class BarData {
//   final List<MapEntry<DateTime, int>> dailySteps;

//   BarData({required this.dailySteps});

//   List<Individual_Bar> barData = [];

//   void initializeBarData() {
//     barData = dailySteps.map((entry) {
//       return Individual_Bar(x: entry.key, y: entry.value);
//     }).toList();
//   }
// }

// class Individual_Bar {
//   final DateTime x;
//   final int y;

//   Individual_Bar({required this.x, required this.y});
// }

