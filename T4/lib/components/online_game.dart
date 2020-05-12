import 'turn.dart';
import 'grid.dart';
import 'game.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OnlineGame extends Game {
  DocumentReference db;
  CollectionReference moves;
  bool resetting;
  final String id;

  OnlineGame(this.id) : super() {
    db = Firestore.instance.collection('games').document(id);
    moves = db.collection('moves');
    listen();
    resetting = false;
    //db ;
  }

  @override
  void reset() {
    moves.document("reset").setData({"reset": "reset"});
  }

  void clearBoard() {
    moves.getDocuments().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.documents){
        ds.reference.delete();
      }
    });
    grid.reset(3, 3);
    turn = 1;
  }

  @override
  void undo() {
    resetting = false;
    if (turn != 0) {
      removeLastFromDB();
    } else {
      return null;
    }
  }

  addTurnToDB(Turn t) {
    moves.document(turn.toString()).setData(t.toJson());
  }

  void removeLastFromDB() {
    moves.document((turn - 1).toString()).delete();
  }

  @override
  void extend(int dir) {
    addTurnToDB(Turn(turn, TurnType.extend, [dir]));
  }

  @override  
  void move(int r, int c) {
    if (grid.canMove(r, c)) {
      addTurnToDB(Turn(turn, TurnType.move, [r, c]));
    }
  }

  @override
  void block(int r1, int c1, int r2, int c2) {
    if (grid.canBlock(r1, c1, r2, c2)) {
      addTurnToDB(Turn(turn, TurnType.block, [r1, c1, r2, c2]));
    }
  }

  //listens and plays any move the db does
  //strong assumption turns are in correct order
  void listen() {
    moves.snapshots().listen((event) {
      event.documentChanges.forEach((change) {
        handleDBChange(change);
      });
    });
  }

  Stream<QuerySnapshot> listenRef() {
    return moves.snapshots();
  }

  //NOTE: STRONG ASSUMPTION DOCUMENTS ARE IN ORDER
  void handleDBChange(DocumentChange move) {
    switch (move.type) {
      case DocumentChangeType.added:
        if (move.document.documentID == "reset") {
          resetting = true;
          clearBoard();
        } else { //regular move
          turn++;
          playMoveFromDB(move.document.data);
        }
        break;
      case DocumentChangeType.modified:
        break;
      case DocumentChangeType.removed:
        if (!resetting) {
          turn--;
          undoMoveFromDB(move.document.data);
        }
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

  undoMoveFromDB(Map<String, dynamic> move) {
    grid.undo(Turn.fromJson(move));
  }

  String toString() {
    String history = "";
    //moveList.forEach((move) => history += move.toString());
    return history;
  }
}