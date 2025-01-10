import 'package:flutter/material.dart';

class FolderScreen extends StatelessWidget {
  const FolderScreen({
    required this.path,
  });

  final String? path;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(path ?? ''),
        ),
        body: const Center(
          child: Text('Folder content'),
        ),
      );
}
