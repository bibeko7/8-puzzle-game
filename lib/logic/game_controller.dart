import 'game_engine.dart';

class GameController {
  late GameEngine engine;

  int seconds = 0;   // time counter
  bool isGameOver = false;

  GameController(int size) {
    engine = GameEngine(size: size);
  }

  void resetGame(int size) {
    engine = GameEngine(size: size);
    seconds = 0;
    isGameOver = false;
  }

  void moveTile(int index) {
    engine.moveTile(index);

    if (engine.isSolved) {
      isGameOver = true;
    }
  }
}