import 'package:flutter/material.dart';
import '../painters/zen_garden_painter.dart';

class DrawingCanvas extends StatefulWidget {
  final Color brushColor;

  const DrawingCanvas({
    super.key, 
    required this.brushColor
  });

  @override
  State<DrawingCanvas> createState() => DrawingCanvasState();
}

class DrawingCanvasState extends State<DrawingCanvas> {
  final List<List<Offset>> _lines = [];
  List<Offset> _currentLine = [];

  void _onPanStart(DragStartDetails details) {
    setState(() {
      _currentLine = [details.localPosition];
      _lines.add(_currentLine);
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _currentLine.add(details.localPosition);
    });
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() {
      _currentLine = [];
    });
  }

  // Method to clear the canvas - accessible from parent widget
  void clear() {
    setState(() {
      _lines.clear();
      _currentLine = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: _onPanStart,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: CustomPaint(
        painter: ZenGardenPainter(
          lines: _lines, 
          brushColor: widget.brushColor
        ),
        size: Size.infinite,
      ),
    );
  }
}