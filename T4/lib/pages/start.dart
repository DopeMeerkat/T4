import 'package:T4/components/game.dart';
import 'package:T4/pages/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:T4/theme/theme.dart';
import 'package:T4/components/btn.dart';
import 'package:T4/components/board.dart';
import 'package:T4/components/offline_game.dart';
import 'package:T4/components/online_game.dart';

class StartPage extends StatelessWidget {
  StartPage({Key key}) : super(key: key);

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
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                title(),
                game(context, "LOCAL GAME", OfflineGame()),
                game(context, "ONLINE GAME", OnlineGame()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget title() {
  return Flexible(
    flex: 1,
    child: Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "T^4",
          style: TextStyle(
              color: Colors.black,
              fontSize: 65,
              fontWeight: FontWeight.w700,
              fontFamily: 'DancingScript'),
        ),
      ],
    ),
  );
}

Widget game(BuildContext context, String name, Game game) {
  return Flexible(
    flex: 1,
    child: Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Btn(
          onTap: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => GamePage(game),
              ),
            );
          },
          height: 40,
          width: 250,
          borderRadius: 250,
          color: Colors.white,
          child: Text(
            name,
            style: TextStyle(
                color: Colors.black.withOpacity(.8),
                fontSize: 16,
                fontWeight: FontWeight.w700),
          ),
        ),
        SizedBox(height: 30),
        SizedBox(height: 60),
      ],
    ),
  );
}