import 'move.dart';

//TODO implement history/undo functions
class Grid {
  List<List<Move>> grid; //list of rows (first list is y axis, second is x)
  int inARow;
  

  Grid(row, col, this.inARow) {
    grid = List.generate(row, (i) => new List.filled(col, Move.empty));
  }

  Grid.normal() : this(3, 3, 3);

  int rows() {
    return grid[0].length;
  }

  int cols() {
    return grid.length;
  }

  void extendLeft() {
    grid.forEach((row) => row.insert(0, Move.empty));
  }

  void extendRight() {
    grid.forEach((row) => row.add(Move.empty));
  }

  //extend top by adding list to top
  void extendTop() {
    grid.insert(0, List<Move>.filled(cols(), Move.empty));
  }

  //extend bot by adding list to end
  void extendBot() {
    grid.add(List<Move>.filled(cols(), Move.empty));
  }

  void checkWin() {

  }

  void move() {}
  void block() {}
}