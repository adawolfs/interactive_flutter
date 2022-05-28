import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class GenericScaffold extends StatelessWidget {
  final Widget body;
  const GenericScaffold({Key? key, required this.body}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Interactive Flutter'),
        actions: [
          IconButton(
              icon: const Icon(Icons.code),
              onPressed: () async {
                final Uri url = Uri.parse(
                    'https://github.com/adawolfs/interactive_flutter');
                await launchUrl(url);
              })
        ],
      ),
      body: body,
    );
  }
}
