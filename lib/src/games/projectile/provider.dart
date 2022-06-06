import 'package:flutter/material.dart';
import 'package:interactive_flutter/src/games/projectile/ui.dart';

class ProjectileProvider extends ChangeNotifier {
  double aceleration = 0;
  double velocity = 0;
  double _angle = 0;
  ProjectileFlame _game = ProjectileFlame();

  ProjectileFlame get game => _game;

  set game(game) {
    _game = game;
  }

  set acelerationValue(double value) {
    aceleration = value;
    notifyListeners();
  }

  set angle(double value) {
    _angle = value;
    game.cannon.angle = -_angle;
    notifyListeners();
  }

  double get angle => _angle;
}
