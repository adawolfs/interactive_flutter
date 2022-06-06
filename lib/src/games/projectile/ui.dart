import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:interactive_flutter/src/games/projectile/provider.dart';
import 'package:interactive_flutter/src/ui/generic_scaffold.dart';
import 'package:provider/provider.dart';

// late ProjectileFlame game;

class ProjectileUI extends StatelessWidget {
  const ProjectileUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ProjectileProvider provider = Provider.of<ProjectileProvider>(context);
    return GenericScaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Projectile', style: TextStyle(fontSize: 30)),
            Text('Aceleration: ${provider.aceleration}',
                style: const TextStyle(fontSize: 20)),
            SizedBox(
              height: 400,
              width: 400,
              child: RepaintBoundary(
                child: GameWidget(
                    // game: game,
                    game: provider.game),
              ),
            ),
            Slider(
                value: provider.angle,
                min: 0,
                max: pi / 2,
                onChanged: (value) => provider.angle = value),
            ElevatedButton(onPressed: () {}, child: const Text("Launch"))
          ],
        ),
      ),
    );
  }
}

class ProjectileFlame extends FlameGame {
  late CannonComponent cannon;
  ProjectileFlame();

  @override
  void onMount() {
    camera.viewport = FixedResolutionViewport(Vector2(400, 400));
    cannon = CannonComponent()
      ..anchor = Anchor.bottomLeft
      ..position = Vector2(200, 200);

    add(cannon);
  }
}

class CannonComponent extends PositionComponent {
  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = Colors.red;
    const rect = Rect.fromLTWH(0, 0, 50, 20);
    canvas.drawRect(rect, paint);
  }

  @override
  void update(double dt) {}
}
