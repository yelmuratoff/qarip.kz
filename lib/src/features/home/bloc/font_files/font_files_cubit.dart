import 'package:base_starter/src/features/home/data/models/storage_file.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ispect/ispect.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'font_files_state.dart';

class FontFilesCubit extends Cubit<FontFilesState> {
  FontFilesCubit() : super(const FontFilesInitial());

  Future<void> get({
    required String category,
  }) async {
    emit(const FontFilesLoading());
    try {
      final files = await Supabase.instance.client.storage
          .from('fonts')
          .list(path: category);
      emit(
        FontFilesLoaded(
          files: files.map(StorageFile.fromFileObject).toList(),
        ),
      );
    } catch (e, st) {
      ISpect.handle(
        exception: e,
        stackTrace: st,
      );
      emit(FontFilesError(error: e.toString()));
    }
  }
}
