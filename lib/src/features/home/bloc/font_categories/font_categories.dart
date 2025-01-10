import 'package:base_starter/src/features/home/data/models/storage_file.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ispect/ispect.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'font_categories_state.dart';

class FontCategoriesCubit extends Cubit<FontCategoriesState> {
  FontCategoriesCubit() : super(const FontCategoriesInitial());

  Future<void> get() async {
    emit(const FontCategoriesLoading());
    try {
      final categories =
          await Supabase.instance.client.storage.from('fonts').list();
      emit(
        FontCategoriesLoaded(
          categories: categories.map(StorageFile.fromFileObject).toList(),
        ),
      );
    } catch (e, st) {
      ISpect.handle(
        exception: e,
        stackTrace: st,
      );
      emit(FontCategoriesError(error: e.toString()));
    }
  }
}
