

import 'package:healthwise/models/doctor.dart';
import 'package:healthwise/models/jobapplication.dart';
import 'package:healthwise/models/scored_job.dart';

class JobMatcherService {
  Future<List<ScoredJobApplication>> findJobMatches(
    Doctor profile,
    List<JobApplication> jobs
  ) async {
    List<ScoredJobApplication> scoredJobs = [];
    for (var job in jobs) {
      final matchDetails = await _calculateJobMatchDetails(profile, job);
      scoredJobs.add(ScoredJobApplication(
        jobApplication: job,
        matchDetails: matchDetails,
      ));
    }
    return scoredJobs;
  }

  Future<MatchDetails> _calculateJobMatchDetails(
    Doctor profile,
    JobApplication job
  ) async {
    double skillScore = _calculateJobSkillScore(profile, job);
    double experienceScore = _calculateJobExperienceScore(profile, job);
    double jurisdictionScore = _calculateJobJurisdictionScore(profile, job);
    double industryScore = _calculateJobIndustryScore(profile, job);

    return MatchDetails(
      skillScore: skillScore,
      experienceScore: experienceScore,
      jurisdictionScore: jurisdictionScore,
      industryScore: industryScore,
    );
  }

  double _calculateJobSkillScore(Doctor profile, JobApplication job) {
    double technicalScore = _calculateSetSimilarity(
      profile.specializations.toSet(),
      job.requiredSpecializations.toSet()
    );
    double regulatoryScore = _calculateSetSimilarity(
      profile.certifications.toSet(),
      job.requiredCertifications.toSet()
    );
    double standardsScore = _calculateSetSimilarity(
      profile.procedures.toSet(),
      job.requiredProcedures.toSet()
    );

    return (technicalScore * 0.4 + regulatoryScore * 0.3 + standardsScore * 0.3);
  }

  double _calculateSetSimilarity(Set<String> set1, Set<String> set2) {
    if (set1.isEmpty || set2.isEmpty) return 0.0;
    return set1.intersection(set2).length / set2.length;
  }

  double _calculateJobExperienceScore(Doctor profile, JobApplication job) {
    if (profile.yearsExperience >= job.yearsExperienceRequired) {
      return 1.0;
    }
    return profile.yearsExperience / job.yearsExperienceRequired;
  }

  double _calculateJobJurisdictionScore(Doctor profile, JobApplication job) {
    const matrix = {
      'EU': {'EU': 1.0, 'UK': 0.8, 'US': 0.6, 'APAC': 0.5},
      'UK': {'EU': 0.8, 'UK': 1.0, 'US': 0.7, 'APAC': 0.5},
      'US': {'EU': 0.6, 'UK': 0.7, 'US': 1.0, 'APAC': 0.6},
      'APAC': {'EU': 0.5, 'UK': 0.5, 'US': 0.6, 'APAC': 1.0},
    };
    return matrix[profile.region]?[job.region] ?? 0.3;
  }

  double _calculateJobIndustryScore(Doctor profile, JobApplication job) {
    return _calculateSetSimilarity(
      profile.conditions.toSet(),
      job.treatedConditions.toSet()
    );
  }
}



// class JobMatcherService {
//   Future<List<ScoredJobApplication>> findJobMatches(
//     Doctor profile,
//     List<JobApplication> jobs
//   ) async {
//     List<ScoredJobApplication> scoredJobs = [];
//     for (var job in jobs) {
//       final matchDetails = await _calculateJobMatchDetails(profile, job);
//       scoredJobs.add(ScoredJobApplication(
//         jobApplication: job,
//         matchDetails: matchDetails,
//       ));
//     }
//     return scoredJobs;
//   }

//   Future<MatchDetails> _calculateJobMatchDetails(
//     Doctor profile,
//     JobApplication job
//   ) async {
//     double specializationScore = _calculateSpecializationScore(profile, job);
//     double experienceScore = _calculateExperienceScore(profile, job);
//     double regionScore = _calculateRegionScore(profile, job);
//     double proceduresScore = _calculateProceduresScore(profile, job);

//     return MatchDetails(
//       specializationScore: specializationScore,
//       experienceScore: experienceScore,
//       regionScore: regionScore,
//       proceduresScore: proceduresScore,
//     );
//   }

//   double _calculateSpecializationScore(Doctor profile, JobApplication job) {
//     double specializationMatch = _calculateSetSimilarity(
//       profile.specializations.toSet(),
//       job.requiredSpecializations.toSet()
//     );
//     double certificationMatch = _calculateSetSimilarity(
//       profile.certifications.toSet(),
//       job.requiredCertifications.toSet()
//     );
//     double conditionsMatch = _calculateSetSimilarity(
//       profile.conditions.toSet(),
//       job.treatedConditions.toSet()
//     );

//     return (specializationMatch * 0.4 + certificationMatch * 0.3 + conditionsMatch * 0.3);
//   }

//   double _calculateSetSimilarity(Set<String> set1, Set<String> set2) {
//     if (set1.isEmpty || set2.isEmpty) return 0.0;
//     return set1.intersection(set2).length / set2.length;
//   }

//   double _calculateExperienceScore(Doctor profile, JobApplication job) {
//     if (profile.yearsExperience >= job.yearsExperienceRequired) {
//       return 1.0;
//     }
//     return profile.yearsExperience / job.yearsExperienceRequired;
//   }

//   double _calculateRegionScore(Doctor profile, JobApplication job) {
//     if (profile.region == job.region) return 1.0;
    
//     const regionMatrix = {
//       'North': {'North': 1.0, 'South': 0.6, 'East': 0.7, 'West': 0.6},
//       'South': {'North': 0.6, 'South': 1.0, 'East': 0.6, 'West': 0.7},
//       'East': {'North': 0.7, 'South': 0.6, 'East': 1.0, 'West': 0.6},
//       'West': {'North': 0.6, 'South': 0.7, 'East': 0.6, 'West': 1.0},
//     };
//     return regionMatrix[profile.region]?[job.region] ?? 0.3;
//   }

//   double _calculateProceduresScore(Doctor profile, JobApplication job) {
//     return _calculateSetSimilarity(
//       profile.procedures.toSet(),
//       job.requiredProcedures.toSet()
//     );
//   }
// }



// import 'package:netwealth_vjti/models/jobs.dart';
// import 'package:netwealth_vjti/models/doctor.dart';
// import 'package:netwealth_vjti/models/scored_job.dart';

// class JobMatcherService {
//   Future<List<ScoredJobApplication>> findJobMatches(
//     Doctor doctor,
//     List<Job> jobs
//   ) async {
//     List<ScoredJobApplication> scoredJobs = [];
//     for (var job in jobs) {
//       final matchDetails = await _calculateJobMatchDetails(doctor, job);
//       scoredJobs.add(ScoredJobApplication(
//         jobApplication: job,
//         matchDetails: matchDetails,
//       ));
//     }
//     return scoredJobs;
//   }

//   Future<MatchDetails> _calculateJobMatchDetails(Doctor doctor, Job job) async {
//     double skillScore = _calculateSkillMatch(doctor, job);
//     double experienceScore = _calculateExperienceMatch(doctor, job);
//     double specializationScore = _calculateSpecializationMatch(doctor, job);
//     double regionScore = _calculateRegionMatch(doctor, job);

//     return MatchDetails(
//       skillScore: skillScore,
//       experienceScore: experienceScore,
//       specializationScore: specializationScore, 
//       regionScore: regionScore,
//     );
//   }

//   double _calculateSkillMatch(Doctor doctor, Job job) {
//     Set<String> doctorSkills = {...doctor.procedures, ...doctor.certifications};
//     Set<String> jobSkills = job.requiredSkills.toSet();
    
//     if (jobSkills.isEmpty) return 1.0;
//     return doctorSkills.intersection(jobSkills).length / jobSkills.length;
//   }

//   double _calculateExperienceMatch(Doctor doctor, Job job) {
//     int requiredYears = 2; // Default minimum requirement
//     return doctor.yearsExperience >= requiredYears ? 1.0 : 
//            doctor.yearsExperience / requiredYears;
//   }

//   double _calculateSpecializationMatch(Doctor doctor, Job job) {
//     bool hasRelevantSpecialization = job.description.toLowerCase()
//         .split(' ')
//         .any((word) => doctor.specializations
//             .map((s) => s.toLowerCase())
//             .contains(word));
//     return hasRelevantSpecialization ? 1.0 : 0.0;
//   }

//   double _calculateRegionMatch(Doctor doctor, Job job) {
//     // Simple region matching - can be expanded based on specific requirements
//     Map<String, List<String>> compatibleRegions = {
//       'North': ['North', 'Central'],
//       'South': ['South', 'Central'],
//       'East': ['East', 'Central'],
//       'West': ['West', 'Central'],
//       'Central': ['North', 'South', 'East', 'West', 'Central']
//     };

//     List<String> compatibleWithDoctor = compatibleRegions[doctor.region] ?? [];
//     return compatibleWithDoctor.contains(job.region) ? 1.0 : 0.3;
//   }
// }