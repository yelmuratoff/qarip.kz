import 'package:base_starter/src/features/home/controllers/files_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ControllersScope extends StatelessWidget {
  const ControllersScope({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => FilesController(),
          ),
        ],
        child: child,
      );
}
