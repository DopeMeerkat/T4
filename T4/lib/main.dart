import 'package:flutter/material.dart';
import 'components/board.dart';
import 'package:firebase/firebase.dart';

void main() {
  /*
  initializeApp(
    apiKey: "AIzaSyCvVp-W_TqDhwIKD0U0XV8-N_1oqfETt8U",
    authDomain: "YourAuthDomain",
    databaseURL: "YourDatabaseUrl",
    projectId: "t4database",
    storageBucket: "YourStorageBucket"
  );
  */
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'T4',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("T4"),
        ),

        body: Center(
          child: Board(),
        ),
      ),
    );
  }
}
