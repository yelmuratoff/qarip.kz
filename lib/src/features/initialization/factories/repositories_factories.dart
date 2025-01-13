import 'package:base_starter/src/features/home/data/repository/drive_repository.dart';
import 'package:base_starter/src/features/initialization/logic/composition_root.dart';
import 'package:base_starter/src/features/initialization/models/initialization_hook.dart';
import 'package:base_starter/src/features/initialization/models/repositories.dart';

/// Factory that creates an instance of [RepositoriesContainer].
class RepositoriesFactory implements AsyncFactory<RepositoriesContainer> {
  const RepositoriesFactory({
    required this.hook,
  });

  @override
  final InitializationHook hook;

  @override
  Future<RepositoriesContainer> create() async {
    const driveRepository = DriveRepository();

    hook.onInitializing?.call(name);

    return const RepositoriesContainer(
      driveRepository: driveRepository,
    );
  }

  @override
  String get name => 'Repositories';
}
