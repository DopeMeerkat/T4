import 'dart:async';
import 'package:T4/components/board.dart';
import 'package:T4/components/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class GamePage extends StatefulWidget {
  final Game game;
  GamePage(this.game);
  GamePageState createState() => GamePageState(game);
}

class GamePageState extends State<GamePage> {
  final Game game;
  GamePageState(this.game);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: SafeArea(
        child: Scaffold(
          body: Container(
            width: MediaQuery.of(context).size.width,
            child: Board(game),
          ),
        ),
      ),
    );
  }
}
