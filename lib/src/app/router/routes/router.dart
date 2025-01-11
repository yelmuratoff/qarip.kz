import 'package:base_starter/src/features/home/presentation/folder_screen.dart';
import 'package:base_starter/src/features/home/presentation/home_screen.dart';
import 'package:base_starter/src/features/initialization/presentation/screens/splash.dart';
import 'package:base_starter/src/features/profile/presentation/profile_screen.dart';
import 'package:base_starter/src/features/settings/presentation/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:octopus/octopus.dart';

enum Routes with OctopusRoute {
  splash('splash', title: 'Splash'),
  home('home', title: 'Home'),
  folder('folder', title: 'Folder'),
  profile('profile', title: 'Profile'),
  settings('settings', title: 'Settings');

  const Routes(this.name, {this.title});

  @override
  final String name;

  @override
  final String? title;

  @override
  Widget builder(BuildContext context, OctopusState state, OctopusNode node) =>
      switch (this) {
        Routes.splash => const SplashScreen(),
        Routes.home => const HomeScreen().wrappedRoute(
            context,
          ),
        Routes.folder => FolderScreen(
            category: node.arguments['category'],
            path: node.arguments['path'],
          ).wrappedRoute(
            context,
          ),
        Routes.profile => const ProfileScreen(),
        Routes.settings => SettingsScreen(
            title: node.arguments['title'],
          ),
      };
}
