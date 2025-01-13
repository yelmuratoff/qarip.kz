part of 'drive_files_bloc.dart';

sealed class DriveFilesState {
  const DriveFilesState();
}

final class DriveFilesInitial extends DriveFilesState {
  const DriveFilesInitial();
}

final class DriveFilesLoading extends DriveFilesState {
  const DriveFilesLoading();
}

final class DriveFilesLoaded extends DriveFilesState with EquatableMixin {
  const DriveFilesLoaded({
    required this.pagination,
  });

  final PaginationFiles pagination;

  @override
  List<Object> get props => [pagination];
}

final class DriveFilesError extends DriveFilesState with EquatableMixin {
  const DriveFilesError({
    required this.message,
  });

  final String message;

  @override
  List<Object> get props => [message];
}
