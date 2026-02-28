import 'dart:math';

class GameEngine {
  final int size; // 3 or 4
  late List<int> tiles;
  int moves = 0;

  GameEngine({required this.size}) {
    _createSolvedBoard();
    shuffle();
  }

  // =========================
  // CREATE SOLVED BOARD
  // =========================
  void _createSolvedBoard() {
    tiles = List.generate(size * size, (i) {
      if (i == size * size - 1) return 0;
      return i + 1;
    });
    moves = 0;
  }

  // =========================
  // SOLVABLE SHUFFLE
  // =========================
  void shuffle() {
    _createSolvedBoard();

    final random = Random();
    int emptyIndex = tiles.indexOf(0);

    // Perform many valid random moves
    for (int i = 0; i < 1000; i++) {
      List<int> neighbors = _getMovableTiles(emptyIndex);
      int swapIndex = neighbors[random.nextInt(neighbors.length)];

      _swap(emptyIndex, swapIndex);
      emptyIndex = swapIndex;
    }

    moves = 0;
  }

  // =========================
  // CHECK IF SOLVED
  // =========================
  bool get isSolved {
    for (int i = 0; i < tiles.length - 1; i++) {
      if (tiles[i] != i + 1) return false;
    }
    return tiles.last == 0;
  }

  // =========================
  // MOVE TILE
  // =========================
  void moveTile(int index) {
    int emptyIndex = tiles.indexOf(0);

    if (_getMovableTiles(emptyIndex).contains(index)) {
      _swap(index, emptyIndex);
      moves++;
    }
  }

  // =========================
  // SWAP TILES
  // =========================
  void _swap(int i, int j) {
    int temp = tiles[i];
    tiles[i] = tiles[j];
    tiles[j] = temp;
  }

  // =========================
  // GET VALID NEIGHBORS
  // =========================
  List<int> _getMovableTiles(int emptyIndex) {
    int row = emptyIndex ~/ size;
    int col = emptyIndex % size;

    List<int> neighbors = [];

    if (row > 0) neighbors.add(emptyIndex - size);        // up
    if (row < size - 1) neighbors.add(emptyIndex + size); // down
    if (col > 0) neighbors.add(emptyIndex - 1);           // left
    if (col < size - 1) neighbors.add(emptyIndex + 1);    // right

    return neighbors;
  }
}