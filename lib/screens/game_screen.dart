import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:void_quest/controllers/video_controller.dart';
import 'package:void_quest/services/timer_service.dart';
import 'package:void_quest/controllers/gesture_handler.dart';
import 'package:void_quest/services/distractions.dart';
import 'package:void_quest/widgets/fake_tap_prompt.dart';
import 'package:void_quest/widgets/rotating_banner_ad.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  GameScreenState createState() => GameScreenState();
}

class GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {
  VideoPlayerController? _videoController;
  late TimerService _timerService;
  late GestureHandler _gestureHandler;
  late DistractionManager _distractionManager;
  bool _showFakePrompt = false;

  @override
  void initState() {
    super.initState();
    _initAsync();
    _timerService = TimerService(onTick: () {
      if (mounted) setState(() {});
    })
      ..start();

    _gestureHandler = GestureHandler(
      onLose: (reason) => _timerService.loseGame(context, reason),
    );

    _distractionManager = DistractionManager(
      context: context,
      onFakeTapPrompt: () {
        if (!mounted) return;
        setState(() => _showFakePrompt = true);
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) setState(() => _showFakePrompt = false);
        });
      },
    );
    _distractionManager.start();
  }

  Future<void> _initAsync() async {
    final controller = await setupVideoController();
    if (mounted) {
      setState(() {
        _videoController = controller;
      });
    }
  }

  @override
  void dispose() {
    _distractionManager.dispose();
    _timerService.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _gestureHandler.onTap,
      onDoubleTap: _gestureHandler.onDoubleTap,
      onLongPress: _gestureHandler.onLongPress,
      onPanStart: (_) => _gestureHandler.onPanStart(),
      onPanUpdate: (_) => _gestureHandler.onPanUpdate(),
      onVerticalDragStart: (_) => _gestureHandler.onVerticalDragStart(),
      onHorizontalDragStart: (_) => _gestureHandler.onHorizontalDragStart(),
      onScaleStart: (_) => _gestureHandler.onScaleStart(),
      onSecondaryTap: _gestureHandler.onSecondaryTap,
      onTertiaryTapDown: (_) => _gestureHandler.onTertiaryTap(),
      child: PopScope(
        canPop: false,
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              if (_videoController?.value.isInitialized == true)
                Positioned.fill(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _videoController!.value.size.width,
                      height: _videoController!.value.size.height,
                      child: VideoPlayer(_videoController!),
                    ),
                  ),
                ),
              if (_showFakePrompt) const FakeTapPrompt(),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _glassContainer(
                      text: "TIME YOU DID NOTHING",
                      fontSize: 24,
                      alpha: 20,
                    ),
                    const SizedBox(height: 12),
                    _glassContainer(
                      text: formatTime(_timerService.seconds),
                      fontSize: 48,
                      alpha: 70,
                      width: 220,
                    ),
                  ],
                ),
              ),
              const RotatingBannerAd(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _glassContainer({
    required String text,
    required double fontSize,
    required int alpha,
    double? width,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          width: width,
          decoration: BoxDecoration(
            color: Colors.black.withAlpha(alpha),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: fontSize,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}
