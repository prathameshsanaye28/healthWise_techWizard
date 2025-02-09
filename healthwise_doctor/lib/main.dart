import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:healthwise/firebase_options.dart';
import 'package:healthwise/resources/job_matching_provider.dart';
import 'package:healthwise/resources/matching_provider.dart';
import 'package:healthwise/resources/user_provider.dart';
import 'package:healthwise/screens/api_marketplace.dart';
import 'package:healthwise/screens/auth_screens/login.dart';
import 'package:healthwise/screens/mainlayout_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //await addAppointmentsData();
  //await ensureIdFieldsInFirestore();
  //await ensureIdFieldsInFirestore();
  final userProvider = UserProvider();
  await userProvider.initialize();
  //populateMedicalProjects();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: userProvider),
    ],
    child: MyApp()),
);
}

Future<void> ensureIdAndPatientIdsInFirestore() async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  try {
    List<String> collectionNames = ['users'];

    for (String collectionName in collectionNames) {
      QuerySnapshot collectionSnapshot =
          await firestore.collection(collectionName).get();

      for (QueryDocumentSnapshot doc in collectionSnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        Map<String, dynamic> updates = {};

        // // Ensure 'id' field exists
        // if (!data.containsKey('id')) {
        //   updates['id'] = doc.id;
        // }

        // Ensure 'patientIds' field exists and is a list
        if (!data.containsKey('patientIds')) {
          updates['patientIds'] = [];
        }

        // Update the document only if changes are needed
        if (updates.isNotEmpty) {
          await firestore.collection(collectionName).doc(doc.id).update(updates);
          print(
              'Updated document ${doc.id} in collection "$collectionName" with missing fields.');
        } else {
          print('Document ${doc.id} already contains required fields.');
        }
      }
    }

    print('All documents processed successfully.');
  } catch (e) {
    print('Error while processing collections: $e');
  }
}


class MyApp extends StatelessWidget {
  FirebaseAuth auth = FirebaseAuth.instance;
   MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // ChangeNotifierProvider.value(value: userProvider),
        // ChangeNotifierProvider(
        //   create: (_) => UserProvider(),
        // ),
        // ChangeNotifierProvider(
        //   create: (_) => MatchingProvider(UserProvider()), // Pass UserProvider instance here
        // ),
        ChangeNotifierProvider(
          create: (_) => ApiProvider(), // Pass UserProvider instance here
        ),
        // ChangeNotifierProvider(
        //   create: (_) => , // Pass UserProvider instance here
        // ),
        ChangeNotifierProxyProvider<UserProvider, JobMatchingProvider>(
          create: (context) => JobMatchingProvider(context.read<UserProvider>()),
          update: (context, userProvider, previousJobMatchingProvider) =>
              previousJobMatchingProvider ?? JobMatchingProvider(userProvider),
        ),
         ChangeNotifierProxyProvider<UserProvider, MatchingProvider>(
      create: (context) => MatchingProvider(context.read<UserProvider>()),
      update: (context, userProvider, matchingProvider) => 
        matchingProvider ?? MatchingProvider(userProvider),
    ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'HealthWealth',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: auth.currentUser == null?LoginScreen():MainLayoutScreen(),
        //home: auth.currentUser == null?LoginScreen():PrescriptionFormScreen(doctorId: 'lUoJzE4iXrVAvJudsCHwUwVjfPB2',patientId: 'UrE9uj9csBeqPeMF2UwWEjzTMBJ2'),
        // home: auth.currentUser == null?LoginScreen():MedicineSelectionDialog(),
      ),
    );
  }
}


