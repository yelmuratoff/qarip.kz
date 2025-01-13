part of 'font_files_cubit.dart';

sealed class FontFilesState {
  const FontFilesState();
}

final class FontFilesInitial extends FontFilesState {
  const FontFilesInitial();
}

final class FontFilesLoading extends FontFilesState {
  const FontFilesLoading();
}

final class FontFilesLoaded extends FontFilesState with EquatableMixin {
  const FontFilesLoaded({
    required this.files,
    required this.hasMore,
    required this.nextPageToken,
  });
  final List<StorageFile> files;
  final String? nextPageToken;
  final bool hasMore;

  @override
  List<Object?> get props => [files, hasMore, nextPageToken];
}

final class FontFilesError extends FontFilesState with EquatableMixin {
  const FontFilesError({
    required this.error,
  });
  final String error;

  @override
  List<Object?> get props => [error];
}
