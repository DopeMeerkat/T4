/*
import 'turn.dart';
import 'grid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Game {
  Grid grid;
  final db = Firestore.instance.collection('game');
  //List<Turn> moveList;
  int turn;

  Game() {
    grid = Grid.normal(this);
    listen();
    //moveList = [];
    turn = 0;
    print("i have been created");
  }
  sayHi() {
    print("hello");
  }

  reset() {
    //moveList = [];
    grid.reset(3, 3);
    db.getDocuments().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.documents){
        ds.reference.delete();
      }
    });
    turn = 0;
  }

  void undo() {
    if (turn != 0) {
      removeLastFromDB();
    } else {
      return null;
    }
    /*
    if (turn != 0) {
      //removeLastFromDB();
      turn--;
      return moveList.removeLast();
    } else {
      return null;
    }
    */
  }

  int getTurn() {
    return turn;
  }
  
  void addLastToDB() {
    //db.document(turn.toString()).setData(moveList.last.toJson());
  }

  addTurnToDB(Turn t) {
    db.document(turn.toString()).setData(t.toJson());
  }

  void removeLastFromDB() {
    db.document(turn.toString()).delete();
  }

  void addExtend(int dir) {
    //moveList.add(Turn(++turn, TurnType.extend, [dir]));
    //addLastToDB();
    addTurnToDB(Turn(turn, TurnType.extend, [dir]));
  }

  void addMove(int r, int c) {
    //moveList.add(Turn(turn, TurnType.move, [r, c])); //removed turn++
    //addLastToDB();
    addTurnToDB(Turn(turn, TurnType.move, [r, c]));
  }

  void addBlock(int r1, int c1, int r2, int c2) {
    //moveList.add(Turn(++turn, TurnType.block, [r1, c1, r2, c2]));
    //addLastToDB();
    addTurnToDB(Turn(turn, TurnType.block, [r1, c1, r2, c2]));
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
        /*
        if (int.parse(move.document.data["turnNum"]) >= turn) {
          turn++;
          playMoveFromDB(move.document.data);
        }
        */
        turn++;
        playMoveFromDB(move.document.data);
        break;
      case DocumentChangeType.modified:
        print("Document Modified: error");
        break;
      case DocumentChangeType.removed:
        undoMoveFromDB(move.document.data);
        //moveList.removeLast();
        break;
    }
  }
  undoMoveFromDB(Map<String, dynamic> move) {
    int turnNum = move["turnNum"];
    List params = move["params"];
    
    switch (move["type"]) {
      case "TurnType.move":
        grid.undo(Turn(turnNum, TurnType.move, params));
        break;
      case "TurnType.block":
        grid.undo(Turn(turnNum, TurnType.block, params));
        break;
      case "TurnType.extend":
        grid.undo(Turn(turnNum, TurnType.extend, params));;
        break;
    }
  }

  //TODO add move to list
  void playMoveFromDB(Map<String, dynamic> move) {
    List params = move["params"];
    print("playing move");
    print(move);
    switch (move["type"]) {
      case "TurnType.move":
        print("in here");
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

    //String history = "";
    //moveList.forEach((move) => history += move.toString());
    return "I am a game";
  }
}
*/