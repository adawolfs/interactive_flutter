import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TetrixBloc extends Bloc<TetrixEvent, TetrixState> {
  static TetrixShape getRandomShape() {
    // Get random number between 0 and 6 using date
    final random = Random(DateTime.now().millisecondsSinceEpoch).nextInt(7);
    switch (random) {
      case 0:
        return TetrixShapeL(0, -3, 0);
      case 1:
        return TetrixShapeO(0, -3, 0);
      case 2:
        return TetrixShapeS(0, -3, 0);
      case 3:
        return TetrixShapeL(0, -3, 0).mirror();
      case 4:
        return TetrixShapeS(0, -3, 0).mirror();
      case 5:
        return TetrixShapeO(0, -3, 0);
      case 6:
        return TetrixShapeS(0, -3, 0);
      default:
        return TetrixShapeL(0, -3, 0);
    }
  }

  final stateHistory = <TetrixState>[];
  TetrixBloc() : super(TetrixInitial(activeShape: getRandomShape())) {
    on<TetrixEvent>((event, emit) {});
    on<TetrixRestart>((event, emit) {
      emit(TetrixInitial(activeShape: getRandomShape()));
      add(TetrixRepaint());
    });
    on<TetrixRotate>((event, emit) {
      var nextState = TetrixPaint(
          background: state.background,
          activeShape: state.activeShape.rotate());
      if (!nextState.hasColided) {
        emit(nextState);
      }
    });
    on<TetrixMoveLeft>((event, emit) {
      var nextState = TetrixPaint(
          background: state.background,
          activeShape: state.activeShape.moveLeft());
      if (!nextState.hasColided) {
        emit(nextState);
      }
    });
    on<TetrixMoveRight>((event, emit) {
      var nextState = TetrixPaint(
          background: state.background,
          activeShape: state.activeShape.moveRight());
      if (!nextState.hasColided) {
        emit(nextState);
      }
    });
    on<TetrixMoveDown>((event, emit) {
      var nextState = TetrixPaint(
          background: state.background,
          activeShape: state.activeShape.moveDown());
      if (nextState.isGameOver()) {
        emit(TetrixGameOver(
            background: state.background, activeShape: state.activeShape));
        return;
      }
      if (nextState.hasColided) {
        emit(TetrixPaint(
            background: stateHistory[stateHistory.length - 1].board,
            activeShape: getRandomShape(),
            cleanLines: true));
      } else {
        emit(nextState);
      }
    });
    on<TetrixRepaint>((event, emit) {
      Future.delayed(const Duration(milliseconds: 1000), () {
        if (!state.isGameOver()) {
          add(TetrixRepaint());
        }
        add(TetrixMoveDown());
      });
    });
    on<TetrixLoop>((event, emit) {});
    add(TetrixRepaint());
  }

  @override
  void onTransition(Transition<TetrixEvent, TetrixState> transition) {
    super.onTransition(transition);
    stateHistory.add(transition.nextState);
  }
}

abstract class TetrixEvent {}

class TetrixGameOver extends TetrixState {
  TetrixGameOver({required super.background, required super.activeShape});
}

class TetrixRestart extends TetrixEvent {}

class TetrixRun extends TetrixEvent {}

class TetrixLoop extends TetrixEvent {}

class TetrixMoveLeft extends TetrixEvent {}

class TetrixMoveRight extends TetrixEvent {}

class TetrixMoveDown extends TetrixEvent {}

class TetrixRotate extends TetrixEvent {}

class TetrixRepaint extends TetrixEvent {}

@immutable
abstract class TetrixState {
  late final TetrixShape activeShape;
  late final List<List<bool>> background;
  late final List<List<bool>> board;
  late final bool hasColided;
  // late final bool isGameOver;

  bool isGameOver() {
    bool isGameOver = false;
    for (var i = 0; i < background[0].length; i++) {
      if (background[0][i]) {
        isGameOver = true;
      }
    }
    return isGameOver;
  }

  TetrixState({
    required this.background,
    required this.activeShape,
    cleanLines = false,
  }) {
    board = List.generate(
        background.length,
        (i) =>
            List.generate(background[0].length, (j) => false, growable: false));
    bool tempHasColided = activeShape.hasColided();
    List<int> removeLines = [];
    for (int i = 0; i < background.length; i++) {
      bool rowIsFull = true;
      for (int j = 0; j < background[i].length; j++) {
        if (background[i][j]) {
          board[i][j] = true;
        }
        if (i >= activeShape.y &&
            i < activeShape.y + activeShape.shape.length &&
            j >= activeShape.x &&
            j < activeShape.x + activeShape.shape.length) {
          var x = j - activeShape.x;
          var y = i - activeShape.y;
          if (activeShape.shape[x][y]) {
            tempHasColided = board[i][j] ? true : tempHasColided;
            board[i][j] = true;
          }
        }
        if (!board[i][j]) {
          rowIsFull = false;
        }
      }
      if (rowIsFull) {
        removeLines.add(i);
      }
    }
    hasColided = tempHasColided;
    if (cleanLines) {
      for (var line in removeLines) {
        background.removeAt(line);
        background.insert(0, List.generate(background[0].length, (i) => false));
      }
    }
    if (board.isEmpty) {
      List.generate(10, (index) => List.generate(20, (index) => false));
    }
  }
}

class TetrixInitial extends TetrixState {
  TetrixInitial({required activeShape})
      : super(
            background: List.generate(
                20, (index) => List.generate(10, (index) => false)),
            activeShape: activeShape);
}

class TetrixPaint extends TetrixState {
  TetrixPaint(
      {required super.background,
      required super.activeShape,
      super.cleanLines = false});
}

class TetrixShape {
  late final List<List<bool>> shape;
  final int x;
  final int y;
  final int angle;
  TetrixShape(this.x, this.y, this.angle, {newShape}) {
    if (newShape != null) {
      shape = newShape;
    } else {
      shape = List.generate(4, (index) => List.generate(4, (index) => false));
    }
  }

  bool hasColided() {
    for (int i = 0; i < shape.length; i++) {
      for (int j = 0; j < shape[i].length; j++) {
        if (shape[i][j]) {
          if (x + i < 0 || x + i > 9 || y + j > 19) {
            return true;
          }
        }
      }
    }
    return false;
  }

  // Mirror the shape around the x axis
  TetrixShape mirror() {
    return TetrixShape(x, y, angle,
        newShape: shape.map((e) => e.toList()).toList().reversed.toList());
  }

  TetrixShape rotate() {
    final newShape =
        List.generate(4, (index) => List.generate(4, (index) => false));
    for (var i = 0; i < 4; i++) {
      for (var j = 0; j < 4; j++) {
        newShape[i][j] = shape[j][3 - i];
      }
    }
    return TetrixShape(x, y, (angle + 1) % 4, newShape: newShape);
  }

  TetrixShape moveLeft() {
    return TetrixShape(x - 1, y, angle, newShape: shape);
  }

  TetrixShape moveRight() {
    return TetrixShape(x + 1, y, angle, newShape: shape);
  }

  TetrixShape moveDown() {
    return TetrixShape(x, y + 1, angle, newShape: shape);
  }

  TetrixShape moveUp() {
    return TetrixShape(x, y - 1, angle, newShape: shape);
  }

  TetrixShape move(int x, int y) {
    return TetrixShape(this.x + x, this.y + y, angle);
  }

  bool canMove(int x, int y) {
    return x >= 0 && x + shape.length < 10 && y >= 0 && y + shape.length <= 20;
  }

  bool canMoveLeft() {
    return canMove(x - 1, y);
  }

  bool canMoveRight() {
    return canMove(x + 1, y);
  }

  bool canMoveDown() {
    return canMove(x, y + 1);
  }

  bool canMoveUp() {
    return canMove(x, y - 1);
  }

  bool canRotate() {
    final newShape =
        List.generate(4, (index) => List.generate(4, (index) => false));
    for (var i = 0; i < 4; i++) {
      for (var j = 0; j < 4; j++) {
        newShape[i][j] = shape[j][3 - i];
      }
    }
    for (var i = 0; i < 4; i++) {
      for (var j = 0; j < 4; j++) {
        if (newShape[i][j] && !canMove(x + i, y + j)) {
          return false;
        }
      }
    }
    return true;
  }
}

// Create a new class that extends TetrixShape and configure it with the shape
//  0 0 0 0
//  0 x x 0
//  x x 0 0
//  0 0 0 0

class TetrixShapeS extends TetrixShape {
  TetrixShapeS(int x, int y, int angle) : super(x, y, angle) {
    shape[0][2] = true;
    shape[1][1] = true;
    shape[1][2] = true;
    shape[2][1] = true;
  }
}

// Create a new class that extends TetrixShape and configure it with the shape
//  0 0 0 0
//  0 x 0 0
//  x x x 0
//  0 0 0 0

class TetrixShapeT extends TetrixShape {
  TetrixShapeT(int x, int y, int angle) : super(x, y, angle) {
    shape[0][1] = true;
    shape[1][1] = true;
    shape[1][2] = true;
    shape[2][2] = true;
  }
}

// Create a new class that extends TetrixShape and configure it with the shape
//  0 0 0 0
//  0 x 0 0
//  0 x 0 0
//  0 x x 0

class TetrixShapeL extends TetrixShape {
  TetrixShapeL(int x, int y, int angle) : super(x, y, angle) {
    shape[1][1] = true;
    shape[1][2] = true;
    shape[1][3] = true;
    shape[2][3] = true;
  }
}

// Create a new class that extends TetrixShape and configure it with the shape
//  0 0 0 0
//  0 x x 0
//  0 x x 0
//  0 0 0 0
class TetrixShapeO extends TetrixShape {
  TetrixShapeO(int x, int y, int angle) : super(x, y, angle) {
    shape[1][1] = true;
    shape[1][2] = true;
    shape[2][1] = true;
    shape[2][2] = true;
  }
}
