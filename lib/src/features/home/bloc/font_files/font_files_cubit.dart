import 'package:base_starter/src/features/home/data/models/storage_file.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:ispect/ispect.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'font_files_event.dart';
part 'font_files_state.dart';

class FontFilesBloc extends Bloc<FontFilesEvent, FontFilesState> {
  FontFilesBloc() : super(const FontFilesInitial()) {
    on<FetchFontFilesEvent>(_onFetchFontFiles, transformer: _debounce());
  }

  final int _limit = 15; // Number of files to load per batch
  int _offset = 0; // Current offset for pagination
  bool _hasMore = true; // Flag to determine if there are more files to load
  final Set<String> _loadedFonts = {}; // Cache for already loaded fonts

  EventTransformer<FontFilesEvent> _debounce<FontFilesEvent>() =>
      (events, mapper) =>
          events.debounce(const Duration(milliseconds: 300)).switchMap(mapper);

  Future<void> _onFetchFontFiles(
    FetchFontFilesEvent event,
    Emitter<FontFilesState> emit,
  ) async {
    if (event.reset) {
      _offset = 0; // Reset the offset
      _hasMore = true; // Reset the flag to allow loading more files
      emit(const FontFilesLoading());
    }

    if (!_hasMore) return; // Do nothing if there are no more files to load

    try {
      final files = await Supabase.instance.client.storage.from('fonts').list(
            path: event.path,
            searchOptions: SearchOptions(
              limit: _limit,
              offset: _offset,
            ),
          );

      if (files.isEmpty) {
        _hasMore = false; // No more files to load
      }

      // Increment the offset for the next batch
      _offset += _limit;

      // Parallel loading of fonts
      final loadTasks = files.map((file) async {
        if (file.id != null && !_loadedFonts.contains(file.name)) {
          final uint8List = await Supabase.instance.client.storage
              .from('fonts')
              .download(event.path);

          final byteData = ByteData.sublistView(uint8List);

          final fontLoader = FontLoader(file.name)
            ..addFont(Future.value(byteData));
          await fontLoader.load();
          _loadedFonts.add(file.name); // Add the font to the cache
        }
        return StorageFile.fromFileObject(file);
      });

      final loadedFiles = await Future.wait(loadTasks);

      // Update the state
      final currentState = state;
      final allFiles = event.reset || currentState is! FontFilesLoaded
          ? loadedFiles
          : [...currentState.files, ...loadedFiles];

      emit(FontFilesLoaded(files: allFiles));
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
