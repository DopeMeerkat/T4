import 'turn.dart';
import 'grid.dart';

abstract class Game {
  Grid grid;
  int turn;
  int inARow;

  Game() {
    grid = Grid.normal(this);
    turn = 1;
    inARow = 3;
  }

  void reset();

  void undo();

  void extend(int dir);

  void move(int r, int c);

  void block(int r1, int c1, int r2, int c2);

  String toString();
}