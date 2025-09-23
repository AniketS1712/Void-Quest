import 'package:video_player/video_player.dart';

Future<VideoPlayerController> setupVideoController() async {
  final controller =
      VideoPlayerController.asset('assets/videos/background.mp4');
  await controller.initialize();
  controller.setLooping(true);
  controller.play();
  return controller;
}
