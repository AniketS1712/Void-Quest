import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:void_quest/screens/home_screen.dart';
import 'package:void_quest/screens/leaderboard_screen.dart';
import 'screens/game_screen.dart';
import 'screens/lose_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  await MobileAds.instance.initialize();
  runApp(VoidQuestApp());
}

class VoidQuestApp extends StatelessWidget {
  const VoidQuestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/home',
      routes: {
        '/home': (context) => HomeScreen(),
        '/game': (context) => GameScreen(),
        '/lose': (context) => LoseScreen(),
        '/leaderboard': (context) => LeaderboardScreen(),
      },
    );
  }
}
