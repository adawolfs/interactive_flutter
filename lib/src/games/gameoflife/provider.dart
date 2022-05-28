import 'dart:async';
import 'package:flutter/material.dart';

class GameOfLifeProvider extends ChangeNotifier {
  bool play = false;
  int size = 25;
  double cellSize;
  late List<List<bool>> _grid;
  late List<List<bool>> _nextGrid;
  GameOfLifeProvider({required this.size, this.cellSize = 20, speed = 10}) {
    _grid = List.generate(size, (i) => List.generate(size, (j) => false));
    _nextGrid = List.generate(size, (i) => List.generate(size, (j) => false));
    updateState(speed);
  }

  void _applyRules(i, j) {
    int neighbors = _countNeighbors(i, j);
    if (play) {
      if (neighbors == 3) {
        _nextGrid[i][j] = true;
      } else if (neighbors < 2 || neighbors > 3) {
        if (_nextGrid[i][j]) {
          _nextGrid[i][j] = false;
        }
      }
    }
  }

  List<Widget> get gameBoard {
    List<Widget> gameBoard = [];

    // _nextGrid is used to avoid mutating the grid in the middle of the loop
    // so all the cells are calculated with the same values as the grid
    // at the end of the loop the grid is updated with the new values.

    // map is used to create a new list with the same size as the grid
    // because grid is mutable we need new lists to avoid mutating the grid
    _nextGrid = _grid.map((List<bool> row) => row.toList()).toList();

    // Iterate through the original grid
    // asMap is used to get the index of the row and column
    grid.asMap().forEach((i, row) {
      List<Widget> rowWidgets = [];
      row.asMap().forEach((j, cell) {
        // Apply the rules of the game of life
        // It's done here to avoid iterating through the grid again
        _applyRules(i, j);
        // Create the cell
        rowWidgets.add(GestureDetector(
          onTap: () => toggleCell(i, j),
          child: Container(
            margin: const EdgeInsets.all(1),
            width: cellSize,
            height: cellSize,
            decoration: BoxDecoration(
              color: cell ? Colors.black : Colors.white,
              borderRadius: BorderRadius.circular(cellSize / 5),
            ),
          ),
        ));
      });
      // Add the row to the game board
      gameBoard.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: rowWidgets,
      ));
    });
    // Update the grid with the new values
    _grid = _nextGrid.map((e) => e.toList()).toList();
    return gameBoard;
  }

  void togglePlay() {
    play = !play;
    notifyListeners();
  }

  void toggleCell(int i, int j) {
    _grid[i][j] = !_grid[i][j];
    notifyListeners();
  }

  Timer updateState([int milliseconds = 1000]) {
    return Timer(Duration(milliseconds: milliseconds), () {
      updateState(milliseconds);
      if (play) {
        notifyListeners();
      }
    });
  }

  int _countNeighbors(int i, int j) {
    int count = 0;
    for (int x = i - 1; x <= i + 1; x++) {
      for (int y = j - 1; y <= j + 1; y++) {
        if (x == i && y == j) continue;
        if (x < 0 || x >= size || y < 0 || y >= size) continue;
        if (_grid[x][y]) count++;
      }
    }
    return count;
  }

  List<List<bool>> get grid => _grid;

  set grid(List<List<bool>> grid) {
    _grid = grid;
    notifyListeners();
  }
}
