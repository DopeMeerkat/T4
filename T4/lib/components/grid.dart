import 'move.dart';
import 'turn.dart';

//TODO implement history/undo functions

class Grid {
  List<List<Move>> grid; //list of rows (first list is y axis, second is x)
  int inARow;
  List<Turn> history;

  int turn;
  List<Move> player;

  Grid(row, col, this.inARow) {
    grid = List.generate(row, (i) => new List.filled(col, Move.empty));

    setTurn(0);

    player = List<Move>();
    player.add(Move.x);
    player.add(Move.o);

    history = List<Turn>();
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
    List<int> params = List<int>();
    params.add(dir);
    Turn currentTurn = new Turn(turn, MoveType.extend, params);
    history.add(currentTurn);
    turn++;
  }

  bool checkWinner(int x, y) {
    var col = 0, row = 0, diag = 0, rdiag = 0;
    var n = grid.length - 1;
    var player = grid[x][y];

    for (int i = 0; i < grid.length; i++) {
      if (grid[x][i] == player) col++;
      if (grid[i][y] == player) row++;
      if (grid[i][i] == player) diag++;
      if (grid[i][n - i] == player) rdiag++;
    }
    return (row == n + 1 || col == n + 1 || diag == n + 1 || rdiag == n + 1);
  }

  bool move(int x, int y) {
    if (grid[x][y] == Move.empty) {
      grid[x][y] = player[turn % 2];

      List<int> params = List<int>();
      params.add(x);
      params.add(y);
      Turn currentTurn = new Turn(turn, MoveType.move, params);
      history.add(currentTurn);
      turn++;
      printHistory();
      // print(checkWinner(x, y));
      return true;
    }
    return false;
  }

  bool block(int x1, int y1, int x2, int y2) {
    if (grid[x1][y1] == Move.empty && grid[x2][y2] == Move.empty) {
      grid[x1][y1] = Move.block;
      grid[x2][y2] = Move.block;

      List<int> params = List<int>();
      params.add(x1);
      params.add(y1);
      params.add(x2);
      params.add(y2);
      Turn currentTurn = new Turn(turn, MoveType.block, params);
      history.add(currentTurn);

      turn++;
      return true;
    }
    return false;
  }

  void printHistory() {
    print("Printing History:");
    history.forEach((element) => element.printTurn());
  }
}
