
import 'package:flutter/material.dart';
import 'package:healthwise_patient_app/aura/views/games/pattern_generator.dart';
import 'package:healthwise_patient_app/aura/views/games/pattern_grid.dart';
import 'package:healthwise_patient_app/aura/views/games/pattern.dart';

class PatternGameScreen extends StatefulWidget {
  const PatternGameScreen({super.key});

  @override
  State<PatternGameScreen> createState() => _PatternGameScreenState();
}

class _PatternGameScreenState extends State<PatternGameScreen> {
  static const int gridSize = 4;
  late Pattern targetPattern;
  late Pattern userPattern;
  int score = 0;
  int level = 1;

  @override
  void initState() {
    super.initState();
    _initializeLevel();
  }

  void _initializeLevel() {
    targetPattern = PatternGenerator.generateRandomPattern(gridSize);
    userPattern = Pattern.empty(gridSize);
  }

  void _handleTileTap(int row, int col) {
    setState(() {
      final newGrid = List<List<bool>>.from(
        userPattern.grid.map((list) => List<bool>.from(list)),
      );
      newGrid[row][col] = !newGrid[row][col];
      userPattern = userPattern.copyWith(grid: newGrid);

      if (targetPattern.isMatch(userPattern)) {
        score += 100;
        level++;
        _initializeLevel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pattern Matching Game'),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Score: $score',
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(62.0, 0, 0, 0),
                    child: Column(
                      children: [
                        Text(
                          'Level $level',
                          // style: Theme.of(context).textTheme.headline5,
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Match this pattern:',
                                //  style: Theme.of(context).textTheme.subtitle1,
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                height: constraints.maxHeight * 0.35,
                                child: PatternGrid(pattern: targetPattern),
                              ),
                              const SizedBox(height: 24),
                              const Text(
                                'Your pattern:',
                                // style: Theme.of(context).textTheme.subtitle1,
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                height: constraints.maxHeight * 0.35,
                                child: PatternGrid(
                                  pattern: userPattern,
                                  isInteractive: true,
                                  onTileTap: _handleTileTap,
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
            );
          },
        ),
      ),
    );
  }
}
