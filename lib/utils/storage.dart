import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  static Future<int> getBestTime(int level) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('best_time_$level') ?? 99999;
  }

  // ================= BEST MOVES =================
  static Future<int> getBestMoves(int level) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('best_moves_$level') ?? 99999;
  }

  // ================= WIN STREAK =================
  static Future<int> getWinStreak() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('win_streak') ?? 0;
  }

  static Future<void> incrementWinStreak() async {
    final prefs = await SharedPreferences.getInstance();
    int streak = prefs.getInt('win_streak') ?? 0;
    await prefs.setInt('win_streak', streak + 1);
  }

  // ================= SAVE BEST SCORE =================
  static Future<void> saveBestScore(
    int level,
    int seconds,
    int moves,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    final timeKey = 'best_time_$level';
    final moveKey = 'best_moves_$level';

    int bestTime = prefs.getInt(timeKey) ?? 99999;
    int bestMoves = prefs.getInt(moveKey) ?? 99999;

    if (seconds > 0 && seconds < bestTime) {
      await prefs.setInt(timeKey, seconds);
    }

    if (moves < bestMoves) {
      await prefs.setInt(moveKey, moves);
    }
  }

  // ================= TOTAL TIME =================
  static Future<int> getTotalTime(int level) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('total_time_$level') ?? 0;
  }

  static Future<void> addTotalTime(int level, int seconds) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'total_time_$level';
    int total = prefs.getInt(key) ?? 0;
    await prefs.setInt(key, total + seconds);
  }

  // ================= TOTAL MOVES =================
  static Future<int> getTotalMoves(int level) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('total_moves_$level') ?? 0;
  }

  static Future<void> addTotalMoves(int level, int moves) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'total_moves_$level';
    int total = prefs.getInt(key) ?? 0;
    await prefs.setInt(key, total + moves);
  }

  // ================= BEST EFFICIENCY =================
  static Future<int> getBestEfficiency(int level) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('best_efficiency_$level') ?? 0;
  }

  static Future<void> saveEfficiency(int level, int efficiency) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'best_efficiency_$level';
    int old = prefs.getInt(key) ?? 0;
    if (efficiency > old) {
      await prefs.setInt(key, efficiency);
    }
  }

  // ================= RESET =================
  static Future<void> resetAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
