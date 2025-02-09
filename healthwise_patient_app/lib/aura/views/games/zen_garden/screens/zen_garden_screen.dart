import 'dart:math';
import 'package:flutter/material.dart';
import '../widgets/drawing_canvas.dart';

class ZenGardenScreen extends StatefulWidget {
  const ZenGardenScreen({super.key});

  @override
  _ZenGardenScreenState createState() => _ZenGardenScreenState();
}

class _ZenGardenScreenState extends State<ZenGardenScreen> {
  final List<String> _imagePaths = [
    'assets/game1_images/draw1.jpeg',
    'assets/game1_images/draw2.jpeg',
    'assets/game1_images/draw3.jpeg',
    'assets/game1_images/draw4.jpeg',
    'assets/game1_images/draw5.jpeg',
    'assets/game1_images/draw6.jpeg',
    'assets/game1_images/draw7.jpeg',
  ];

  String _selectedImage = '';
  Color _brushColor = Colors.brown;
  GlobalKey<DrawingCanvasState> canvasKey = GlobalKey<DrawingCanvasState>();

  @override
  void initState() {
    super.initState();
    _selectRandomImage();
  }

  void _selectRandomImage() {
    final random = Random();
    setState(() {
      _selectedImage = _imagePaths[random.nextInt(_imagePaths.length)];
    });
  }

  void _clearCanvas() {
    canvasKey.currentState?.clear();
  }

  final List<Color> _availableColors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.orange,
    Colors.purple,
    Colors.pink,
    Colors.brown,
    Colors.cyan,
    Colors.teal,
    Colors.lime,
    Colors.indigo,
    Colors.amber,
    Colors.grey,
    Colors.black,
    Colors.white,
  ];

  void _showColorGridPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            constraints: const BoxConstraints(
              maxWidth: 300.0,
              maxHeight: 300.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Select a brush color',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16.0),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                    ),
                    itemCount: _availableColors.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _brushColor = _availableColors[index];
                          });
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: _availableColors[index],
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.black,
                              width: 1.0,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 1,
                                blurRadius: 2,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 247, 227),
      appBar: AppBar(
        title: const Text('Zen Garden'),
        backgroundColor: Colors.brown[300],
        elevation: 0,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: _selectedImage.isNotEmpty
                ? Opacity(
                    opacity: 1,
                    child: Image.asset(
                      _selectedImage,
                      height: 150,
                      width: 100,
                    ),
                  )
                : Container(),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DrawingCanvas(
              key: canvasKey,
              brushColor: _brushColor,
            ),
          ),
          // Bottom row of buttons
          Positioned(
            right: 20,
            bottom: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildCircularButton(
                  onTap: () => _showColorGridPicker(context),
                  icon: Icons.palette,
                ),
                const SizedBox(width: 16),
                _buildCircularButton(
                  onTap: _clearCanvas,
                  icon: Icons.delete,
                ),
                const SizedBox(width: 16),
                _buildCircularButton(
                  onTap: _selectRandomImage,
                  icon: Icons.arrow_forward,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircularButton({
    required VoidCallback onTap,
    required IconData icon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: const Color(0xFFFFC0CB), // Light pink
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: Colors.black,
          size: 24,
        ),
      ),
    );
  }
}