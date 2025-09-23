import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:void_quest/widgets/flickering_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _titleGlitchController;
  late Timer _greenLineTimer;
  bool _showGreenLine = false;
  double _greenLineX = 0.0;
  late final Random _random;

  @override
  void initState() {
    super.initState();
    _random = Random();

    _titleGlitchController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);

    _startGreenLineCycle();
  }

  void _startGreenLineCycle() {
    _greenLineTimer = Timer.periodic(const Duration(seconds: 20), (_) {
      setState(() {
        _greenLineX = _random.nextDouble() * MediaQuery.of(context).size.width;
        _showGreenLine = true;
      });

      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _showGreenLine = false;
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _titleGlitchController.dispose();
    _greenLineTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          if (_showGreenLine)
            Align(
              alignment: Alignment.topLeft,
              child: FractionallySizedBox(
                widthFactor: 0,
                child: Container(
                  margin: EdgeInsets.only(left: _greenLineX),
                  width: 1.5,
                  height: screenHeight,
                  color: Colors.greenAccent,
                ),
              ),
            ),
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: _titleGlitchController,
                  builder: (_, __) {
                    final dx = _random.nextDouble() * 2 - 1;
                    final dy = _random.nextDouble() * 2 - 1;
                    final alpha =
                        (255 * (0.85 + _random.nextDouble() * 0.1)).toInt();
                    return Transform.translate(
                      offset: Offset(dx, dy),
                      child: Text(
                        'PATIENCE VOID',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color.fromARGB(alpha, 255, 255, 255),
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 3,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  "Endure the silence. Ignore the noise.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 14,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 40),
                FlickeringButton(
                  label: "ENTER THE VOID",
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/game');
                  },
                ),
                const SizedBox(height: 32),
                FlickeringButton(
                  label: "VOID LEADERBOARD",
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/leaderboard');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
