part of 'font_files_cubit.dart';

sealed class FontFilesEvent {
  const FontFilesEvent();
}

final class FetchFontFilesEvent extends FontFilesEvent with EquatableMixin {
  const FetchFontFilesEvent({
    required this.path,
    this.reset = false,
    this.pageToken,
  });

  final String path;
  final String? pageToken;
  final bool reset;

  @override
  List<Object?> get props => [
        reset,
        path,
        pageToken,
      ];
}
