
import 'package:flutter/material.dart';

import '../../pattern_game_screen.dart';
import '../../zen_garden/screens/zen_garden_screen.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF6F6F6),
        elevation: 0,
        title: const Text(
          'Relaxing games',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          const Text(
            'Be Calm....',
            style: TextStyle(
              color: Colors.black54,
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const ZenGardenScreen()));
            },
            child: GameCard(
              title: 'Color The Picture',
              image: 'assets/images/turtle.png',
              onTap: () {
                // Navigate to coloring game
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const ZenGardenScreen()));
              },
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const PatternGameScreen()));
            },
            child: GameCard(
              title: 'Match The Pattern',
              image: 'assets/images/pattern.png',
              onTap: () {
                // Navigate to pattern matching game
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PatternGameScreen()));
              },
            ),
          ),
        ],
      ),
    );
  }
}

//import 'package:flutter/material.dart';

class GameCard extends StatelessWidget {
  final String title;
  final String image;
  final VoidCallback onTap;

  const GameCard({
    super.key,
    required this.title,
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.asset(
                  image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
