import 'dart:async';
import 'package:flutter/material.dart';
import 'screens/game_screen.dart';

void main() {
  runZonedGuarded(() {
    WidgetsFlutterBinding.ensureInitialized();
    runApp(const PuzzleApp());
  }, (error, stack) {
    debugPrint("Unhandled Error: $error");
    debugPrintStack(stackTrace: stack);
  });
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
      title: '8 Puzzle ', 
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: GameScreen(toggleTheme: toggleTheme),
    );
  }
}