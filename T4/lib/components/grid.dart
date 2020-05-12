import 'piece.dart';
import 'turn.dart';
import 'game.dart';

class Grid {
  List<List<Piece>> grid;
  Game game;

  List<Piece> player;

  Grid(this.game, row, col) {
    grid = List.generate(
        row, (i) => List.filled(col, Piece.empty, growable: true));
    player = List<Piece>();
    player.add(Piece.x);
    player.add(Piece.o);
  }

  Grid.square(Game game, int size) : this(game, size, size);

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
        grid.forEach((row) => row.insert(0, Piece.empty));
        break;
      case 1:
        grid.forEach((row) => row.add(Piece.empty));
        break;
      case 2:
        grid.insert(0, List<Piece>.filled(cols(), Piece.empty, growable: true));
        break;
      case 3:
        grid.add(List<Piece>.filled(cols(), Piece.empty, growable: true));
        break;
    }

    //history.addExtend(dir);
  }

  List<int> checkWinner(int r, int c) {
    List<int> ret = List<int>();
    int hor = 0, vert = 0, slash = 0, bSlash = 0;
    int hStart = 0, vStart = 0, sStart = 0, bsStart = 0;
    int hEnd = 0, vEnd = 0, sEnd = 0, bsEnd = 0;
    //var player = grid[r][c];
    var play = player[game.turn % 2];
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
      if (i < cols && grid[r][i] == play) //find horizontal
      {
        hor++;
        hEnd = i;
      } else if (hor < game.inARow) {
        hor = 0;
        hStart = i + 1;
      } else
        break;

      if (i < rows && grid[i][c] == play) //find vertical
      {
        vEnd = i;
        vert++;
      } else if (vert < game.inARow) {
        vert = 0;
        vStart = i + 1;
      } else
        break;

      // find backslash
      if (bsrs + i < rows &&
          bscs + i < cols &&
          grid[bsrs + i][bscs + i] == play) {
        bSlash++;
        bsEnd = i;
      } else if (bSlash < game.inARow) {
        bSlash = 0;
        bsStart = i + 1;
      } else
        break;

      //find slash
      if (srs + i < rows && scs - i >= 0 && grid[srs + i][scs - i] == play) {
        slash++;
        sEnd = i;
      } else if (slash < game.inARow) {
        slash = 0;
        sStart = i + 1;
      } else
        break;
    }
    if (hor >= game.inARow) {
      print("horizWin");
      ret.add(r);
      ret.add(hStart);
      ret.add(r);
      ret.add(hEnd);
    } else if (vert >= game.inARow) {
      print("vertWin");
      ret.add(vStart);
      ret.add(c);
      ret.add(vEnd);
      ret.add(c);
    } else if (bSlash >= game.inARow) {
      print("bSlashWin");
      ret.add(bsrs + bsStart);
      ret.add(bscs + bsStart);
      ret.add(bsrs + bsEnd);
      ret.add(bscs + bsEnd);
    } else if (slash >= game.inARow) {
      print("slashWin");
      ret.add(srs + sStart);
      ret.add(scs - sStart);
      ret.add(srs + sEnd);
      ret.add(scs - sEnd);
    }
    return ret;
  }

  bool canMove(int r, int c) {
    return grid[r][c] == Piece.empty;
  }

  void move(int r, int c) {
    grid[r][c] = player[game.turn % 2];
  }

  bool canBlock(int r1, int c1, int r2, int c2) {
    return grid[r1][c1] == Piece.empty &&
        grid[r2][c2] == Piece.empty &&
        ((r2 - r1).abs() == 1 && (c2 - c1).abs() < 1) ^
            ((c2 - c1).abs() == 1 && (r2 - r1).abs() < 1);
  }

  void block(int r1, int c1, int r2, int c2) {
    grid[r1][c1] = Piece.block;
    grid[r2][c2] = Piece.block;
  }

  void undo(Turn recent) {
    if (recent == null) {
      return;
    }
    switch (recent.type) {
      case TurnType.extend:
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
      case TurnType.move:
        grid[recent.params[0]][recent.params[1]] = Piece.empty;
        break;
      case TurnType.block:
        grid[recent.params[0]][recent.params[1]] = Piece.empty;
        grid[recent.params[2]][recent.params[3]] = Piece.empty;
        break;
    }
  }

  void reset(int r, int c) {
    grid = List.generate(r, (i) => List.filled(c, Piece.empty, growable: true));
  }

  void printHistory() {
    //print("Printing History:");
    //print(history.toString());
  }
}
