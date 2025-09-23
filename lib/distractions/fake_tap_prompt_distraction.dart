import 'package:flutter/material.dart';

typedef VoidCallback = void Function();

Future<void> fakeTapPromptDistraction(
    BuildContext context, VoidCallback onFakeTapPrompt) async {
  onFakeTapPrompt();
  await Future.delayed(const Duration(seconds: 15));
}
