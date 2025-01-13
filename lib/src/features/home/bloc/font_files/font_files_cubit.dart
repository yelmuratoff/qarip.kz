// ignore_for_file: unused_field

import 'package:base_starter/src/features/home/data/models/storage_folder.dart';
import 'package:base_starter/src/features/home/domain/drive_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ispect/ispect.dart';
import 'package:stream_transform/stream_transform.dart';

part 'font_files_event.dart';
part 'font_files_state.dart';

class FontFilesBloc extends Bloc<FontFilesEvent, FontFilesState> {
  FontFilesBloc({
    required IDriveRepository repository,
  })  : _driveRepository = repository,
        super(const FontFilesInitial()) {
    on<FetchFontFilesEvent>(_onFetchFontFiles, transformer: _debounce());
  }

  final IDriveRepository _driveRepository;

  EventTransformer<FontFilesEvent> _debounce<FontFilesEvent>() =>
      (events, mapper) =>
          events.debounce(const Duration(milliseconds: 300)).switchMap(mapper);

  Future<void> _onFetchFontFiles(
    FetchFontFilesEvent event,
    Emitter<FontFilesState> emit,
  ) async {
    emit(const FontFilesLoading());

    try {
      final files = await _driveRepository.getFiles(
        path: event.path,
        pageToken: event.pageToken,
      );
      emit(
        FontFilesLoaded(
          files: files.files,
          hasMore: files.hasMore,
          nextPageToken: files.nextPageToken,
        ),
      );
    } catch (e, st) {
      ISpect.handle(exception: e, stackTrace: st);
      emit(
        FontFilesError(
          error: 'Failed to load fonts\npath: ${event.path}| error: $e',
        ),
      );
    }
  }
}
