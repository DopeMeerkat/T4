import 'turn.dart';
import 'grid.dart';
import 'game.dart';

class OfflineGame extends Game {
  List<Turn> moveList;


  OfflineGame() : super() {
    moveList = [];
  }

  @override
  void block(int r1, int c1, int r2, int c2) {
    if (grid.canBlock(r1, c1, r2, c2)) {
      grid.block(r1, c1, r2, c2);
      moveList.add(Turn(turn++, TurnType.block, [r1, c1, r2, c2]));
    }
  }
  
  @override
  void extend(int dir) {
    moveList.add(Turn(turn++, TurnType.extend, [dir]));
    grid.extend(dir);
  }

  @override
  void move(int r, int c) {
    if (grid.canMove(r, c)) {
      grid.move(r, c);
      moveList.add(Turn(turn++, TurnType.move, [r, c]));
    }
  }

  @override
  void reset() {
    moveList = [];
    grid.reset(size, size);
  }

  @override
  void undo() {
    if (turn != 0) {
      turn--;
      grid.undo(moveList.removeLast());
    }
  }
}