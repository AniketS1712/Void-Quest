import 'dart:math';
import 'package:flutter/material.dart';

Future<void> flickerDistraction(BuildContext context) async {
  final overlay = Overlay.of(context);

  final random = Random();
  final flickerCount = random.nextInt(2) + 4;

  for (int i = 0; i < flickerCount; i++) {
    final entry = OverlayEntry(
      builder: (_) => Positioned.fill(
        child: Container(
          color: Colors.white.withAlpha(25),
        ),
      ),
    );

    overlay.insert(entry);
    await Future.delayed(const Duration(milliseconds: 100));
    entry.remove();
    await Future.delayed(
        Duration(milliseconds: 30 + random.nextInt(50)));
  }
}