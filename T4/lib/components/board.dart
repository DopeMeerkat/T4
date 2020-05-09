import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/widgets.dart';

import 'grid.dart';
import 'move.dart';

class Board extends StatefulWidget {
  final Grid grid = Grid.normal();

  Board(); //implement later (with player names?)

  @override
  _BoardState createState() => _BoardState(grid);
}

class _BoardState extends State<StatefulWidget> {
  Grid grid;
  _BoardState(this.grid);

  @override
  Widget build(BuildContext context) {
    return buildBoard(grid);
  }
}


Widget buildBoard(Grid grid) {
  //check that this works as non-integer division
  double aspectRatio = grid.rows() / grid.cols();

  return AspectRatio(
    //want width/height, so rows/columns
    aspectRatio: aspectRatio,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: buildGrid(grid),
    ),
  );
}

List<Widget> buildGrid(Grid grid) {
  List<Widget> columnWidgets = [];

  for (int i = 0; i < grid.cols(); i++) {
    List<Widget> rowWidgets = [];
    for (int j = 0; j < grid.rows(); j++) {
      rowWidgets.add(buildTile(grid.grid[i][j]));
    }

    columnWidgets.add(Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: rowWidgets,
      )
    ));
  }
  return columnWidgets;
}

//use row and col to do logic stuff later
Widget buildTile(Move move) {
  return AspectRatio(
    aspectRatio: 1.0,
    child: new MaterialButton(
      onPressed: () {},
      child: new Text(move.toString()),
    )
  );
}
