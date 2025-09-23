import 'package:flutter/material.dart';

class FakeTapPrompt extends StatefulWidget {
  final VoidCallback? onTap;
  final bool ignoreInput;

  const FakeTapPrompt({
    super.key,
    this.onTap,
    this.ignoreInput = false,
  });

  @override
  State<FakeTapPrompt> createState() => _FakeTapPromptState();
}

class _FakeTapPromptState extends State<FakeTapPrompt>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnim;
  late final Animation<double> _rotationAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnim = Tween(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _rotationAnim = Tween(begin: -0.03, end: 0.03).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final prompt = AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Transform.scale(
        scale: _scaleAnim.value,
        child: Transform.rotate(
          angle: _rotationAnim.value,
          child: child,
        ),
      ),
      child: Tooltip(
        message: "Fake tap prompt",
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.redAccent, Colors.deepOrangeAccent],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.redAccent.withAlpha(180),
                blurRadius: 20,
                spreadRadius: 2,
              )
            ],
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Text(
            "TAP NOW!",
            style: TextStyle(
              fontSize: 22,
              color: Colors.white,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ),
    );

    return Positioned.fill(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 150),
          child: widget.ignoreInput
              ? IgnorePointer(child: prompt)
              : GestureDetector(onTap: widget.onTap, child: prompt),
        ),
      ),
    );
  }
}
