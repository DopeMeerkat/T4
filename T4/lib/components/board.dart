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
    //return buildBoard(grid);
    return Row(
      children: [
        buildBoard(grid),
        Column(
          children: [
            MaterialButton(
              onPressed: () {
                setState(() => grid.extend(0));
              },
              child: Text("left"),
            ),
            MaterialButton(
              onPressed: () {
                setState(() => grid.extend(1));
              },
              child: Text("right"),
            ),
            MaterialButton(
              onPressed: () {
                setState(() => grid.extend(2));
              },
              child: Text("top"),
            ),
            MaterialButton(
              onPressed: () {
                setState(() => grid.extend(3));
              },
              child: Text("bottom"),
            )
          ],
        ),
      ],
    );
  }


  Widget buildBoard(Grid grid) {
    //check that this works as non-integer division
    double aspectRatio = grid.cols() / grid.rows();

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

    for (int i = 0; i < grid.rows(); i++) {
      List<Widget> rowWidgets = [];
      for (int j = 0; j < grid.cols(); j++) {
        rowWidgets.add(buildTile(grid, i, j));
      }

      columnWidgets.add(Expanded(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: rowWidgets,
      )));
    }
    return columnWidgets;
  }

  //use row and col to do logic stuff later
  Widget buildTile(Grid grid, r, c) {
    Image image;
    switch (grid.grid[r][c]) {
      case Move.o:
        image = Image.asset('assets/images/o.png');
        break;
      case Move.x:
        image = Image.asset('assets/images/x.png');
        break;
      case Move.block:
        image = Image.asset('assets/images/block.png');
        break;
      case Move.empty:
        //image = Image.asset('assets/images/block.png'); //change to empty
    }

    return AspectRatio(
      aspectRatio: 1.0,
      /*
      child: GestureDetector(
        onTap: () {
          setState(() {
            grid.move(x, y);
          });
        },
        /*
        onPanEnd: (DragEndDetails d) {
          setState() {
            grid.block(d.)
          }
        },
        */
        child: image
      ),
      */
      
      child: MaterialButton(
        onPressed: () {
          setState(() {
            grid.move(r, c);
          });
        },
        child: image,
      ),
      
    );
  }
}
