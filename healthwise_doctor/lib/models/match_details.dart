// import 'package:netwealth_vjti/models/doctor.dart';

// class MatchDetails {
//   final double skillScore;
//   final double experienceScore;
//   final double jurisdictionScore;
//   final double industryScore;

//   MatchDetails({
//     required this.skillScore,
//     required this.experienceScore,
//     required this.jurisdictionScore,
//     required this.industryScore,
//   });

//   double get totalScore => 
//     (skillScore * 0.4) + 
//     (experienceScore * 0.2) + 
//     (jurisdictionScore * 0.2) + 
//     (industryScore * 0.2);
// }

// class ScoredCandidate {
//   final Professional professional;
//   final MatchDetails matchDetails;

//   ScoredCandidate({
//     required this.professional,
//     required this.matchDetails,
//   });

//   double get score => matchDetails.totalScore;
// }


import 'package:healthwise/models/doctor.dart';

class MatchDetails {
  final double specializationScore;
  final double experienceScore;
  final double regionScore;
  final double conditionScore;

  MatchDetails({
    required this.specializationScore,
    required this.experienceScore,
    required this.regionScore,
    required this.conditionScore,
  });

  double get totalScore => 
    (specializationScore * 0.4) + 
    (experienceScore * 0.2) + 
    (regionScore * 0.2) + 
    (conditionScore * 0.2);
}

class ScoredDoctor {
  final Doctor doctor;
  final MatchDetails matchDetails;

  ScoredDoctor({
    required this.doctor,
    required this.matchDetails,
  });

  double get score => matchDetails.totalScore;
}