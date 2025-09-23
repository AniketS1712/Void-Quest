import 'dart:math';
import 'package:flutter/material.dart';
import 'package:void_quest/services/submit_score.dart';

class LoseScreen extends StatefulWidget {
  const LoseScreen({super.key});

  @override
  State<LoseScreen> createState() => _LoseScreenState();
}

class _LoseScreenState extends State<LoseScreen> with TickerProviderStateMixin {
  late AnimationController _glitchController;
  late AnimationController _fadeController;

  @override
  void initState() {
    super.initState();

    _glitchController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
  }

  @override
  void dispose() {
    _glitchController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Positioned.fill(child: CustomPaint(painter: _ScanlinePainter())),
            Center(
              child: FadeTransition(
                opacity: _fadeController,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _GlitchTitle(controller: _glitchController),
                    const SizedBox(height: 30),
                    Text(
                      args['reason'],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "You survived ${args['time']} seconds.",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        letterSpacing: 1.3,
                      ),
                    ),
                    const SizedBox(height: 50),
                    _GlitchButton(
                      label: "RETRY",
                      onPressed: () =>
                          Navigator.pushReplacementNamed(context, '/home'),
                    ),
                    const SizedBox(height: 26),
                    _GlitchButton(
                      label: "LEADERBOARD",
                      onPressed: () => Navigator.pushReplacementNamed(
                          context, '/leaderboard'),
                    ),
                    const SizedBox(height: 26),
                    _GlitchButton(
                        label: "Submit Score",
                        onPressed: () => submitScore(context, args['time']))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GlitchTitle extends StatelessWidget {
  final AnimationController controller;
  const _GlitchTitle({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        final rand = Random();
        final dx = rand.nextDouble() * 4 - 2;
        final dy = rand.nextDouble() * 2 - 1;

        return Stack(
          children: [
            Transform.translate(
              offset: Offset(dx, dy),
              child: Text(
                "YOU LOST",
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                ),
              ),
            ),
            Transform.translate(
              offset: Offset(-dx * 1.5, dy),
              child: Text(
                "YOU LOST",
                style: TextStyle(
                  color: Colors.white.withAlpha(25),
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                ),
              ),
            ),
            Transform.translate(
              offset: Offset(dx * 1.2, -dy),
              child: Text(
                "YOU LOST",
                style: TextStyle(
                  color: Colors.blueAccent.withAlpha(25),
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _GlitchButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _GlitchButton({
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(12),
            border: Border.all(color: Colors.white60),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.red.withAlpha(50),
                blurRadius: 10,
                spreadRadius: 1,
              )
            ],
          ),
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              letterSpacing: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}

class _ScanlinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red.withAlpha(6)
      ..strokeWidth = 1;

    for (double y = 0; y < size.height; y += 4) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
