import 'game_engine.dart';

class GameController {
  late GameEngine engine;

  int seconds = 0;
  bool _timerRunning = false;

  GameController(int size) {
    engine = GameEngine(size: size);
    startTimer();
  }

  // ▶️ START TIMER
  void startTimer() {
    seconds = 0;
    _timerRunning = true;
    _tick();
  }

  // ⏱ Timer loop
  void _tick() async {
    while (_timerRunning) {
      await Future.delayed(const Duration(seconds: 1));
      seconds++;
    }
  }

  // 🧩 MOVE TILE
  void moveTile(int index) {
    engine.moveTile(index);
  }

  // 🎉 CHECK WIN
  bool get isGameOver => engine.isSolved;

  // 🔄 RESET GAME (used when shuffle / difficulty change)
  void resetGame(int size) {
    _timerRunning = false; // stop old timer
    engine = GameEngine(size: size);
    engine.shuffle();
    startTimer(); // start fresh timer
  }
}