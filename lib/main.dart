import 'package:flutter/material.dart';
import 'screens/game_screen.dart';

void main() {
  runApp(const PuzzleApp());
}

class PuzzleApp extends StatefulWidget {
  const PuzzleApp({super.key});

  @override
  State<PuzzleApp> createState() => _PuzzleAppState();
}

class _PuzzleAppState extends State<PuzzleApp> {
  bool isDark = false;

  void toggleTheme() {
    setState(() {
      isDark = !isDark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: GameScreen(toggleTheme: toggleTheme),
    );
  }
}