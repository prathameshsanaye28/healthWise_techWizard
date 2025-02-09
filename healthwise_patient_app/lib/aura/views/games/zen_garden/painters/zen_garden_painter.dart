import 'package:flutter/material.dart';

class ZenGardenPainter extends CustomPainter {
  final List<List<Offset>> lines;
  final Color brushColor;

  ZenGardenPainter({required this.lines, required this.brushColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = brushColor // Use selected brush color
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    for (var line in lines) {
      if (line.length < 2) continue;

      final path = Path();
      path.moveTo(line[0].dx, line[0].dy);

      for (int i = 1; i < line.length - 1; i++) {
        final p0 = line[i];
        final p1 = line[i + 1];
        path.quadraticBezierTo(
          p0.dx,
          p0.dy,
          (p0.dx + p1.dx) / 2,
          (p0.dy + p1.dy) / 2,
        );
      }

      // Draw ripple effect first
      final ripplePaint = Paint()
        ..color = Colors.brown[100]!.withOpacity(0.3)
        ..strokeWidth = 16
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke;

      canvas.drawPath(path, ripplePaint);

      // Draw main line
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
