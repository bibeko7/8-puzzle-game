import 'dart:math';

class GameEngine {
  int size; // 3 or 4
  late List<List<int>> tiles;
  int moves = 0;

  GameEngine({this.size = 3}) {
    reset();
  }

  void reset() {
    moves = 0;
    tiles = List.generate(size, (i) =>
        List.generate(size, (j) =>
            (i * size + j + 1) % (size * size)));
  }

  bool canMove(int r, int c) {
    int emptyR = 0, emptyC = 0;
    for (int i = 0; i < size; i++) {
      for (int j = 0; j < size; j++) {
        if (tiles[i][j] == 0) {
          emptyR = i;
          emptyC = j;
        }
      }
    }

    return (r == emptyR && (c - emptyC).abs() == 1) ||
        (c == emptyC && (r - emptyR).abs() == 1);
  }

  void move(int r, int c) {
    int emptyR = 0, emptyC = 0;
    for (int i = 0; i < size; i++) {
      for (int j = 0; j < size; j++) {
        if (tiles[i][j] == 0) {
          emptyR = i;
          emptyC = j;
        }
      }
    }

    if (canMove(r, c)) {
      tiles[emptyR][emptyC] = tiles[r][c];
      tiles[r][c] = 0;
      moves++;
    }
  }

  void shuffle() {
    final rand = Random();
    for (int i = 0; i < 200; i++) {
      int r = rand.nextInt(size);
      int c = rand.nextInt(size);
      if (canMove(r, c)) move(r, c);
    }
    moves = 0;
  }

  bool isSolved() {
    int count = 1;
    for (int i = 0; i < size; i++) {
      for (int j = 0; j < size; j++) {
        if (tiles[i][j] != count % (size * size)) return false;
        count++;
      }
    }
    return true;
  }
}