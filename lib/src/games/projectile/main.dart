import 'package:flutter/material.dart';
import 'package:interactive_flutter/src/games/projectile/provider.dart';
import 'package:interactive_flutter/src/games/projectile/ui.dart';
import 'package:provider/provider.dart';

class Projectile extends StatelessWidget {
  const Projectile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProjectileProvider(),
      child: const ProjectileUI(),
    );
  }
}
