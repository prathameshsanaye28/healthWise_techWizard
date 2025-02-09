import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthwise/models/doctor.dart';
import 'package:healthwise/models/match_details.dart';
import 'package:healthwise/resources/matcher_service.dart';
import 'package:healthwise/resources/user_provider.dart';

class MatchingProvider with ChangeNotifier {
  final DoctorMatcherService _matcherService = DoctorMatcherService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  UserProvider _userProvider;
  bool _isLoading = false;
  List<ScoredDoctor> _matches = [];

  MatchingProvider(this._userProvider) {
    _initializeProvider();
  }

  void _initializeProvider() {
    _userProvider.removeListener(_onUserChanged);
    _userProvider.addListener(_onUserChanged);
    
    if (_userProvider.getUser != null) {
      findMatches();
    }
  }

  Doctor? get currentProfile => _userProvider.getUser;
  List<ScoredDoctor> get matches => _matches;
  bool get isLoading => _isLoading;

  void _onUserChanged() {
    if (_userProvider.getUser != null) {
      findMatches();
    } else {
      _matches.clear();
      notifyListeners();
    }
  }

  Future<void> updateProfile(Doctor updatedProfile) async {
    await _userProvider.refreshUser(updatedProfile);
    notifyListeners();
    await findMatches();
  }

  Future<void> findMatches() async {
    final currentUser = _userProvider.getUser;
    if (currentUser == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      final candidates = await _fetchCandidatesFromFirebase(currentUser.id!);
      _matches = await _matcherService.findMatches(currentUser, candidates);
      _matches.sort((a, b) => b.score.compareTo(a.score));
    } catch (e) {
      print('Error finding matches: $e');
      _matches = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<Doctor>> _fetchCandidatesFromFirebase(String currentUserId) async {
    try {
      // Query all users except the current user
      final QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'Doctor')
          .where(FieldPath.documentId, isNotEqualTo: currentUserId)
          .get();

      return querySnapshot.docs
          .map((doc) => Doctor.fromSnap(doc))
          .toList();
    } catch (e) {
      print('Error fetching candidates from Firebase: $e');
      return [];
    }
  }

  @override
  void dispose() {
    _userProvider.removeListener(_onUserChanged);
    super.dispose();
  }
}