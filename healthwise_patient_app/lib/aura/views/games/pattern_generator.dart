import 'dart:math';
import 'pattern.dart';

class PatternGenerator {
  static Pattern generateRandomPattern(int size, {double complexity = 0.5}) {
    final random = Random();
    final grid = List.generate(
      size,
      (i) => List.generate(
        size,
        (j) => random.nextDouble() < complexity,
      ),
    );
    
    // Ensure at least one tile is active to avoid empty patterns
    if (!grid.any((row) => row.any((cell) => cell))) {
      grid[random.nextInt(size)][random.nextInt(size)] = true;
    }
    
    return Pattern(grid: grid, size: size);
  }
}