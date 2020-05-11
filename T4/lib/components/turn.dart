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
    'turnNum:': turnNum,
    'type': type.toString(),
    'params': params,
  };
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