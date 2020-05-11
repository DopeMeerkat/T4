import 'turn.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final db = Firestore.instance.collection('game');

class History {
  List<Turn> moveList;
  int turn;

  History() {
    moveList = [];
    turn = 0;
  }

  clear() {
    moveList = [];
    turn = 0;
  }

  Turn undo() {
    if (turn != 0) {
      removeLastFromDB();
      turn--;
      return moveList.removeLast();
    } else {
      return null;
    }
  }
  int getTurn() {
    return turn;
  }

  void addLastToDB() {
    db.document(turn.toString()).setData(moveList.last.toJson());
  }

  void removeLastFromDB() {
    db.document(turn.toString()).delete();
  }

  void addExtend(int dir) {
    moveList.add(Turn(++turn, TurnType.extend, [dir]));
    addLastToDB();
  }

  void addMove(int r, int c) {
    moveList.add(Turn(++turn, TurnType.move, [r, c]));
    addLastToDB();
  }

  void addBlock(int r1, int c1, int r2, int c2) {
    moveList.add(Turn(++turn, TurnType.block, [r1, c1, r2, c2]));
    addLastToDB();
  }

  String toString() {
    String history = "";
    moveList.forEach((move) => history += move.toString());
    return history;
  }
}