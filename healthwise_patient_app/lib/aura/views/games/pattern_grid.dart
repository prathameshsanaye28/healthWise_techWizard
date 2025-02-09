import 'package:flutter/material.dart';

import 'pattern.dart';

class PatternGrid extends StatelessWidget {
  final Pattern pattern;
  final bool isInteractive;
  final Function(int, int)? onTileTap;

  const PatternGrid({
    super.key,
    required this.pattern,
    this.isInteractive = false,
    this.onTileTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.circular(8),
      ),
      child: AspectRatio(
        aspectRatio: 1,
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: pattern.size,
            crossAxisSpacing: 2,
            mainAxisSpacing: 2,
          ),
          itemCount: pattern.size * pattern.size,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(4),
          itemBuilder: (context, index) {
            final row = index ~/ pattern.size;
            final col = index % pattern.size;
            return PatternTile(
              isActive: pattern.grid[row][col],
              onTap: isInteractive ? () => onTileTap?.call(row, col) : null,
            );
          },
        ),
      ),
    );
  }
}

class PatternTile extends StatelessWidget {
  final bool isActive;
  final VoidCallback? onTap;

  const PatternTile({
    super.key,
    required this.isActive,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isActive ? Colors.blue : Colors.white,
          border: Border.all(color: Colors.blue.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}
