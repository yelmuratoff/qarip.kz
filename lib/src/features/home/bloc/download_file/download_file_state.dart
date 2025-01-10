part of 'download_file_cubit.dart';

sealed class DownloadFileState {
  const DownloadFileState();
}

final class DownloadFileInitial extends DownloadFileState {
  const DownloadFileInitial();
}

final class DownloadFileLoading extends DownloadFileState {
  const DownloadFileLoading();
}

final class DownloadFileSuccess extends DownloadFileState {
  const DownloadFileSuccess();
}

final class DownloadFileError extends DownloadFileState with EquatableMixin {
  const DownloadFileError({
    required this.error,
  });
  final String error;

  @override
  List<Object?> get props => [error];
}
