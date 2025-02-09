import 'package:flutter/material.dart';
import 'package:healthwise/models/doctor.dart';
import 'package:healthwise/resources/user_provider.dart';
import 'package:healthwise/screens/api_marketplace.dart';
import 'package:healthwise/screens/chat_screen.dart/search_screen.dart';
import 'package:healthwise/screens/course_screen/course_list.dart';
import 'package:healthwise/screens/heart_disease_prediction.dart';
import 'package:healthwise/screens/payment_screen.dart';
import 'package:healthwise/screens/posts_screen/feed_screen.dart';
import 'package:healthwise/screens/prescription_form_screen.dart';
import 'package:healthwise/screens/stock_trading.dart';
import 'package:healthwise/screens/tax_calculator.dart';
import 'package:healthwise/screens/viewPatients.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  final String currentRoute;

  const AppDrawer({super.key, required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    final Doctor? user = Provider.of<UserProvider>(context).getUser;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(gradient: LinearGradient(
                              
                            colors: [
        Color.fromRGBO(174, 175, 247, 1), // Soft pink
       // Color.fromRGBO(253, 221, 236, 1), // Light peach
        Color(0xFFC5DEE3), // Pale blue
      ],)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("HealthWise", style: TextStyle(fontSize: 50, color: Colors.black,fontWeight: FontWeight.bold),textAlign: TextAlign.start,),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildDrawerItem(context, 'Home', Icons.home, FeedScreen(), '/home'),
          ),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: _buildDrawerItem(context, 'News', Icons.newspaper, NewsScreen(), '/news'),
          // ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildDrawerItem(context, 'Medical Equipments', Icons.shopping_bag, MarketplaceScreen(), '/marketplace'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildDrawerItem(context, 'View Patient Passport', Icons.perm_identity, PatientListWidget(), '/marketplace'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildDrawerItem(context, 'Heart Disease Detection', Icons.heart_broken, HeartRiskInputScreen(), '/marketplace'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildDrawerItem(context, 'Prescription', Icons.receipt_long, PrescriptionFormScreen(doctorId: 'lUoJzE4iXrVAvJudsCHwUwVjfPB2',patientId: 'UrE9uj9csBeqPeMF2UwWEjzTMBJ2'), '/marketplace'),
          ),
           Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildDrawerItem(context, 'Video Call', Icons.video_call, PrescriptionFormScreen(doctorId: 'lUoJzE4iXrVAvJudsCHwUwVjfPB2',patientId: 'UrE9uj9csBeqPeMF2UwWEjzTMBJ2'), '/marketplace'),
          ),

          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: _buildDrawerItem(context, 'Protocol Library', Icons.library_books, APIMarket(), '/protocol'),
          // ),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: _buildDrawerItem(context, '', Icons.auto_graph, FeedScreen(), '/combined_analysis'),
          // ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildDrawerItem(context, 'Courses', Icons.book, CourseListScreen(), '/courses'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildDrawerItem(context, 'Chat', Icons.message, SearchScreen(), '/chat'),
          ),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: _buildFeaturesItem(context),
          // ),
        ],
      ),
    );
  }

 ListTile _buildDrawerItem(BuildContext context, String title, IconData icon, Widget destination, String route) {
  return ListTile(
    title: Text(title),
    leading: Icon(icon),
    selected: currentRoute == route,
    selectedTileColor: Color.fromRGBO(253, 221, 236, 1),
    onTap: () {
      if (currentRoute != route) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => destination));
      } else {
        Navigator.pop(context);
      }
    },
  );
}
Widget _buildFeaturesItem(BuildContext context) {
    return ExpansionTile(
      title: Text('Simulator'),
      leading: Icon(Icons.star,color: Colors.black,),
      children: [
        _buildDrawerItem(context, 'Payment Simulator',Icons.receipt,PaymentSimulator(),'/payment'),
        _buildDrawerItem(context, 'Stock Trading Demo', Icons.auto_graph, StockTradingDemo(),'/stock'),
        _buildDrawerItem(context, 'Tax Calculator', Icons.money, TaxCalculator(),'/tax'),
      ],
    );
  }
 }
