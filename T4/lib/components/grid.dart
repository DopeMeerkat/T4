import 'move.dart';
import 'turn.dart';

class Grid {
  List<List<Move>> grid; //list of rows (first list is y axis, second is x)
  int inARow;
  List<Turn> history;

  int turn;
  List<Move> player;

  
  Map<String, dynamic> toJson() => 
  {
    'grid': grid,
    'inARow': inARow,
    'history': history,
    'turn': turn,
    'player': player
  };

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

  List<int> checkWinner(int r, c) {
    List<int> ret = new List<int>();
    int hor = 0, vert = 0, slash = 0, bSlash = 0;
    int hStart = 0, vStart = 0, sStart = 0, bsStart = 0;
    int hEnd = 0, vEnd = 0, sEnd = 0, bsEnd = 0;
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
      scs = c + r;
    else
      srs = r - (cols - 1 - c);

    for (int i = 0; i < max; i++) {
      if (i < cols && grid[r][i] == player) //find horizontal
      {
        hor++;
        hEnd = i;
      } else if (hor < inARow) {
        hor = 0;
        hStart = i + 1;
      } else
        break;

      if (i < rows && grid[i][c] == player) //find vertical
      {
        vEnd = i;
        vert++;
      } else if (vert < inARow) {
        vert = 0;
        vStart = i + 1;
      } else
        break;

      // find backslash
      if (bsrs + i < rows &&
          bscs + i < cols &&
          grid[bsrs + i][bscs + i] == player) {
        bSlash++;
        bsEnd = i;
      } else if (bSlash < inARow) {
        bSlash = 0;
        bsStart = i + 1;
      } else
        break;

      //find slash
      if (srs + i < rows && scs - i >= 0 && grid[srs + i][scs - i] == player) {
        slash++;
        sEnd = i;
      } else if (slash < inARow) {
        slash = 0;
        sStart = i + 1;
      } else
        break;
    }

    // return (vert >= inARow ||
    //     hor >= inARow ||
    //     slash >= inARow ||
    //     bSlash >= inARow);
    if (hor >= inARow) {
      print("horizWin");
      ret.add(r);
      ret.add(hStart);
      ret.add(r);
      ret.add(hEnd);
    } else if (vert >= inARow) {
      print("vertWin");
      ret.add(vStart);
      ret.add(c);
      ret.add(vEnd);
      ret.add(c);
    } else if (bSlash >= inARow) {
      print("bSlashWin");
      ret.add(bsrs + bsStart);
      ret.add(bscs + bsStart);
      ret.add(bsrs + bsEnd);
      ret.add(bscs + bsEnd);
    } else if (slash >= inARow) {
      print("slashWin");
      ret.add(srs + sStart);
      ret.add(scs - sStart);
      ret.add(srs + sEnd);
      ret.add(scs - sEnd);
    }
    return ret;
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
      // if (checkWinner(r, c)) {}
      print(checkWinner(r, c));
      return true;
    }
    return false;
  }

  bool block(int r1, int c1, int r2, int c2) {
    if (grid[r1][c1] == Move.empty &&
        grid[r2][c2] == Move.empty &&
        ((r2 - r1).abs() == 1 && (c2 - c1).abs() < 1) ^
            ((c2 - c1).abs() == 1 && (r2 - r1).abs() < 1)) {
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
    if (turn > 0) turn--;
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

  void reset(int r, int c) {
    history.clear();
    grid =
        List.generate(r, (i) => new List.filled(c, Move.empty, growable: true));
    setTurn(0);
    // var len = history.length; //lmaoooo
    // for (int i = 0; i < len; i++) {
    //   undo();
    // }
  }

  void printHistory() {
    print("Printing History:");
    history.forEach((element) => element.printTurn());
  }

}
