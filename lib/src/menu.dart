import 'package:flutter/material.dart';
import 'package:interactive_flutter/src/games/gameoflife/main.dart';
import 'package:interactive_flutter/src/games/projectile/main.dart';
import 'package:interactive_flutter/src/games/tetris/main.dart';
import 'package:interactive_flutter/src/ui/generic_scaffold.dart';

enum MenuItems {
  gameOfLife(title: 'Game of Life', widget: GameOfLife(), route: '/gameoflife'),
  projectile(title: 'Projectile', widget: Projectile(), route: '/projectile'),
  tetris(title: 'Tetris', widget: Tetris(), route: '/tetris');

  const MenuItems(
      {required this.title,
      required this.widget,
      required this.route,
      String? description})
      : description = description ?? title;
  final String title;
  final String route;
  final String description;
  final Widget widget;
}

class Menu extends StatefulWidget {
  Menu({Key? key}) : super(key: key);
  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return GenericScaffold(
        body: Center(
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        direction: Axis.vertical,
        spacing: 20,
        runSpacing: 20,
        children:
            MenuItems.values.map((item) => _MenuItem(item: item)).toList(),
      ),
    ));
  }
}

class _MenuItem extends StatelessWidget {
  final MenuItems item;
  const _MenuItem({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: (() => Navigator.pushNamed(context, item.route)),
        child: Text(item.title));
  }
}
