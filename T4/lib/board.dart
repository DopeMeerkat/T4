import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Widget buildBoard(int rows, int columns) {
  //check that this works as non-integer division
  double aspectRatio = rows / columns;

  return AspectRatio(
    //want width/height, so rows/columns
    aspectRatio: aspectRatio,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: buildGrid(rows, columns),
    ),
  );
}

List<Widget> buildGrid(int rows, int columns) {
  List<Widget> columnWidgets = [];

  for (int i = 0; i < columns; i++) {
    List<Widget> rowWidgets = [];
    for (int j = 0; j < rows; j++) {
      rowWidgets.add(buildTile(i, j));
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
Widget buildTile(int row, int column) {
  return AspectRatio(
    aspectRatio: 1.0,
    child: new MaterialButton(
      onPressed: () {},
      child: new Text("hello"), //row.toString() + ", " + column.toString()
    )
  );
}