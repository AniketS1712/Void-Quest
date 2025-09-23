import 'dart:async';
import 'dart:math';
import 'package:void_quest/services/distractions.dart';

class RandomDistractionScheduler {
  final List<Distraction> distractions;
  final int minSeconds;
  final int maxSeconds;

  bool _isRunning = false;
  final Set<Distraction> _activeDistractions = {};
  final Random _random = Random();
  Distraction? _lastDistraction;

  RandomDistractionScheduler({
    required this.distractions,
    this.minSeconds = 0,
    this.maxSeconds = 20,
  });

  void start({int initialDelaySeconds = 10}) {
    if (_isRunning) return;
    _isRunning = true;
    Future.delayed(Duration(seconds: initialDelaySeconds), _scheduleNext);
  }

  void _scheduleNext() async {
    if (!_isRunning) return;

    final waitTime = _random.nextInt(maxSeconds - minSeconds + 1) + minSeconds;
    await Future.delayed(Duration(seconds: waitTime));

    if (!_isRunning) return;

    await _runRandomDistraction();
    if (_isRunning) _scheduleNext();
  }

  Future<void> _runRandomDistraction() async {
    final isBlocked = _activeDistractions.any((d) => !d.allowOverlap);
    if (isBlocked) return;

    var candidates = distractions;

    if (_lastDistraction != null && !_lastDistraction!.allowRepeat) {
      candidates = distractions.where((d) => d != _lastDistraction).toList();
    }

    if (candidates.isEmpty) return;

    final selected = candidates[_random.nextInt(candidates.length)];
    _lastDistraction = selected;
    _activeDistractions.add(selected);

    try {
      await selected.run();
    } catch (_) {
    } finally {
      _activeDistractions.remove(selected);
    }
  }

  void stop() => _isRunning = false;
  void dispose() => stop();
}
