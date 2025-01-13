import 'package:base_starter/src/features/home/data/repository/drive_repository.dart';
import 'package:base_starter/src/features/initialization/logic/composition_root.dart';
import 'package:base_starter/src/features/initialization/models/initialization_hook.dart';
import 'package:base_starter/src/features/initialization/models/repositories.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Factory that creates an instance of [RepositoriesContainer].
class RepositoriesFactory implements AsyncFactory<RepositoriesContainer> {
  const RepositoriesFactory({
    required this.hook,
    required this.prefs,
  });

  @override
  final InitializationHook hook;

  final SharedPreferences prefs;

  @override
  Future<RepositoriesContainer> create() async {
    final driveRepository = DriveRepository(
      prefs: prefs,
    );

    hook.onInitializing?.call(name);

    return RepositoriesContainer(
      driveRepository: driveRepository,
    );
  }

  @override
  String get name => 'Repositories';
}
