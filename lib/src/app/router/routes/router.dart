import 'package:base_starter/src/features/auth/presentation/auth_screen.dart';
import 'package:base_starter/src/features/home/presentation/home_screen.dart';
import 'package:base_starter/src/features/initialization/presentation/page/splash.dart';
import 'package:base_starter/src/features/profile/presentation/profile_screen.dart';
import 'package:base_starter/src/features/settings/presentation/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:octopus/octopus.dart';

enum Routes with OctopusRoute {
  splash('splash', title: 'Splash'),
  auth('auth', title: 'Auth'),
  home('home', title: 'Home'),
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
        Routes.auth => const AuthScreen(),
        Routes.home => const HomeScreen().wrappedRoute(context),
        Routes.profile => const ProfileScreen(),
        Routes.settings => SettingsScreen(
            title: node.arguments['title'],
          ),
      };

  // @override
  // Page<Object?> pageBuilder(
  //   BuildContext context,
  //   OctopusState state,
  //   OctopusNode node,
  // ) =>
  //     MaterialPage<Object?>(
  //       key: createKey(node),
  //       child: InheritedOctopusRoute(
  //         node: node,
  //         child: builder(context, state, node),
  //       ),
  //       name: node.name,
  //       arguments: node.arguments,
  //       fullscreenDialog: node.name.endsWith('-dialog'),
  //     );
}
