import 'package:flutter/material.dart';
import 'package:interactive_flutter/src/games/gameoflife/main.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'adawolfs',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const GameOfLife(),
    );
  }
}
