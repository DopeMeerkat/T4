enum MoveType {
  extend,
  move,
  block,
}

class Turn {
  int turnNum;
  MoveType type;
  List<int> params;
  Turn(int _turnNum, MoveType _type, List<int> _params) {
    turnNum = _turnNum;
    type = _type;
    params = _params;
  }

  void printTurn() {
    String msg = "Turn: " +
        turnNum.toString() +
        "| Type: " +
        type.toString() +
        "| Params: ";
    params.forEach((element) => msg += element.toString() + " ");
    print(msg);
  }
}
