import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase/firestore.dart';

import 'grid.dart';
import 'move.dart';
import 'line.dart';

class Board extends StatefulWidget {
  final Grid grid = Grid.normal();

  Board(); //implement later (with player names?)

  @override
  _BoardState createState() => _BoardState(grid);
}

class _BoardState extends State<StatefulWidget>
    with SingleTickerProviderStateMixin {

  AnimationController _controller;
  Grid grid;
  Offset startBlock;
  Offset endBlock; //for block moves
  GlobalKey _boardKey = GlobalKey();
  double r1 = 0, c1 = 0, r2 = 1, c2 = 1;
  bool lineVisible = false;


  _BoardState(this.grid);

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startAnimation() {
    // _controller.repeat(
    //   period: Duration(seconds: 1),
    // );
    _controller.stop();
    _controller.reset();
    _controller.forward();
  }

  void checkWin(int r, int c) {
    List<int> endpoints = grid.checkWinner(r, c);
    if (endpoints.isNotEmpty) {
      Offset p1 = getLocationFromTile(endpoints[0], endpoints[1]);
      Offset p2 = getLocationFromTile(endpoints[2], endpoints[3]);
      r1 = p1.dx;
      c1 = p1.dy;
      r2 = p2.dx;
      c2 = p2.dy;
      lineVisible = true;
      _startAnimation();
    }
  }

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
            CustomPaint(
              foregroundPainter:
                  new AnimatedPainter(_controller, r1, c1, r2, c2, lineVisible),
              child: buildBoard(grid),
            ),
            MaterialButton(
              onPressed: () {
                setState(() => grid.extend(3));
              },
              child: Text("bottom"),
            ),
          ],
        ),
        Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          MaterialButton(
            onPressed: () {
              setState(() => grid.undo());
            },
            // child: Text("undo"),
            child: new Icon(Icons.undo),
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
              lineVisible = false;
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
              // _startAnimation();
              setState(() {
                List<int> tile = getTileFromLocation(d.globalPosition);
                grid.move(tile[0], tile[1]);
                checkWin(tile[0], tile[1]);
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

  Offset getLocationFromTile(r, c) {
    RenderBox rb = _boardKey.currentContext.findRenderObject();
    double boardWidth = rb.size.width;
    double boardHeight = rb.size.height;
    var y = (r + .5) * (boardHeight / grid.rows());
    var x = (c + .5) * (boardWidth / grid.cols());
    return Offset(x, y);
  }

  //use row and col to do logic stuff later
  Widget buildTile(Grid grid, r, c) {
    Image image;
    BoxBorder border = Border();
    BorderSide borderStyle = BorderSide(width: 1, color: Colors.black26);
    BoxBorder bLeft = Border(left: borderStyle);
    BoxBorder bTop = Border(top: borderStyle);
    if (r > 0) border = border.add(bTop);
    if (c > 0) border = border.add(bLeft);
    if (r == 0 && c == 0) border = Border();

    // border = border.add(border2);
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
        decoration: BoxDecoration(
          color: Colors.white,
          border: border,
        ),
        child: image,
      ),
    );
  }
}
