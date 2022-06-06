import 'package:flutter/material.dart';
import 'package:interactive_flutter/src/games/gameoflife/main.dart';
import 'package:interactive_flutter/src/games/projectile/main.dart';
import 'package:interactive_flutter/src/menu.dart';

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
      routes: {
        '/': (context) => Menu(),
        MenuItems.gameOfLife.route: (context) => MenuItems.gameOfLife.widget,
        MenuItems.projectile.route: (context) => MenuItems.projectile.widget,
        MenuItems.tetrix.route: (context) => MenuItems.tetrix.widget,
      },
      // home: Menu(),
    );
  }
}
