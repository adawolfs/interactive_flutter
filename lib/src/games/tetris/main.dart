import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interactive_flutter/src/games/tetris/bloc.dart';
import 'package:interactive_flutter/src/games/tetris/ui.dart';
import 'package:interactive_flutter/src/ui/generic_scaffold.dart';

class Tetris extends StatelessWidget {
  const Tetris({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => TetrisBloc(),
        child: const GenericScaffold(
          body: TetrisUI(),
        ));
  }
}
