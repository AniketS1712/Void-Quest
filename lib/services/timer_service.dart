import 'dart:async';
import 'package:flutter/material.dart';

class TimerService {
  int seconds = 0;
  Timer? _timer;
  final VoidCallback onTick;
  bool _hasLost = false;

  TimerService({required this.onTick});

  void start() {
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      seconds++;
      onTick();
    });
  }

  void loseGame(BuildContext context, String reason) {
    if (_hasLost) return;
    _hasLost = true;
    _timer?.cancel();
    Navigator.pushReplacementNamed(context, '/lose', arguments: {
      'time': seconds,
      'reason': reason,
    });
  }

  void dispose() {
    _timer?.cancel();
  }
}

String formatTime(int totalSeconds) {
  final duration = Duration(seconds: totalSeconds);
  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60);
  final secs = duration.inSeconds.remainder(60);

  String twoDigits(int n) => n.toString().padLeft(2, '0');

  if (hours > 0) {
    return "${twoDigits(hours)}:${twoDigits(minutes)}:${twoDigits(secs)}";
  } else if (minutes > 0) {
    return "${twoDigits(minutes)}:${twoDigits(secs)}";
  } else {
    return secs.toString();
  }
}
