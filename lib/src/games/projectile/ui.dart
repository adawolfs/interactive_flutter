import 'package:flutter/material.dart';
import 'package:interactive_flutter/src/games/projectile/provider.dart';
import 'package:interactive_flutter/src/ui/generic_scaffold.dart';
import 'package:provider/provider.dart';

class ProjectileUI extends StatelessWidget {
  const ProjectileUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ProjectileProvider provider = Provider.of<ProjectileProvider>(context);
    return GenericScaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Projectile', style: TextStyle(fontSize: 30)),
          Text('Aceleration: ${provider.aceleration}',
              style: const TextStyle(fontSize: 20))
        ],
      ),
    );
  }
}
