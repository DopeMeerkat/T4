import 'dart:async';
import 'package:T4/components/board.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class GamePage extends StatefulWidget {
  GamePageState createState() => GamePageState();
}

class GamePageState extends State<GamePage> {
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
            // decoration: BoxDecoration(
            //   gradient: LinearGradient(
            //     begin: Alignment.topCenter,
            //     end: Alignment.bottomCenter,
            //     stops: [0.1, 0.65],
            //     colors: [
            //       MyTheme.green,
            //       MyTheme.red,
            //     ],
            //   ),
            // ),
            child: Board(),
          ),
        ),
      ),
    );
  }
}
