import 'package:flutter/material.dart';
import 'package:interactive_flutter/src/games/gameoflife/provider.dart';
import 'package:provider/provider.dart';

class GameOfLifeUI extends StatelessWidget {
  const GameOfLifeUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gameOfLifeProvider = Provider.of<GameOfLifeProvider>(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            color: Colors.grey,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: gameOfLifeProvider.gameBoard,
              ),
            ),
          ),
          GestureDetector(
              onTap: () => gameOfLifeProvider.togglePlay(),
              child: Container(
                margin: const EdgeInsets.all(1),
                color: Theme.of(context).primaryColor,
                child: gameOfLifeProvider.play
                    ? const Icon(
                        Icons.pause,
                        size: 50,
                      )
                    : const Icon(
                        Icons.play_arrow,
                        size: 50,
                      ),
              ))
        ],
      ),
    );
  }
}
