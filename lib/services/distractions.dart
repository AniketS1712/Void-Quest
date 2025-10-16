import 'package:flutter/material.dart';
import 'package:void_quest/distractions/ad_distractions.dart';
import 'package:void_quest/distractions/flicker_distraction.dart';
import 'package:void_quest/distractions/fake_tap_prompt_distraction.dart';
import 'package:void_quest/distractions/screen_glitch_distraction.dart';
import 'package:void_quest/distractions/green_line_distraction.dart';
import 'package:void_quest/utils/random_distraction_scheduler.dart';

typedef VoidCallback = void Function();

class Distraction {
  final Future<void> Function() run;
  final bool allowRepeat;
  final bool allowOverlap;

  Distraction({
    required this.run,
    this.allowRepeat = false,
    this.allowOverlap = false,
  });
}

class DistractionManager {
  final BuildContext context;
  final VoidCallback onFakeTapPrompt;
  late final RandomDistractionScheduler _scheduler;

  DistractionManager({
    required this.context,
    required this.onFakeTapPrompt,
  }) {
    _scheduler = RandomDistractionScheduler(
      distractions: [
        Distraction(
          run: () => adDistraction(context),
          allowRepeat: true,
          allowOverlap: false,
        ),
        Distraction(
          run: () => flickerDistraction(context),
          allowRepeat: true,
          allowOverlap: false,
        ),
        Distraction(
          run: () => fakeTapPromptDistraction(context, onFakeTapPrompt),
          allowRepeat: true,
          allowOverlap: true,
        ),
        Distraction(
          run: () => screenGlitchDistraction(context),
          allowRepeat: false,
          allowOverlap: false,
        ),
        Distraction(
          run: () => greenLineDistraction(context),
          allowRepeat: false,
          allowOverlap: true,
        ),
      ],
    );
  }

  void start() => _scheduler.start();
  void dispose() => _scheduler.dispose();
}