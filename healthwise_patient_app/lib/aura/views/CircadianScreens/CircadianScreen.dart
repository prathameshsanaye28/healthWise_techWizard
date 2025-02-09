// lib/theme/pastel_theme.dart
import 'dart:math';

import 'package:flutter/material.dart';

class PastelTheme {
  static const Color pastelBlue = Color(0xFFB5D8F0);
  static const Color pastelPink = Color(0xFFF8C8DC);
  static const Color pastelGreen = Color(0xFFBEE5BE);
  static const Color pastelYellow = Color(0xFFFFF4BD);
  static const Color pastelPurple = Color(0xFFE0BBE4);
  static const Color pastelOrange = Color(0xFFFFDAB9);

  static ThemeData get theme => ThemeData(
        primaryColor: pastelBlue,
        scaffoldBackgroundColor: Colors.white,
        cardTheme: CardTheme(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          color: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black87),
          titleTextStyle: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
}

// lib/models/circadian_cycle.dart
class CircadianCycle {
  final TimeOfDay time;
  final String phase;
  final String activity;
  final String description;
  final Color color;

  CircadianCycle({
    required this.time,
    required this.phase,
    required this.activity,
    required this.description,
    required this.color,
  });

  static List<CircadianCycle> getDailyCycle() {
    return [
      CircadianCycle(
        time: const TimeOfDay(hour: 6, minute: 0),
        phase: 'Wake-Up Phase',
        activity: 'Cortisol Release',
        description:
            'Natural awakening time. Cortisol levels rise to help you start your day.',
        color: PastelTheme.pastelYellow,
      ),
      CircadianCycle(
        time: const TimeOfDay(hour: 9, minute: 0),
        phase: 'Peak Performance',
        activity: 'High Mental Alertness',
        description:
            'Best time for complex cognitive tasks and important decisions.',
        color: PastelTheme.pastelBlue,
      ),
      // Add more cycle phases...
    ];
  }
}

// lib/screens/energy_education_screen.dart
class EnergyEducationScreen extends StatelessWidget {
  const EnergyEducationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Understanding Your Energy')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCircadianClock(),
              const SizedBox(height: 24),
              _buildEnergyPhases(context), // Pass context here
              const SizedBox(height: 24),
              _buildTipsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEnergyPhases(BuildContext context) {
    // Accept context here
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: CircadianCycle.getDailyCycle().map((cycle) {
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: cycle.color, width: 2),
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: cycle.color,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        cycle.time.format(context), // This will now work
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      cycle.phase,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  cycle.activity,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  cycle.description,
                  style: const TextStyle(color: Colors.black54),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

Widget _buildTipsSection() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Optimize Your Day',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 16),
      _buildTipCard(
        title: 'Morning Routine',
        tips: [
          'Wake up at the same time daily',
          'Get morning sunlight exposure',
          'Exercise in the morning for energy boost',
        ],
        color: PastelTheme.pastelYellow,
      ),
      _buildTipCard(
        title: 'Afternoon Strategy',
        tips: [
          'Take short breaks every 90 minutes',
          'Light lunch to avoid energy crashes',
          'Strategic caffeine timing before 2 PM',
        ],
        color: PastelTheme.pastelGreen,
      ),
      _buildTipCard(
        title: 'Evening Wind-Down',
        tips: [
          'Dim lights 2 hours before bed',
          'Avoid blue light exposure',
          'Maintain consistent bedtime',
        ],
        color: PastelTheme.pastelPurple,
      ),
    ],
  );
}

Widget _buildCircadianClock() {
  return Container(
    height: 300,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: PastelTheme.pastelBlue.withOpacity(0.2),
      borderRadius: BorderRadius.circular(20),
    ),
    child: CustomPaint(
      painter: CircadianClockPainter(),
      child: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '24-Hour Energy Cycle',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Your natural rhythm',
              style: TextStyle(color: Colors.black54),
            ),
            Text(
              'throughout the day',
              style: TextStyle(color: Colors.black54),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildTipCard({
  required String title,
  required List<String> tips,
  required Color color,
}) {
  return Card(
    margin: const EdgeInsets.only(bottom: 16),
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: color, width: 2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...tips.map((tip) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Text(tip)),
                  ],
                ),
              )),
        ],
      ),
    ),
  );
}

// lib/widgets/circadian_clock_painter.dart
class CircadianClockPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2 - 20;

    // Draw the clock circle
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = Colors.black87;

    canvas.drawCircle(center, radius, paint);

    // Draw hour markers and energy levels
    for (int hour = 0; hour < 24; hour++) {
      final angle = hour * (2 * pi / 24) - pi / 2;
      final hourPoint = Offset(
        center.dx + cos(angle) * radius,
        center.dy + sin(angle) * radius,
      );

      // Draw hour marker
      final markerPaint = Paint()
        ..style = PaintingStyle.fill
        ..color = _getColorForHour(hour);

      canvas.drawCircle(hourPoint, 4, markerPaint);

      // Draw hour text
      final textPainter = TextPainter(
        text: TextSpan(
          text: hour.toString(),
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 12,
          ),
        ),
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();
      textPainter.paint(
        canvas,
        hourPoint.translate(-textPainter.width / 2, -20),
      );
    }
  }

  Color _getColorForHour(int hour) {
    if (hour >= 6 && hour < 10) return PastelTheme.pastelYellow;
    if (hour >= 10 && hour < 14) return PastelTheme.pastelBlue;
    if (hour >= 14 && hour < 18) return PastelTheme.pastelGreen;
    if (hour >= 18 && hour < 22) return PastelTheme.pastelPurple;
    return PastelTheme.pastelPink;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// lib/models/energy_insight.dart
class EnergyInsight {
  final DateTime timestamp;
  final double predictedEnergy;
  final String recommendation;
  final List<String> optimizationTips;

  EnergyInsight({
    required this.timestamp,
    required this.predictedEnergy,
    required this.recommendation,
    required this.optimizationTips,
  });

  static List<EnergyInsight> generateDailyInsights() {
    // Implementation for generating personalized insights
    return [];
  }
}

// lib/screens/energy_insights_screen.dart
class EnergyInsightsScreen extends StatelessWidget {
  const EnergyInsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Energy Insights')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildEnergyPredictionCard(),
            const SizedBox(height: 24),
            _buildOptimizationTips(),
          ],
        ),
      ),
    );
  }

  Widget _buildEnergyPredictionCard() {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Energy Forecast',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            // Add energy prediction visualization
          ],
        ),
      ),
    );
  }

  Widget _buildOptimizationTips() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Personalized Recommendations',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),
        // Add personalized tips based on user data
      ],
    );
  }
}
