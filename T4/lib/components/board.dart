import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/widgets.dart';
import 'package:T4/components/btn.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'grid.dart';
import 'piece.dart';
import 'line.dart';
import 'game.dart';
import 'online_game.dart';
import 'offline_game.dart';

class Board extends StatefulWidget {
  final Game game;

  Board(this.game); //implement later (with player names?)

  @override
  _BoardState createState() => _BoardState(game);
}

class _BoardState extends State<StatefulWidget>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Game game;
  Grid grid;
  Offset startBlock;
  Offset endBlock; //for block moves
  GlobalKey _boardKey = GlobalKey();
  double r1, c1, r2, c2, width;
  bool lineVisible;

  _BoardState(this.game) {
    r1 = c1 = 0;
    r2 = c2 = 0;
    width = 10.0;
    lineVisible = false;
    grid = game.grid;

    //update on db update
    if (game.runtimeType == OnlineGame) {
      OnlineGame onlineGame = game as OnlineGame;
      onlineGame.listenRef().listen((event) {
        event.documentChanges.forEach((change) {
          setState(() {});
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();

    //var v = Firestore.instance.collection("game").add({"test": "test"});
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
      int max = grid.grid.length;
      if (grid.grid[0].length > grid.grid.length) max = grid.grid[0].length;

      width = 30 / max;
      if (width == 0) width = 1;
      lineVisible = true;
      _startAnimation();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Btn(
                  onTap: () {
                    // lineVisible = false;
                    // setState(() => grid.undo());
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  height: 40,
                  width: 40,
                  borderRadius: 250,
                  color: Colors.white,
                  child: new Icon(Icons.home),
                ),
                Btn(
                    onTap: () {
                      setState(() => grid.extend(2));
                    },
                    height: 40,
                    width: 250,
                    borderRadius: 250,
                    color: Colors.white,
                    // child: Text(
                    //   "^",
                    //   style: TextStyle(
                    //       color: Colors.black.withOpacity(.8),
                    //       fontSize: 16,
                    //       fontWeight: FontWeight.w700),
                    // ),
                    child: new Icon(Icons.arrow_upward)),
                Btn(
                  onTap: () {
                    // lineVisible = false;
                    // setState(() => grid.undo());
                  },
                  height: 40,
                  width: 40,
                  borderRadius: 250,
                  color: Colors.white,
                  child: new Icon(Icons.settings),
                ),
              ]),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Btn(
                  onTap: () {
                    setState(() => grid.extend(0));
                  },
                  height: 250,
                  width: 40,
                  borderRadius: 250,
                  color: Colors.white,
                  // child: Text(
                  //   "<",
                  //   style: TextStyle(
                  //       color: Colors.black.withOpacity(.8),
                  //       fontSize: 16,
                  //       fontWeight: FontWeight.w700),
                  // ),
                  child: new Icon(Icons.arrow_back)),
              CustomPaint(
                foregroundPainter: new AnimatedPainter(
                    _controller, r1, c1, r2, c2, width, lineVisible),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(.1),
                          spreadRadius: 5,
                          blurRadius: 10)
                    ],
                  ),
                  child: buildBoard(grid),
                ),
              ),
              Btn(
                  onTap: () {
                    setState(() => grid.extend(1));
                  },
                  height: 250,
                  width: 40,
                  borderRadius: 250,
                  color: Colors.white,
                  // child: Text(
                  //   ">",
                  //   style: TextStyle(
                  //       color: Colors.black.withOpacity(.8),
                  //       fontSize: 16,
                  //       fontWeight: FontWeight.w700),
                  // ),
                  child: new Icon(Icons.arrow_forward)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Btn(
                onTap: () {
                  lineVisible = false;
                  setState(() => game.undo());
                },
                height: 40,
                width: 40,
                borderRadius: 250,
                color: Colors.white,
                child: new Icon(Icons.undo),
              ),
              Btn(
                  onTap: () {
                    setState(() => grid.extend(3));
                  },
                  height: 40,
                  width: 250,
                  borderRadius: 250,
                  color: Colors.white,
                  child: new Icon(Icons.arrow_downward)
                  // child: Text(
                  //   "v",
                  //   style: TextStyle(
                  //       color: Colors.black.withOpacity(.8),
                  //       fontSize: 16,
                  //       fontWeight: FontWeight.w700),
                  // ),
                  ),
              Btn(
                onTap: () {
                  setState(() => game.reset());
                  //setState(() => grid.reset(3, 3));
                  lineVisible = false;
                },
                height: 40,
                width: 40,
                borderRadius: 250,
                color: Colors.white,
                child: new Icon(Icons.refresh),
              ),
            ],
          )
        ],
      ),
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
              //print("tapping");
              // _startAnimation();
              setState(() {
                List<int> tile = getTileFromLocation(d.globalPosition);
                game.move(tile[0], tile[1]);

                checkWin(tile[0], tile[1]);
              });
            },
            onPanStart: (DragStartDetails d) {
              //print("panning");
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
                  //grid.move(startTile[0], startTile[1]);
                  game.move(startTile[0], startTile[1]);
                } else {
                  //grid.block(startTile[0], startTile[1], endTile[0], endTile[1]);
                  game.block(
                      startTile[0], startTile[1], endTile[0], endTile[1]);
                }
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

    switch (grid.grid[r][c]) {
      case Piece.o:
        image = Image.asset('assets/images/o.png');
        break;
      case Piece.x:
        image = Image.asset('assets/images/x.png');
        break;
      case Piece.block:
        image = Image.asset('assets/images/block.png');
        break;
      case Piece.empty:
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
