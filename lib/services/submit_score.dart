import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> submitScore(BuildContext context, int score) async {
  String playerName = "";

  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text('Enter Your Name',
            style: TextStyle(color: Colors.white)),
        content: TextField(
          onChanged: (value) => playerName = value.trim(),
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Player Name',
            hintStyle: TextStyle(color: Colors.white54),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white24),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Submit',
                style: TextStyle(color: Colors.greenAccent)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );

  if (playerName.isEmpty) return;

  await FirebaseFirestore.instance.collection('leaderboard').add({
    'name': playerName,
    'score': score,
    'timestamp': FieldValue.serverTimestamp(),
  });
}