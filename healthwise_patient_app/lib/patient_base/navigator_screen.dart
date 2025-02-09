import 'package:flutter/material.dart';
import 'package:healthwise_patient_app/aura/views/HomeScreen/HomeScreen.dart';
import 'package:healthwise_patient_app/aura/views/community_screen/feed_screen.dart';
import 'package:healthwise_patient_app/patient_base/views/patient_home/patient_home_screen.dart';

import 'views/chatbot/chatbot_screen.dart';

class PatientAppNavigatorScreen extends StatefulWidget {
  const PatientAppNavigatorScreen({super.key});

  @override
  State<PatientAppNavigatorScreen> createState() =>
      _PatientAppNavigatorScreenState();
}

class _PatientAppNavigatorScreenState extends State<PatientAppNavigatorScreen> {
  int _selectedIndex = 0;

  // List of pages for each BottomNavigationBar item
  final List<Widget> _pages = [
    const PatientHomeScreen(),
    const FeedScreen(),
    ChatBotScreen(),
    const HomeScreen(), //Aura
  ];

  // Function to handle item selection
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color.fromRGBO(55, 27, 52, 1),
        unselectedItemColor: const Color.fromRGBO(205, 208, 227, 1),
        currentIndex: _selectedIndex, // Current selected index
        onTap: _onItemTapped, // Update index on item tap
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Community',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'ChatBot',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage("assets/icons/aura_icon.png")),
            label: 'Aura',
          ),
        ],
      ),
    );
  }
}
