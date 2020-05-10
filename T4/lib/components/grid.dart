import 'move.dart';
import 'turn.dart';

class Grid {
  List<List<Move>> grid; //list of rows (first list is y axis, second is x)
  int inARow;
  List<Turn> history;

  int turn;
  List<Move> player;

  Grid(row, col, this.inARow) {
    grid = List.generate(
        row, (i) => new List.filled(col, Move.empty, growable: true));
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
    return grid.length;
  }

  int cols() {
    return grid[0].length;
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
        grid.insert(0, List<Move>.filled(cols(), Move.empty, growable: true));
        break;
      case 3:
        grid.add(List<Move>.filled(cols(), Move.empty, growable: true));
        break;
    }
    List<int> params = List<int>();
    params.add(dir);
    Turn currentTurn = new Turn(turn, MoveType.extend, params);
    history.add(currentTurn);
    turn++;
  }

  bool checkWinner(int r, c) {
    var hor = 0, vert = 0, slash = 0, bSlash = 0;
    var player = grid[r][c];
    // print(grid);
    var rows = grid.length;
    var cols = grid[0].length;
    var max = rows;
    if (cols > rows) max = cols;
    //slashRowStart, slashColStart, bSlash row start, bSlash col start
    var srs = 0, scs = cols - 1, bsrs = 0, bscs = 0;
    if (r < c) //find r c of bSlash
      bscs = c - r;
    else
      bsrs = r - c;

    if (r < (cols - 1 - c)) //find r c of slash
      scs = 1 + c + r;
    else
      srs = r - (cols - 1 - c);

    for (int i = 0; i < max; i++) {
      if (i < cols && grid[r][i] == player) //find horizontal
        hor++;
      else if (hor < inARow) hor = 0;

      if (i < rows && grid[i][c] == player) //find vertical
        vert++;
      else if (vert < inARow) vert = 0;

      // find backslash
      if (bsrs + i < rows &&
          bscs + i < cols &&
          grid[bsrs + i][bscs + i] == player)
        bSlash++;
      else if (bSlash < inARow) bSlash = 0;

      //find slash
      if (srs + i < rows && scs - i >= 0 && grid[srs + i][scs - i] == player)
        slash++;
      else if (slash < inARow) slash = 0;
    }

    return (vert >= inARow ||
        hor >= inARow ||
        slash >= inARow ||
        bSlash >= inARow);
  }

  bool move(int r, int c) {
    if (grid[r][c] == Move.empty) {
      grid[r][c] = player[turn % 2];

      List<int> params = List<int>();
      params.add(r);
      params.add(c);
      Turn currentTurn = new Turn(turn, MoveType.move, params);
      history.add(currentTurn);
      turn++;
      printHistory();
      if (checkWinner(r, c)) {}
      print(checkWinner(r, c));
      return true;
    }
    return false;
  }

  bool block(int r1, int c1, int r2, int c2) {
    if (grid[r1][c1] == Move.empty &&
        grid[r2][c2] == Move.empty &&
        ((r2 - r1).abs() == 1) ^ ((c2 - c1).abs() == 1)) {
      grid[r1][c1] = Move.block;
      grid[r2][c2] = Move.block;

      List<int> params = List<int>();
      params.add(r1);
      params.add(c1);
      params.add(r2);
      params.add(c2);
      Turn currentTurn = new Turn(turn, MoveType.block, params);
      history.add(currentTurn);

      turn++;
      return true;
    }
    return false;
  }

  void undo() {
    Turn recent = history.removeLast();
    switch (recent.type) {
      case MoveType.extend:
        switch (recent.params[0]) {
          // 0 - Left
          // 1 - Right
          // 2 - Top
          // 3 - Bot
          case 0:
            grid.forEach((row) => row.removeAt(0));
            break;
          case 1:
            grid.forEach((row) => row.removeLast());
            break;
          case 2:
            grid.removeAt(0);
            break;
          case 3:
            grid.removeLast();
            break;
        }
        break;
      case MoveType.move:
        grid[recent.params[0]][recent.params[1]] = Move.empty;
        break;
      case MoveType.block:
        grid[recent.params[0]][recent.params[1]] = Move.empty;
        grid[recent.params[2]][recent.params[3]] = Move.empty;
        break;
    }
  }

  void printHistory() {
    print("Printing History:");
    history.forEach((element) => element.printTurn());
  }
}
