import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interactive_flutter/src/games/tetrix/bloc.dart';

class TetrixUI extends StatelessWidget {
  const TetrixUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TetrixBloc, TetrixState>(builder: (context, state) {
      FocusNode focusNode = FocusNode();
      FocusScope.of(context).requestFocus(focusNode);
      return state is TetrixGameOver
          ? Center(
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Game Over', style: TextStyle(fontSize: 30)),
                GestureDetector(
                    onTap: () {
                      BlocProvider.of<TetrixBloc>(context).add(TetrixRestart());
                    },
                    child: Icon(size: 50.0, Icons.refresh)),
              ],
            ))
          : RawKeyboardListener(
              focusNode: focusNode,
              onKey: (event) {
                if (event.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
                  BlocProvider.of<TetrixBloc>(context).add(TetrixMoveLeft());
                } else if (event.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
                  BlocProvider.of<TetrixBloc>(context).add(TetrixMoveRight());
                } else if (event.isKeyPressed(LogicalKeyboardKey.arrowDown)) {
                  BlocProvider.of<TetrixBloc>(context).add(TetrixMoveDown());
                } else if (event.isKeyPressed(LogicalKeyboardKey.space)) {
                  BlocProvider.of<TetrixBloc>(context).add(TetrixRotate());
                }
              },
              child: Container(
                color: Colors.grey,
                child: Center(
                  child: Column(
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
                                      color: e ? Colors.black : Colors.white,
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
                ),
              ),
            );
    });
  }
}
