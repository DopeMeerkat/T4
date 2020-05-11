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
    moveList.add(Turn(turn++, TurnType.block, [r1, c1, r2, c2]));
    grid.block(r1, c1, r2, c2);
  }
  
  @override
  void extend(int dir) {
    moveList.add(Turn(turn++, TurnType.extend, [dir]));
    grid.extend(dir);
  }

  @override
  void move(int r, int c) {
    moveList.add(Turn(turn++, TurnType.move, [r, c]));
    grid.move(r, c);
  }

  @override
  void reset() {
    moveList = [];
    grid.reset(3, 3);
  }

  @override
  void undo() {
    if (turn != 0) {
      turn--;
      grid.undo(moveList.removeLast());
    }
  }
}