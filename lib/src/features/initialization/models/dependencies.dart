import 'package:base_starter/src/features/settings/presentation/bloc/settings_bloc.dart';

import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

final class DependenciesContainer {
  const DependenciesContainer({
    required this.sharedPreferences,
    required this.packageInfo,
    required this.settingsBloc,
  });

  // <--- External dependencies --->
  final SharedPreferences sharedPreferences;
  final PackageInfo packageInfo;

  // <--- Internal dependencies --->
  final SettingsBloc settingsBloc;

  @override
  String toString() => '''DependenciesContainer(
      sharedPreferences:$sharedPreferences,
      packageInfo: $packageInfo,
      settingsBloc: $settingsBloc,
    )''';
}
