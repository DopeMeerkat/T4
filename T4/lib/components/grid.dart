import 'move.dart';

//TODO implement history/undo functions
class Grid {
  List<List<Move>> grid; //list of rows (first list is y axis, second is x)
  int inARow;
  
  int turn;
  List<Move> player;

  Grid(row, col, this.inARow) {
    grid = List.generate(row, (i) => new List.filled(col, Move.empty));
    setTurn(0);
    player = List<Move>();
    player.add(Move.x);
    player.add(Move.o);
  }

  Grid.normal() : this(3, 3, 3);

  void setTurn(int _turn) {
    turn = _turn;
  }

  int rows() {
    return grid[0].length;
  }

  int cols() {
    return grid.length;
  }

  // 0 - Left
  // 1 - Right
  // 2 - Top
  // 3 - Bot
  void extend(int dir) {
    switch (dir) {
      case 0:
        grid.forEach((row) => row.insert(0, Move.empty));
        break;
      case 1:
        grid.forEach((row) => row.add(Move.empty));
        break;
      case 2:
        grid.insert(0, List<Move>.filled(cols(), Move.empty));
        break;
      case 3:
        grid.add(List<Move>.filled(cols(), Move.empty));
        break;
    }
  }

  bool checkWin() {
    return false;
  }

  bool move(int x, y) {
    if (grid[x][y] == Move.empty) {
      grid[x][y] = player[turn % 2];
      return true;
    }
    return false;
  }

  bool block(int x1, y1, x2, y2) {
    if (grid[x1][y1] == Move.empty && grid[x2][y2] == Move.empty) {
      grid[x1][y1] = Move.block;
      grid[x2][y2] = Move.block;
      return true;
    }
    return false;
  }
}
