import 'package:collection/collection.dart';

class Node {
  List<int> board;
  int g;
  int h;
  Node? parent;

  Node(this.board, this.g, this.h, this.parent);

  int get f => g + h;
}

class AStarSolver {

  // ⭐ MAIN SOLVE FUNCTION
  List<List<int>> solve(List<int> start) {

    // ❌ Disable solver for 4x4 (15 puzzle too heavy)
    if (start.length != 9) {
      return [];
    }

    List<int> goal = [1,2,3,4,5,6,7,8,0];

    int manhattan(List<int> board) {
      int dist = 0;
      for (int i = 0; i < board.length; i++) {
        int val = board[i];
        if (val == 0) continue;
        int targetRow = (val - 1) ~/ 3;
        int targetCol = (val - 1) % 3;
        int row = i ~/ 3;
        int col = i % 3;
        dist += (row - targetRow).abs() + (col - targetCol).abs();
      }
      return dist;
    }

    final open = PriorityQueue<Node>((a, b) => a.f.compareTo(b.f));
    final visited = <String>{};

    open.add(Node(start, 0, manhattan(start), null));

    while (open.isNotEmpty) {
      Node current = open.removeFirst();

      if (current.board.toString() == goal.toString()) {
        List<List<int>> path = [];
        Node? node = current;
        while (node != null) {
          path.insert(0, node.board);
          node = node.parent;
        }
        return path;
      }

      visited.add(current.board.toString());

      int zero = current.board.indexOf(0);
      int row = zero ~/ 3;
      int col = zero % 3;

      List<int> moves = [];
      if (row > 0) moves.add(-3);
      if (row < 2) moves.add(3);
      if (col > 0) moves.add(-1);
      if (col < 2) moves.add(1);

      for (int m in moves) {
        List<int> next = List.from(current.board);
        next[zero] = next[zero + m];
        next[zero + m] = 0;

        if (visited.contains(next.toString())) continue;

        open.add(Node(next, current.g + 1, manhattan(next), current));
      }
    }

    return [];
  }
}