import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interactive_flutter/src/games/tetrix/bloc.dart';
import 'package:interactive_flutter/src/games/tetrix/ui.dart';
import 'package:interactive_flutter/src/ui/generic_scaffold.dart';

class Tetrix extends StatelessWidget {
  const Tetrix({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => TetrixBloc(),
        child: const GenericScaffold(
          body: TetrixUI(),
        ));
  }
}
