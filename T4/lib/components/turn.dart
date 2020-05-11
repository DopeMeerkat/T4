class Turn {
  int turnNum;
  TurnType type;
  List<int> params;

  Turn(this.turnNum, this.type, this.params);

  String toString() {
    String msg = "Turn: " +
        turnNum.toString() +
        "| Type: " +
        type.toString() +
        "| Params: ";
    params.forEach((element) => msg += element.toString() + " ");
    return msg;
  }

  Map<String, dynamic> toJson() => {
    'turnNum': turnNum,
    'type': type.toString(),
    'params': params,
  };

  static Turn fromJson(Map<String, dynamic> turn) {
    var turnNum = turn['turnNum'];
    List<int> params = [];
    turn['params'].forEach((param) => params.add(param as int));

    switch (turn["type"]) {
      case "TurnType.move":
        return Turn(turnNum, TurnType.move, params);
      case "TurnType.block":
        return (Turn(turnNum, TurnType.block, params));
      case "TurnType.extend":
        return Turn(turnNum, TurnType.extend, params);
    }
    return null;
  }
}

enum TurnType {
  extend,
  move,
  block,
}

TurnType stringToTurnType(String move) {
  switch (move) {
    case "move":
      return TurnType.move;
    case "block":
      return TurnType.block;
    case "extend":
      return TurnType.extend;
    default:
      return null;
  }
}