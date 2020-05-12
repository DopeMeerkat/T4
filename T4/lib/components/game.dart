import 'turn.dart';
import 'grid.dart';

abstract class Game {
  Grid grid;
  int turn;
  int inARow;
  int size;

  //change this constructor later
  Game({this.size = 3, this.turn = 1, this.inARow = 3}) {
    grid = Grid.square(this, size);
  }
  

  void reset();

  void undo();

  void extend(int dir);

  void move(int r, int c);

  void block(int r1, int c1, int r2, int c2);

  String toString();
}