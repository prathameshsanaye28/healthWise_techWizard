// challenge_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Challenge {
  final String id;
  final String title;
  final String description;
  final String badgeImageUrl;
  final int pointsAwarded;
  final DateTime startDate;
  final DateTime endDate;
  final List<String> completedUserIds;
  final String category; // e.g., 'meditation', 'breathing', 'exercise'
  final Map<String, dynamic>
      requirements; // e.g., {'daysRequired': 7, 'minutesPerDay': 10}

  Challenge({
    required this.id,
    required this.title,
    required this.description,
    required this.badgeImageUrl,
    required this.pointsAwarded,
    required this.startDate,
    required this.endDate,
    this.completedUserIds = const [],
    required this.category,
    required this.requirements,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'badgeImageUrl': badgeImageUrl,
        'pointsAwarded': pointsAwarded,
        'startDate': Timestamp.fromDate(startDate),
        'endDate': Timestamp.fromDate(endDate),
        'completedUserIds': completedUserIds,
        'category': category,
        'requirements': requirements,
      };

  static Challenge fromSnapshot(DocumentSnapshot snap) {
    var data = snap.data() as Map<String, dynamic>;
    return Challenge(
      id: snap.id,
      title: data['title'],
      description: data['description'],
      badgeImageUrl: data['badgeImageUrl'],
      pointsAwarded: data['pointsAwarded'],
      startDate: (data['startDate'] as Timestamp).toDate(),
      endDate: (data['endDate'] as Timestamp).toDate(),
      completedUserIds: List<String>.from(data['completedUserIds'] ?? []),
      category: data['category'],
      requirements: data['requirements'] ?? {},
    );
  }
}

// challenges_screen.dart

class ChallengesScreen extends StatelessWidget {
  final String userId;

  const ChallengesScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Wellness Challenges'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Active Challenges'),
              Tab(text: 'My Badges'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ActiveChallengesTab(userId: userId),
            UserBadgesTab(userId: userId),
          ],
        ),
      ),
    );
  }
}

class ActiveChallengesTab extends StatelessWidget {
  final String userId;

  const ActiveChallengesTab({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('challenges')
          .where('endDate', isGreaterThan: Timestamp.fromDate(DateTime.now()))
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        var challenges = snapshot.data!.docs
            .map((doc) => Challenge.fromSnapshot(doc))
            .toList();

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: challenges.length,
          itemBuilder: (context, index) {
            var challenge = challenges[index];
            bool isCompleted = challenge.completedUserIds.contains(userId);

            return ChallengeCard(
              challenge: challenge,
              isCompleted: isCompleted,
              userId: userId,
            );
          },
        );
      },
    );
  }
}

class ChallengeCard extends StatelessWidget {
  final Challenge challenge;
  final bool isCompleted;
  final String userId;

  const ChallengeCard({super.key, 
    required this.challenge,
    required this.isCompleted,
    required this.userId,
  });

  Future<void> _markChallengeComplete() async {
    await FirebaseFirestore.instance
        .collection('challenges')
        .doc(challenge.id)
        .update({
      'completedUserIds': FieldValue.arrayUnion([userId])
    });

    // Add badge
    await FirebaseFirestore.instance.collection('badges').add({
      'userId': userId,
      'challengeId': challenge.id,
      'awardedAt': Timestamp.now(),
      'badgeImageUrl': challenge.badgeImageUrl,
      'title': challenge.title,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(challenge.badgeImageUrl),
                  radius: 24,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        challenge.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${challenge.pointsAwarded} points',
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(challenge.description),
            const SizedBox(height: 12),
            Text(
              'Ends on: ${challenge.endDate.toString().split(' ')[0]}',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            if (!isCompleted)
              ElevatedButton(
                onPressed: _markChallengeComplete,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: Text('Mark as Complete'),
              )
            else
              Chip(
                label: const Text('Completed'),
                backgroundColor: Colors.green[100],
                labelStyle: TextStyle(color: Colors.green[900]),
              ),
          ],
        ),
      ),
    );
  }
}

class UserBadgesTab extends StatelessWidget {
  final String userId;

  const UserBadgesTab({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('badges')
          .where('userId', isEqualTo: userId)
          .orderBy('awardedAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        var badges = snapshot.data!.docs;

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: badges.length,
          itemBuilder: (context, index) {
            var badge = badges[index].data() as Map<String, dynamic>;
            return BadgeTile(
              imageUrl: badge['badgeImageUrl'],
              title: badge['title'],
              awardedAt: (badge['awardedAt'] as Timestamp).toDate(),
            );
          },
        );
      },
    );
  }
}

class BadgeTile extends StatelessWidget {
  final String imageUrl;
  final String title;
  final DateTime awardedAt;

  const BadgeTile({super.key, 
    required this.imageUrl,
    required this.title,
    required this.awardedAt,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(title),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.network(imageUrl, height: 100),
                const SizedBox(height: 16),
                Text('Earned on: ${awardedAt.toString().split(' ')[0]}'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
        );
      },
      child: Column(
        children: [
          Expanded(
            child: CircleAvatar(
              backgroundImage: NetworkImage(imageUrl),
              radius: 40,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
