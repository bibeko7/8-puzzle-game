import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  static Future<void> saveBestScore(int seconds, int moves) async {
    final prefs = await SharedPreferences.getInstance();

    int bestTime = prefs.getInt("best_time") ?? 9999;
    int bestMoves = prefs.getInt("best_moves") ?? 9999;

    if (seconds < bestTime) {
      await prefs.setInt("best_time", seconds);
    }

    if (moves < bestMoves) {
      await prefs.setInt("best_moves", moves);
    }
  }

  static Future<int> getBestTime() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt("best_time") ?? 0;
  }

  static Future<int> getBestMoves() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt("best_moves") ?? 0;
  }

  static Future<int> getWinStreak() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt("win_streak") ?? 0;
  }

  static Future<void> incrementWinStreak() async {
    final prefs = await SharedPreferences.getInstance();
    int streak = prefs.getInt("win_streak") ?? 0;
    await prefs.setInt("win_streak", streak + 1);
  }
}