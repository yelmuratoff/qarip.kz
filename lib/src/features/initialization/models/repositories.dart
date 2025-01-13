import 'package:base_starter/src/features/home/domain/drive_repository.dart';

final class RepositoriesContainer {
  const RepositoriesContainer({
    required this.driveRepository,
  });

  // <--- Repositories --->

  final IDriveRepository driveRepository;

  @override
  String toString() => '''RepositoriesContainer(
    driveRepository: $driveRepository,
    );''';
}
