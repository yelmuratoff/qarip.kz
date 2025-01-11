import 'package:base_starter/src/core/rest_client/dio_rest_client/rest_client.dart';
import 'package:base_starter/src/features/initialization/logic/composition_root.dart';
import 'package:base_starter/src/features/initialization/models/initialization_hook.dart';
import 'package:base_starter/src/features/initialization/models/repositories.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Factory that creates an instance of [RepositoriesContainer].
class RepositoriesFactory implements AsyncFactory<RepositoriesContainer> {
  const RepositoriesFactory({
    required this.hook,
    required this.restClient,
    required this.sharedPreferences,
  });

  @override
  final InitializationHook hook;
  final RestClientBase restClient;
  final SharedPreferences sharedPreferences;

  @override
  Future<RepositoriesContainer> create() async {
    // <--- Data sources initialization --->

    // <--- Repositories initialization --->

    hook.onInitializing?.call(name);

    return const RepositoriesContainer();
  }

  @override
  String get name => 'Repositories';
}
