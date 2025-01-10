part of 'font_categories.dart';

sealed class FontCategoriesState {
  const FontCategoriesState();
}

final class FontCategoriesInitial extends FontCategoriesState {
  const FontCategoriesInitial();
}

final class FontCategoriesLoading extends FontCategoriesState {
  const FontCategoriesLoading();
}

final class FontCategoriesLoaded extends FontCategoriesState
    with EquatableMixin {
  const FontCategoriesLoaded({
    required this.categories,
  });
  final List<StorageFile> categories;

  @override
  List<Object?> get props => [categories];
}

final class FontCategoriesError extends FontCategoriesState
    with EquatableMixin {
  const FontCategoriesError({
    required this.error,
  });
  final String error;

  @override
  List<Object?> get props => [error];
}
