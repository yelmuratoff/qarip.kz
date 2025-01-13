part of 'drive_files_bloc.dart';

sealed class DriveFilesEvent {
  const DriveFilesEvent();
}

final class LoadDriveFiles extends DriveFilesEvent with EquatableMixin {
  const LoadDriveFiles({
    required this.path,
    this.pageToken,
  });

  final String path;
  final String? pageToken;

  @override
  List<Object?> get props => [path, pageToken];
}
