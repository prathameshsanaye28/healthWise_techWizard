import 'package:cloud_firestore/cloud_firestore.dart';

void populateMedicalProjects() async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Define medical project data
  final List<Map<String, dynamic>> medicalProjects = [
    {
      'creatorId': '6KgdPndlLGURG2Ki9exe',
      'description': 'Research project on advanced medical technologies.',
      'endDate': Timestamp.fromDate(DateTime(2024, 12, 21)),
      'feedbackComments': ['Excellent progress', 'Need more data on AI integration'],
      'financialStandards': ['International medical research funding standards'],
      'industryFocus': ['Healthcare', 'Medical Devices'],
      'isJobApplicationOpen': true,
      'isOpenForFeedback': true,
      'jobApplication': null,
      'joinRequests': ['7ShXvVwtQzN3cowZZEC29O6x8Y73'],
      'jurisdiction': 'India',
      'milestones': ['Initial phase completed', 'Data collection phase started'],
      'projectId': 'm2W5xPIpeAwJDd858mbB',
      'regulatoryExpertise': ['FDA regulations', 'ISO 13485'],
      'skillsRequired': ['Data Science', 'AI in Medicine'],
      'startDate': Timestamp.fromDate(DateTime(2024, 12, 24)),
      'technicalSkills': ['Python', 'Machine Learning'],
      'title': 'AI in Healthcare',
      'userRoles': {
        '6KgdPndlLGURG2Ki9exe': 'project manager',
        '7ShXvWwtQzN3cowZZEC29O6x8Y73': 'intern',
        'AiNUnMfyqdIhYg9Qcd1d': 'data scientist',
        'GjAE0pGIhLEWj7brmIVm': 'regulatory expert',
      },
      'yearsExperienceRequired': 1,
    },
    {
      'creatorId': 'AiNUnMfyqdIhYg9Qcd1d',
      'description': 'Study on the effects of medical devices on patient health.',
      'endDate': Timestamp.fromDate(DateTime(2024, 12, 15)),
      'feedbackComments': ['Project requires more clinical trials', 'Focus on patient feedback'],
      'financialStandards': ['Compliance with healthcare reimbursement rules'],
      'industryFocus': ['Medical Equipment', 'Clinical Trials'],
      'isJobApplicationOpen': false,
      'isOpenForFeedback': true,
      'jobApplication': null,
      'joinRequests': ['6KgdPndlLGURG2Ki9exe', 'GjAE0pGIhLEWj7brmIVm'],
      'jurisdiction': 'India',
      'milestones': ['Clinical trials completed', 'Data analysis in progress'],
      'projectId': 'v2W5xPIpeAwJDd858mbC',
      'regulatoryExpertise': ['Clinical trials regulations', 'ISO 13485'],
      'skillsRequired': ['Medical Device Design', 'Clinical Research'],
      'startDate': Timestamp.fromDate(DateTime(2024, 11, 30)),
      'technicalSkills': ['Clinical Trials', 'Medical Research'],
      'title': 'Medical Devices Impact Study',
      'userRoles': {
        'AiNUnMfyqdIhYg9Qcd1d': 'project manager',
        '6KgdPndlLGURG2Ki9exe': 'clinical researcher',
        'GjAE0pGIhLEWj7brmIVm': 'clinical expert',
      },
      'yearsExperienceRequired': 2,
    },
  ];

  // Define a batch to insert all the medical projects at once
  final WriteBatch batch = firestore.batch();

  for (var project in medicalProjects) {
    DocumentReference docRef = firestore.collection('projects').doc(project['projectId']);
    batch.set(docRef, project);
  }

  try {
    await batch.commit();
    print('Successfully added medical projects data to Firestore');
  } catch (e) {
    print('Error adding medical projects data to Firestore: $e');
  }




}

  Future<void> ensureIdFieldsInFirestore() async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  try {
    List<String> collectionNames = ['jobs', 'users', 'applications'];

    for (String collectionName in collectionNames) {
      QuerySnapshot collectionSnapshot =
          await firestore.collection(collectionName).get();

      for (QueryDocumentSnapshot doc in collectionSnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        if (!data.containsKey('id')) {
          await firestore
              .collection(collectionName)
              .doc(doc.id)
              .update({'id': doc.id});
          print(
              'Added "id" field to document ${doc.id} in collection "$collectionName".');
        } else {
          print(
              'Document ${doc.id} in collection "$collectionName" already has an "id" field.');
        }
      }
    }

    print('All collections have been processed.');
  } catch (e) {
    print('Error while processing collections: $e');
  }
}