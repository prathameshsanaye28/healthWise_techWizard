class Pattern {
  final List<List<bool>> grid;
  final int size;

  Pattern({required this.grid, required this.size});

  factory Pattern.empty(int size) {
    return Pattern(
      size: size,
      grid: List.generate(
        size,
        (i) => List.generate(size, (j) => false),
      ),
    );
  }

  Pattern copyWith({List<List<bool>>? grid}) {
    return Pattern(
      grid: grid ?? this.grid,
      size: size,
    );
  }

  bool isMatch(Pattern other) {
    if (size != other.size) return false;
    
    for (int i = 0; i < size; i++) {
      for (int j = 0; j < size; j++) {
        if (grid[i][j] != other.grid[i][j]) return false;
      }
    }
    return true;
  }
}