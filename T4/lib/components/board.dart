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
  Offset startBlock;
  Offset endBlock; //for block moves
  _BoardState(this.grid);
  GlobalKey _boardKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        MaterialButton(
          onPressed: () {
            setState(() => grid.extend(0));
          },
          child: Text("left"),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MaterialButton(
              onPressed: () {
                setState(() => grid.extend(2));
              },
              child: Text("top"),
            ),
            buildBoard(grid),
            MaterialButton(
              onPressed: () {
                setState(() => grid.extend(3));
              },
              child: Text("bottom"),
            ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          MaterialButton(
            onPressed: () {
              setState(() => grid.undo());
            },
            child: Text("undo"),
          ),
          MaterialButton(
            onPressed: () {
              setState(() => grid.extend(1));
            },
            child: Text("right"),
          ),
          MaterialButton(
            onPressed: () {
              setState(() => grid.reset(3, 3));
            },
            child: Text("New Game"),
          ),
        ]),
      ],
    );
  }

  Widget buildBoard(Grid grid) {
    //check that this works as non-integer division
    double aspectRatio = grid.cols() / grid.rows();
    MediaQueryData queryData = MediaQuery.of(context);
    double width = queryData.size.width - 200;
    double height = queryData.size.height - 200;
    if (aspectRatio * height > width) {
      height = width / aspectRatio;
    } else {
      width = height * aspectRatio;
    }

    return Container(
      child: Container(
        width: width,
        height: height,
        child: AspectRatio(
          //want width/height, so rows/columns
          aspectRatio: aspectRatio,
          key: _boardKey,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTapUp: (TapUpDetails d) {
              print("tapping");
              setState(() {
                List<int> tile = getTileFromLocation(d.globalPosition);
                grid.move(tile[0], tile[1]);
              });
            },
            onPanStart: (DragStartDetails d) {
              print("panning");
              startBlock = d.globalPosition;
            },
            onPanUpdate: (DragUpdateDetails d) {
              endBlock = d.globalPosition;
            },
            onPanEnd: (DragEndDetails d) {
              setState(() {
                List<int> startTile = getTileFromLocation(startBlock);
                List<int> endTile = getTileFromLocation(endBlock);
                if (startTile == endTile) {
                  grid.move(startTile[0], startTile[1]);
                }
                grid.block(startTile[0], startTile[1], endTile[0], endTile[1]);
              });
            },
            child: Column(
              children: buildGrid(grid),
            ),
          ),
        ),
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
      child: Container(
        child: image,
      ),
    );
  }
}
