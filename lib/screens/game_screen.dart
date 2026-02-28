import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';

import '../logic/game_controller.dart';
import '../logic/solver_astar.dart';
import '../widgets/tile_widget.dart';
import '../utils/storage.dart';

class GameScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  const GameScreen({super.key, required this.toggleTheme});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {

  // ⭐ TIMER (correct place)
  Timer? _timer;

  int gridSize = 3;
  late GameController controller;
  late AudioPlayer _player;

  int bestTime = 0;
  int bestMoves = 0;
  int winStreak = 0;

  // ================= INIT =================
 @override
void initState() {
  super.initState();

  _player = AudioPlayer();
  _player.setReleaseMode(ReleaseMode.stop); // ⭐ important

  _startNewGame();
  _loadStats();
}

  // ================= START NEW GAME =================
  void _startNewGame() {
    _timer?.cancel(); // stop old timer

    controller = GameController(gridSize);
    controller.resetGame(gridSize);

    _startUITimer(); // start ONE timer only
    setState(() {});
  }

  // ================= TIMER =================
  void _startUITimer() {
  _timer?.cancel();

  _timer = Timer.periodic(const Duration(seconds: 1), (_) {
    if (!mounted) return;

    controller.seconds++;   // ⭐ THIS was missing
    setState(() {});
  });
}

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // ================= LOAD STATS =================
  Future<void> _loadStats() async {
    bestTime = await Storage.getBestTime();
    bestMoves = await Storage.getBestMoves();
    winStreak = await Storage.getWinStreak();
    setState(() {});
  }

  // ================= TILE TAP =================
  void onTileTap(int index) async {
  setState(() => controller.moveTile(index));

  // ⭐ FIX SOUND BUG
  await _player.stop(); // stop previous sound
  await _player.play(AssetSource('move.mp3'));

  if (controller.isGameOver) {
    _showWinDialog();
  }
}

  // ================= AUTO SOLVER (3x3 only) =================
  Future<void> autoSolve() async {
    if (gridSize == 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Auto solver available only for 3×3 Easy mode 😉"),
        ),
      );
      return;
    }

    AStarSolver solver = AStarSolver();
    List<List<int>> path = solver.solve(controller.engine.tiles);

    for (var state in path) {
      await Future.delayed(const Duration(milliseconds: 250));
      setState(() => controller.engine.tiles = state);
    }
  }

  // ================= WIN DIALOG =================
  void _showWinDialog() async {
    int moves = controller.engine.moves;
    int seconds = controller.seconds;

    String time =
        "${(seconds ~/ 60).toString().padLeft(2, '0')}:${(seconds % 60).toString().padLeft(2, '0')}";

    int optimalMoves = gridSize == 3 ? 20 : 80;
    int efficiency = ((optimalMoves / moves) * 100).clamp(5, 100).toInt();

    await Storage.saveBestScore(seconds, moves);
    await Storage.incrementWinStreak();
    await _loadStats();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text("🎉 You Win!"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(gridSize == 4 ? "Mode: HARD 4×4 🔥" : "Mode: EASY 3×3"),
            const SizedBox(height: 8),
            Text("⏱ Time: $time"),
            Text("🎯 Moves: $moves"),
            Text("⚡ Efficiency: $efficiency%"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _startNewGame();
            },
            child: const Text("Play Again"),
          ),
        ],
      ),
    );
  }

  // ================= BUILD =================
  @override
  Widget build(BuildContext context) {
    var tiles = controller.engine.tiles;

    String time =
        "${(controller.seconds ~/ 60).toString().padLeft(2, '0')}:${(controller.seconds % 60).toString().padLeft(2, '0')}";

    return Scaffold(
      appBar: AppBar(
        title: const Text("8 Puzzle"),
        actions: [
          IconButton(
            icon: const Icon(Icons.dark_mode),
            onPressed: widget.toggleTheme,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            // difficulty buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () { gridSize = 3; _startNewGame(); },
                  child: const Text("3×3 Easy"),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () { gridSize = 4; _startNewGame(); },
                  child: const Text("4×4 Hard"),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: gridSize == 4 ? Colors.red : Colors.green,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                gridSize == 4 ? "HARD MODE 4×4 🔥" : "EASY MODE 3×3",
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 10),

            Text(
              "$time   Moves: ${controller.engine.moves}\nBest: ${bestTime}s | $bestMoves moves | 🔥 $winStreak",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: GridView.builder(
                itemCount: gridSize * gridSize,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: gridSize,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemBuilder: (context, index) {
                  return TileWidget(
                    number: tiles[index],
                    onTap: () => onTileTap(index),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: _startNewGame, child: const Text("Shuffle")),
                ElevatedButton(onPressed: autoSolve, child: const Text("Auto Solve 🤖")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}