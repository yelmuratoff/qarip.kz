import 'package:base_starter/src/features/auth/domain/repositories/auth/remote_repository.dart';
import 'package:base_starter/src/features/auth/domain/repositories/user/local_repository.dart';

final class RepositoriesContainer {
  const RepositoriesContainer({
    required this.authRepository,
    required this.localUserRepository,
  });

  // <--- Repositories --->

  final IAuthRepository authRepository;

  final ILocalUserRepository localUserRepository;

  @override
  String toString() => '''RepositoriesContainer(
      authRepository: $authRepository,
      localUserRepository: $localUserRepository,
    );''';
}
