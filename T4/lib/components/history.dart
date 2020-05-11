import 'turn.dart';
import 'grid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class History {
  Grid grid;
  final db = Firestore.instance.collection('game');
  List<Turn> moveList;
  int turn;

  History(this.grid) {
    listen();
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

  //listens and plays any move the db does
  //strong assumption turns are in correct order
  void listen() {
    db.snapshots().listen((event) {
      event.documentChanges.forEach((change) {
        handleDBChange(change);
      });
    });
  }

  //NOTE: STRONG ASSUMPTION DOCUMENTS ARE IN ORDER
  void handleDBChange(DocumentChange move) {
    switch (move.type) {
      case DocumentChangeType.added:
        if (move.document.data["turnNum"] > turn) {
          turn++;
          playMoveFromDB(move.document.data);
        }
        break;
      case DocumentChangeType.modified:
        print("Document Modified: error");
        break;
      case DocumentChangeType.removed:
        grid.undo();
        moveList.removeLast();
        break;
    }
  }

  //TODO add move to list
  void playMoveFromDB(Map<String, dynamic> move) {
    List params = move["params"];
    
    switch (move["type"]) {
      case "TurnType.move":
        grid.move(params[0], params[1]);
        break;
      case "TurnType.block":
        grid.block(params[0], params[1], params[2], params[3]);
        break;
      case "TurnType.extend":
        grid.extend(params[0]);
        break;
    }
  }

  String toString() {
    String history = "";
    moveList.forEach((move) => history += move.toString());
    return history;
  }
}