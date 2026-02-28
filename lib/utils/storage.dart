import 'package:shared_preferences/shared_preferences.dart';

class Storage {

  // ================= BEST TIME =================
  static Future<int> getBestTime() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('best_time') ?? 99999; // ⭐ default large value
  }

  // ================= BEST MOVES =================
  static Future<int> getBestMoves() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('best_moves') ?? 99999; // ⭐ default large value
  }

  // ================= WIN STREAK =================
  static Future<int> getWinStreak() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('win_streak') ?? 0;
  }

  // ================= SAVE BEST SCORE =================
  static Future<void> saveBestScore(int seconds, int moves) async {
    final prefs = await SharedPreferences.getInstance();

    int bestTime = prefs.getInt('best_time') ?? 99999;
    int bestMoves = prefs.getInt('best_moves') ?? 99999;

    // ⭐ FIX 1: ignore zero time (happens when timer bug)
    if (seconds > 0 && seconds < bestTime) {
      await prefs.setInt('best_time', seconds);
    }

    // ⭐ FIX 2: always update moves if better
    if (moves < bestMoves) {
      await prefs.setInt('best_moves', moves);
    }
  }

  // ================= WIN STREAK =================
  static Future<void> incrementWinStreak() async {
    final prefs = await SharedPreferences.getInstance();
    int streak = prefs.getInt('win_streak') ?? 0;
    await prefs.setInt('win_streak', streak + 1);
  }

  // ⭐ OPTIONAL RESET (for testing)
  static Future<void> resetAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}