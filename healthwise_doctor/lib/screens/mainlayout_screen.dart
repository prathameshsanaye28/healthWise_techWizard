import 'package:flutter/material.dart';
import 'package:healthwise/screens/job_matching.dart';
import 'package:healthwise/screens/networking_screen.dart';
import 'package:healthwise/screens/posts_screen/feed_screen.dart';
import 'package:healthwise/screens/projects/projects_screen.dart';
import 'package:healthwise/screens/user_profile.dart';

import 'package:provider/provider.dart';


class MainLayoutScreen extends StatefulWidget {
  @override
  _MainLayoutScreenState createState() => _MainLayoutScreenState();
}

class _MainLayoutScreenState extends State<MainLayoutScreen> {
  int _selectedIndex = 0;

  // List of pages for each BottomNavigationBar item
  final List<Widget> _pages = [
    FeedScreen(),
    NetworkingScreen(),
    JobMatchingScreen(),
    ViewProjectsScreen(),
    UserProfileScreen(userId: "lUoJzE4iXrVAvJudsCHwUwVjfPB2",),
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
      body: _pages[_selectedIndex], // Display the current page
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
            label: 'Network',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medical_services_outlined),
            label: 'Jobs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Projects',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
