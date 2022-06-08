import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interactive_flutter/src/games/tetris/bloc.dart';
import 'package:interactive_flutter/src/ui/extensions.dart';

class TetrisUI extends StatelessWidget {
  const TetrisUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TetrisBloc, TetrisState>(builder: (context, state) {
      FocusNode focusNode = FocusNode();
      FocusScope.of(context).requestFocus(focusNode);
      return state is TetrisGameOver
          ? Center(
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Game Over', style: TextStyle(fontSize: 30)),
                GestureDetector(
                    onTap: () {
                      BlocProvider.of<TetrisBloc>(context).add(TetrisRestart());
                    },
                    child: const Icon(size: 50.0, Icons.refresh)),
              ],
            ))
          : LayoutBuilder(builder: (context, constraints) {
              return RawKeyboardListener(
                focusNode: focusNode,
                onKey: (event) {
                  if (event.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
                    BlocProvider.of<TetrisBloc>(context).add(TetrisMoveLeft());
                  } else if (event
                      .isKeyPressed(LogicalKeyboardKey.arrowRight)) {
                    BlocProvider.of<TetrisBloc>(context).add(TetrisMoveRight());
                  } else if (event.isKeyPressed(LogicalKeyboardKey.arrowDown)) {
                    BlocProvider.of<TetrisBloc>(context).add(TetrisMoveDown());
                  } else if (event.isKeyPressed(LogicalKeyboardKey.space)) {
                    BlocProvider.of<TetrisBloc>(context).add(TetrisRotate());
                  }
                },
                child: Container(
                  color: Colors.grey,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: state.board
                              .map(
                                (e) => Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: e
                                      .map(
                                        (e) => Padding(
                                          padding: const EdgeInsets.all(1.0),
                                          child: Container(
                                            color:
                                                e ? Colors.black : Colors.white,
                                            height: 20,
                                            width: 20,
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              )
                              .toList(),
                        ),
                        constraints.isMobile
                            ? Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          BlocProvider.of<TetrisBloc>(context)
                                              .add(TetrisMoveLeft());
                                        },
                                        child: const Icon(
                                            size: 50.0, Icons.arrow_left),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          BlocProvider.of<TetrisBloc>(context)
                                              .add(TetrisRotate());
                                        },
                                        child: const Icon(
                                            size: 50.0,
                                            Icons.rotate_90_degrees_cw),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          BlocProvider.of<TetrisBloc>(context)
                                              .add(TetrisMoveRight());
                                        },
                                        child: const Icon(
                                            size: 50.0, Icons.arrow_right),
                                      ),
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      BlocProvider.of<TetrisBloc>(context)
                                          .add(TetrisMoveDown());
                                    },
                                    child: const Icon(
                                        size: 50.0, Icons.arrow_drop_down),
                                  )
                                ],
                              )
                            : Container()
                      ],
                    ),
                  ),
                ),
              );
            });
    });
  }
}
