import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          'Leaderboard',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('leaderboard')
            .orderBy('score', descending: true)
            .limit(10)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: Colors.white));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No scores yet!',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            );
          }

          final leaderboard = snapshot.data!.docs;

          return ListView.builder(
            itemCount: leaderboard.length,
            itemBuilder: (context, index) {
              final data = leaderboard[index].data() as Map<String, dynamic>;
              final name = data['name'] ?? 'Unknown';
              final score = data['score'] ?? 0;

              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: ListTile(
                    leading: Text(
                      '#${index + 1}',
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    title: Text(
                      name,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    trailing: Text(
                      '$score',
                      style: const TextStyle(
                          color: Colors.greenAccent, fontSize: 18),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
