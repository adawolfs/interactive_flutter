import 'dart:math';

import 'package:flutter/material.dart';
import 'package:interactive_flutter/src/games/gameoflife/provider.dart';
import 'package:interactive_flutter/src/games/gameoflife/ui.dart';
import 'package:provider/provider.dart';

class GameOfLife extends StatelessWidget {
  const GameOfLife({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    int speed = 10;
    if (width > 800) {
      width = width - 200;
      height = height - 200;
    } else {
      width = width - 100;
      speed = 100;
    }
    int size = min(width, height) ~/ 20;
    double cellSize = min(width, height) / size;
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Game of Life', textAlign: TextAlign.center)),
      ),
      extendBody: true,
      backgroundColor: Colors.grey,
      body: Center(
        child: ChangeNotifierProvider(
          create: (context) =>
              GameOfLifeProvider(size: size, cellSize: cellSize, speed: speed),
          child: const GameOfLifeUI(),
        ),
      ),
    );
  }
}
