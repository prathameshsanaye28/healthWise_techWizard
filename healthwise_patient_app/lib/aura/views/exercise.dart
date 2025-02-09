class Exercise {
  final String name;
  final String description;
  final String videoUrl;
  final List<String> ageGroups;
  final int durationMinutes;
  final String difficulty;
  final String thumbnailUrl;

  Exercise({
    required this.name,
    required this.description,
    required this.videoUrl,
    required this.ageGroups,
    required this.durationMinutes,
    required this.difficulty,
    required this.thumbnailUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'videoUrl': videoUrl,
      'ageGroups': ageGroups,
      'durationMinutes': durationMinutes,
      'difficulty': difficulty,
      'thumbnailUrl': thumbnailUrl,
    };
  }

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      name: json['name'],
      description: json['description'],
      videoUrl: json['videoUrl'],
      ageGroups: List<String>.from(json['ageGroups']),
      durationMinutes: json['durationMinutes'],
      difficulty: json['difficulty'],
      thumbnailUrl: json['thumbnailUrl'],
    );
  }
}
