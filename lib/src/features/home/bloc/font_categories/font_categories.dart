import 'package:base_starter/src/features/home/data/models/storage_folder.dart';
import 'package:base_starter/src/features/home/domain/drive_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ispect/ispect.dart';

part 'font_categories_state.dart';

class FontCategoriesCubit extends Cubit<FontCategoriesState> {
  FontCategoriesCubit({
    required IDriveRepository repository,
  })  : _repository = repository,
        super(const FontCategoriesInitial());

  final IDriveRepository _repository;

  Future<void> get() async {
    emit(const FontCategoriesLoading());
    try {
      final categories = await _repository.getCategories();
      emit(FontCategoriesLoaded(categories: categories));
    } catch (e, st) {
      ISpect.handle(
        exception: e,
        stackTrace: st,
      );
      emit(FontCategoriesError(error: e.toString()));
    }
  }
}
