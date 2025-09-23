import 'dart:math';
import 'package:flutter/material.dart';

Future<void> screenGlitchDistraction(BuildContext context) async {
  final overlay = Overlay.of(context);

  final size = MediaQuery.of(context).size;
  final centerX = size.width / 2;
  final centerY = size.height / 2;
  final random = Random();

  final glitchBars = List.generate(100, (index) {
    double left, top;

    if (index < 50) {
      // Clustered around center
      left = centerX + (random.nextDouble() - 0.5) * size.width * 0.4;
      top = centerY + (random.nextDouble() - 0.5) * size.height * 0.4;
    } else {
      // Random full-screen
      left = random.nextDouble() * size.width;
      top = random.nextDouble() * size.height;
    }

    final width = random.nextDouble() * 100 + 20;
    final height = random.nextDouble() * 10 + 5;

    final color = Colors.primaries[random.nextInt(Colors.primaries.length)]
        .withAlpha(180);

    return Positioned(
      left: left.clamp(0, size.width - width),
      top: top.clamp(0, size.height - height),
      child: Container(
        width: width,
        height: height,
        color: color,
      ),
    );
  });

  final entry = OverlayEntry(
    builder: (_) => Positioned.fill(
      child: IgnorePointer(
        child: Stack(children: glitchBars),
      ),
    ),
  );

  overlay.insert(entry);
  await Future.delayed(const Duration(seconds: 8));
  entry.remove();
}
