import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

import '../../../main.dart';

class CombinedAnalysisScreen extends StatelessWidget {
  const CombinedAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCE4EC), // Light pink background
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        // leading: IconButton(
        //   icon: const Icon(Icons.menu, color: Colors.black87),
        //   onPressed: () {},
        // ),
        title: const Text(
          'Analysis Dashboard',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.black87),
            onPressed: () {},
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundColor: Colors.purple[100],
              radius: 16,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextAnalysisSection(context),
              const SizedBox(height: 20),
              _buildAppUsageSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextAnalysisSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Text Analysis',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Consumer<TextAnalysisProvider>(
            builder: (context, provider, _) {
              return TextField(
                maxLines: 5,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.pink[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  hintText: 'Let your thoughts flow...',
                ),
                onChanged: (text) => provider.handleTextInput(text),
              );
            },
          ),
          const SizedBox(height: 16),
          Consumer<TextAnalysisProvider>(
            builder: (context, provider, _) {
              return _buildMetricsGrid(provider);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsGrid(TextAnalysisProvider provider) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        _buildMetricCard(
          title: 'Words/Min',
          value: provider.currentTypingSpeed.toStringAsFixed(1),
          icon: '⚡',
          color: Colors.blue[50]!,
          iconColor: Colors.blue[200]!,
        ),
        _buildMetricCard(
          title: 'Total Words',
          value: provider.totalWords.toString(),
          icon: '📝',
          color: Colors.purple[50]!,
          iconColor: Colors.purple[200]!,
        ),
        _buildMetricCard(
          title: 'Changes/Min',
          value: provider.changesPerMinute.toStringAsFixed(1),
          icon: '🔄',
          color: Colors.green[50]!,
          iconColor: Colors.green[200]!,
        ),
        _buildMetricCard(
          title: 'Consistency',
          value: '${(provider.consistency * 100).toStringAsFixed(0)}%',
          icon: '📊',
          color: Colors.amber[50]!,
          iconColor: Colors.amber[200]!,
        ),
      ],
    );
  }

  Widget _buildAppUsageSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'App Usage',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          const SizedBox(height: 16),
          Consumer<AppUsageProvider>(
            builder: (context, provider, _) {
              return Row(
                children: [
                  Expanded(
                    child: _buildMetricCard(
                      title: 'Intensity',
                      value: provider.metrics.isNotEmpty
                          ? provider.metrics.last.intensity.toStringAsFixed(1)
                          : '0',
                      icon: '⚡',
                      color: Colors.pink[50]!,
                      iconColor: Colors.pink[200]!,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildMetricCard(
                      title: 'Switch Count',
                      value: provider.metrics.isNotEmpty
                          ? provider.metrics.last.switchCount.toString()
                          : '0',
                      icon: '🔄',
                      color: Colors.indigo[50]!,
                      iconColor: Colors.indigo[200]!,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String icon,
    required Color color,
    required Color iconColor,
  }) {
    return Container(
      //height: 55,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              color: iconColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                icon,
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

// Keep the existing TextAnalysisProvider class unchanged
// Keep the existing AppUsageProvider class unchanged
// Keep the existing AppUsageGraphPainter class unchanged
// Keep all the existing models (TextMetric, AppUsageMetric) unchanged
// Keep the LifecycleObserver unchanged

// Add this to main.dart:

class TextMetric {
  final double wordsPerMinute;
  final int wordCount;
  final double changesPerMinute;
  final double consistency;
  final DateTime timestamp;

  TextMetric({
    required this.wordsPerMinute,
    required this.wordCount,
    required this.changesPerMinute,
    required this.consistency,
    required this.timestamp,
  });
}

class TextAnalysisProvider with ChangeNotifier {
  final List<TextMetric> _metrics = [];
  String _lastText = '';
  DateTime? _lastUpdate;
  int _totalChanges = 0;
  Timer? _analysisTimer;
  double _baselineTypingSpeed = 0;

  List<TextMetric> get metrics => _metrics;
  double get baselineTypingSpeed => _baselineTypingSpeed;
  double get currentTypingSpeed =>
      _metrics.isNotEmpty ? _metrics.last.wordsPerMinute : 0;
  int get totalWords => _metrics.isNotEmpty ? _metrics.last.wordCount : 0;
  double get changesPerMinute =>
      _metrics.isNotEmpty ? _metrics.last.changesPerMinute : 0;
  double get consistency =>
      _metrics.isNotEmpty ? _metrics.last.consistency : 1.0;

  TextAnalysisProvider() {
    _analysisTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      _analyzePatterns();
    });
  }

  void handleTextInput(String text) {
    final now = DateTime.now();
    _lastUpdate ??= now;

    if (_lastText.isNotEmpty) {
      _totalChanges += _calculateChanges(_lastText, text);
    }

    _updateMetrics(text, now);
    _lastText = text;
  }

  int _calculateChanges(String oldText, String newText) {
    final oldWords =
        oldText.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;
    final newWords =
        newText.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;
    return (newWords - oldWords).abs();
  }

  void _updateMetrics(String text, DateTime now) {
    final duration = now.difference(_lastUpdate!);
    if (duration.inSeconds < 1) return;

    final words = text.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;
    final minutesFraction = duration.inMilliseconds / 60000;

    final wordsPerMinute = words / minutesFraction;
    final changesPerMinute = _totalChanges / minutesFraction;
    final consistency = _calculateConsistency(wordsPerMinute);

    final metric = TextMetric(
      wordsPerMinute: wordsPerMinute,
      wordCount: words,
      changesPerMinute: changesPerMinute,
      consistency: consistency,
      timestamp: now,
    );

    _metrics.add(metric);
    _cleanOldData();
    _updateBaseline();
    notifyListeners();
  }

  double _calculateConsistency(double currentSpeed) {
    if (_metrics.isEmpty) return 1.0;

    final recentMetrics = _getRecentMetrics(const Duration(seconds: 30));
    if (recentMetrics.length < 2) return 1.0;

    final speeds = recentMetrics.map((m) => m.wordsPerMinute).toList();
    final mean = speeds.reduce((a, b) => a + b) / speeds.length;
    final variations = speeds.map((s) => (s - mean).abs() / mean);
    final averageVariation =
        variations.reduce((a, b) => a + b) / variations.length;

    return (1 - averageVariation).clamp(0.0, 1.0);
  }

  List<TextMetric> _getRecentMetrics(Duration duration) {
    final cutoff = DateTime.now().subtract(duration);
    return _metrics.where((m) => m.timestamp.isAfter(cutoff)).toList();
  }

  void _cleanOldData() {
    final cutoff = DateTime.now().subtract(const Duration(minutes: 5));
    _metrics.removeWhere((m) => m.timestamp.isBefore(cutoff));
  }

  void _updateBaseline() {
    if (_metrics.length < 5) return;
    _baselineTypingSpeed =
        _metrics.map((m) => m.wordsPerMinute).reduce((a, b) => a + b) /
            _metrics.length;
  }

  void _analyzePatterns() {
    if (_metrics.isEmpty) return;

    final recentMetrics = _getRecentMetrics(const Duration(minutes: 2));
    if (recentMetrics.length < 3) return;

    // Don't show notification if current typing speed is 0
    if (currentTypingSpeed == 0) return;

    final averageSpeed =
        recentMetrics.map((m) => m.wordsPerMinute).reduce((a, b) => a + b) /
            recentMetrics.length;

    final highChanges = recentMetrics.last.changesPerMinute > 20;
    final lowConsistency = recentMetrics.last.consistency < 0.5;
    final speedDrop = averageSpeed < _baselineTypingSpeed * 0.7;

    if ((highChanges && lowConsistency) || speedDrop) {
      _showFocusNotification();
    }
  }

  Future<void> _showFocusNotification() async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'focus_channel',
      'Focus Notifications',
      channelDescription: 'Notifications for focus and productivity',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails details =
        NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Writing Pattern Change Detected',
      'Would you like to take a moment to focus and organize your thoughts?',
      details,
      payload: 'calmNowScreen',
    );
  }

  @override
  void dispose() {
    _analysisTimer?.cancel();
    super.dispose();
  }
}

class KeystrokeMetric {
  final double typingSpeed;
  final double dwellTime;
  final double flightTime;
  final double rhythmConsistency;
  final double errorRate;
  final DateTime timestamp;

  KeystrokeMetric({
    required this.typingSpeed,
    required this.dwellTime,
    required this.flightTime,
    required this.rhythmConsistency,
    required this.errorRate,
    required this.timestamp,
  });
}

class AppUsageMetric {
  final int switchCount;
  final DateTime timestamp;
  final double intensity;

  AppUsageMetric({
    required this.switchCount,
    required this.timestamp,
    required this.intensity,
  });
}

class AppUsageProvider with ChangeNotifier {
  final List<AppUsageMetric> _metrics = [];
  DateTime? _lastSwitch;
  int _switchCount = 0;
  Timer? _analysisTimer;
  bool _isActive = false;

  // Cooldown properties
  DateTime? lastNotificationTime;
  static const Duration notificationCooldown = Duration(minutes: 3);

  List<AppUsageMetric> get metrics => _metrics;
  bool get isActive => _isActive;

  AppUsageProvider() {
    _analysisTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _analyzePatterns();
    });

    // Start tracking when app becomes active
    WidgetsBinding.instance.addObserver(
      LifecycleObserver(
        onResume: () {
          _isActive = true;
          recordAppSwitch();
        },
        onPause: () {
          _isActive = false;
          notifyListeners();
        },
      ),
    );
  }

  void recordAppSwitch() {
    final now = DateTime.now();
    _switchCount++;

    if (_lastSwitch != null) {
      final timeSinceLastSwitch = now.difference(_lastSwitch!).inSeconds;
      final intensity = 60 / math.max(timeSinceLastSwitch, 1);

      _metrics.add(AppUsageMetric(
        switchCount: _switchCount,
        timestamp: now,
        intensity: intensity,
      ));

      _cleanOldData();
      notifyListeners();
    }

    _lastSwitch = now;
  }

  void _cleanOldData() {
    final cutoff = DateTime.now().subtract(const Duration(minutes: 5));
    _metrics.removeWhere((m) => m.timestamp.isBefore(cutoff));
  }

  void _analyzePatterns() {
    if (!_isActive) return;

    final recentMetrics = _getRecentMetrics(const Duration(minutes: 3));
    if (recentMetrics.isEmpty) return;

    final totalSwitches =
        recentMetrics.last.switchCount - recentMetrics.first.switchCount;

    if (totalSwitches >= 5) {
      // Check cooldown before sending notification
      if (lastNotificationTime == null ||
          DateTime.now().difference(lastNotificationTime!) >
              notificationCooldown) {
        _showUsageNotification();
        _switchCount = 0; // Reset switch count after notification
        lastNotificationTime = DateTime.now(); // Update last notification time
      }
    }
  }

  List<AppUsageMetric> _getRecentMetrics(Duration duration) {
    final cutoff = DateTime.now().subtract(duration);
    return _metrics.where((m) => m.timestamp.isAfter(cutoff)).toList();
  }

  Future<void> _showUsageNotification() async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'usage_channel',
      'Usage Notifications',
      channelDescription: 'Notifications for app usage patterns',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails details =
        NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      1,
      'App Usage Pattern',
      'We noticed frequent app switching. Would you like to focus on one task?',
      details,
      payload: 'calmNowScreen',
    );
  }

  @override
  void dispose() {
    _analysisTimer?.cancel();
    super.dispose();
  }

  getAverageSwitchesPerMinute(int hours) {
    final cutoff = DateTime.now().subtract(Duration(hours: hours));
    final relevantMetrics =
        _metrics.where((metric) => metric.timestamp.isAfter(cutoff)).toList();

    List<int> switchesPerMinute = [];
    for (int i = 0; i < hours * 60; i += 10) {
      // Aggregate every 10 minutes
      final segmentStart = cutoff.add(Duration(minutes: i));
      final segmentEnd = cutoff.add(Duration(minutes: i + 10));
      final segmentSwitches = relevantMetrics
          .where((metric) =>
              metric.timestamp.isAfter(segmentStart) &&
              metric.timestamp.isBefore(segmentEnd))
          .map((metric) => metric.switchCount)
          .fold(0, (a, b) => a + b); // Use fold instead of reduce

      switchesPerMinute.add(segmentSwitches);
    }
    return switchesPerMinute;
  }
}

// Lifecycle observer for app state changes
class LifecycleObserver extends WidgetsBindingObserver {
  final VoidCallback onResume;
  final VoidCallback onPause;

  LifecycleObserver({required this.onResume, required this.onPause});

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        onResume();
        break;
      case AppLifecycleState.paused:
        onPause();
        break;
      default:
        break;
    }
  }
}

// Custom Painters for Graphs
class GraphPainter extends CustomPainter {
  final List<KeystrokeMetric> metrics;
  final double baselineSpeed;
  final Color primaryColor;
  final Color baselineColor;
  final Color thresholdColor;

  GraphPainter({
    required this.metrics,
    required this.baselineSpeed,
    required this.primaryColor,
    required this.baselineColor,
    required this.thresholdColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (metrics.isEmpty) return;

    final paint = Paint()
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    // Draw threshold line
    paint.color = thresholdColor.withOpacity(0.5);
    final thresholdY = size.height * 0.3;
    canvas.drawLine(
      Offset(0, thresholdY),
      Offset(size.width, thresholdY),
      paint,
    );

    // Draw baseline
    paint.color = baselineColor;
    final baselineY = _normalizeValue(baselineSpeed, size.height);
    canvas.drawLine(
      Offset(0, baselineY),
      Offset(size.width, baselineY),
      paint,
    );

    // Draw typing speed line
    paint.color = primaryColor;
    final path = Path();
    bool first = true;

    for (var i = 0; i < metrics.length; i++) {
      final x = size.width * (i / (metrics.length - 1));
      final y = _normalizeValue(metrics[i].typingSpeed, size.height);

      if (first) {
        path.moveTo(x, y);
        first = false;
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);
  }

  double _normalizeValue(double value, double height) {
    return height - (value / 100 * height);
  }

  @override
  bool shouldRepaint(GraphPainter oldDelegate) => true;
}

class AppUsageBarGraphPainter extends CustomPainter {
  final List<int>
      switchesPerMinute; // Data representing average app switches per minute
  final List<Color> barColors;

  AppUsageBarGraphPainter({
    required this.switchesPerMinute,
    required this.barColors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill;

    // Calculate the width for each bar
    final barWidth = size.width / (switchesPerMinute.length * 2);
    final maxSwitches = switchesPerMinute.isNotEmpty
        ? switchesPerMinute.reduce(math.max)
        : 1; // Avoid division by zero

    for (int i = 0; i < switchesPerMinute.length; i++) {
      paint.color = barColors[i % barColors.length];

      // Normalize the height based on max switches and convert to double
      final barHeight = (switchesPerMinute[i] / maxSwitches) * size.height;
      final x = i * barWidth * 2;

      canvas.drawRect(
        Rect.fromLTWH(x, size.height - barHeight, barWidth, barHeight),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(AppUsageBarGraphPainter oldDelegate) => true;
}
