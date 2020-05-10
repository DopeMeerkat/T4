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
  Offset dragLocation; //for block moves
  _BoardState(this.grid);
  GlobalKey _boardKey = GlobalKey();
  
  @override
  Widget build(BuildContext context) {
    //return buildBoard(grid);
    return Row(
      children: [
        Container(
          key: _boardKey,
          child: buildBoard(grid),
        ),
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
    
    //converts global position to local board position and gets tile
    List<int> getTileFromLocation(Offset o) {
      RenderBox rb = _boardKey.currentContext.findRenderObject();
      double boardWidth = rb.size.width;
      double boardHeight = rb.size.height;

      Offset relativeToBoard = rb.globalToLocal(o);

      double row = relativeToBoard.dy / (boardHeight / grid.rows());
      double col = relativeToBoard.dx / (boardWidth / grid.cols());
      return [row.floor(), col.floor()];
    }
    
    return AspectRatio(
      aspectRatio: 1.0,
      child: GestureDetector(
        onPanUpdate: (DragUpdateDetails d) {
          dragLocation = d.globalPosition;
        },
        onPanEnd: (DragEndDetails d) {
          setState(() {
            List<int> tile = getTileFromLocation(dragLocation);
            print(tile);
            grid.block(r, c, tile[0], tile[1]);
          });
        },
        child: MaterialButton(
          onPressed: () {
            setState(() {
              grid.move(r, c);
            });
          },
        child: image,
      ),
      ),
    );
  }
}
