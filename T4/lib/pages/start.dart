import 'package:T4/pages/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:T4/theme/theme.dart';
import 'package:T4/components/btn.dart';
import 'package:T4/components/board.dart';

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
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Flexible(
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
                ),
                Flexible(
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
                              builder: (context) => GamePage(),
                            ),
                          );
                        },
                        height: 40,
                        width: 250,
                        borderRadius: 250,
                        color: Colors.white,
                        child: Text(
                          "single player".toUpperCase(),
                          style: TextStyle(
                              color: Colors.black.withOpacity(.8),
                              fontSize: 16,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      SizedBox(height: 30),
                      // Btn(
                      //   onTap: () {
                      //     Navigator.push(
                      //       context,
                      //       CupertinoPageRoute(
                      //         builder: (context) => GamePage(),
                      //       ),
                      //     );
                      //   },
                      //   color: Colors.white,
                      //   height: 40,
                      //   width: 250,
                      //   borderRadius: 250,
                      //   child: Text(
                      //     "with a friend".toUpperCase(),
                      //     style: TextStyle(
                      //         color: Colors.black.withOpacity(.8),
                      //         fontSize: 16,
                      //         fontWeight: FontWeight.w700),
                      //   ),
                      // ),
                      SizedBox(height: 60),
                      // Btn(
                      //   onTap: () {
                      //     Navigator.push(
                      //       context,
                      //       CupertinoPageRoute(
                      //         fullscreenDialog: true,
                      //         builder: (context) => SettingsPage(),
                      //       ),
                      //     );
                      //   },
                      //   color: Colors.white,
                      //   height: 50,
                      //   width: 50,
                      //   borderRadius: 25,
                      //   child: Icon(Icons.settings),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
