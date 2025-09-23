import 'dart:math';
import 'package:flutter/material.dart';

Future<void> greenLineDistraction(BuildContext context) async {
  final overlay = Overlay.of(context);

  final size = MediaQuery.of(context).size;
  final random = Random();

  final double x = random.nextDouble() * size.width;

  final entry = OverlayEntry(
    builder: (_) => Positioned(
      top: 0,
      left: x,
      child: IgnorePointer(
        child: Container(
          width: 2,
          height: size.height,
          color: Colors.greenAccent.withAlpha(125),
        ),
      ),
    ),
  );

  overlay.insert(entry);
  await Future.delayed(const Duration(minutes: 1));
  entry.remove();
}
