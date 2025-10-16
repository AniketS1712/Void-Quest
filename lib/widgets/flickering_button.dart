import 'dart:math';
import 'package:flutter/material.dart';

class FlickeringButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;

  const FlickeringButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  State<FlickeringButton> createState() => _FlickeringButtonState();
}

class _FlickeringButtonState extends State<FlickeringButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _flickerController;
  late final Random _random;
  @override
  void initState() {
    super.initState();
    _random = Random();
    _flickerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _flickerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _flickerController,
      builder: (_, child) {
        double opacity = 0.7 + _random.nextDouble() * 0.3;
        return Opacity(
          opacity: opacity,
          child: child,
        );
      },
      child: GestureDetector(
        onTap: widget.onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white70, width: 1.5),
            borderRadius: BorderRadius.circular(8),
            color: Colors.white.withAlpha(20),
          ),
          child: Text(
            widget.label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              letterSpacing: 2,
            ),
          ),
        ),
      ),
    );
  }
}