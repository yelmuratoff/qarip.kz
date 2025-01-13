import 'package:base_starter/src/features/home/data/models/storage_folder.dart';
import 'package:base_starter/src/features/home/presentation/widgets/category_item.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:ui/ui.dart';

class FontCategoriesList extends StatelessWidget {
  const FontCategoriesList({
    this.categories = const [],
    this.selectedCategory,
    this.onSelected,
    super.key,
  });

  final List<StorageFile> categories;
  final StorageFile? selectedCategory;
  final void Function({
    StorageFile? selectedFile,
  })? onSelected;

  static const loader = _FontCategoriesListLoading();

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 35,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          separatorBuilder: (context, index) => const Gap(8),
          itemBuilder: (context, index) {
            final category = categories[index];
            return Padding(
              padding: EdgeInsets.only(
                left: index == 0 ? 16 : 0,
                right: index == categories.length - 1 ? 16 : 0,
              ),
              child: FontCategoryItem(
                name: category.name ?? '',
                isSelected: selectedCategory == category,
                onSelected: ({required selected}) {
                  onSelected?.call(selectedFile: selected ? category : null);
                },
              ),
            );
          },
        ),
      );
}

class _FontCategoriesListLoading extends StatelessWidget {
  const _FontCategoriesListLoading();

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 35,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: 10,
          separatorBuilder: (context, index) => const Gap(8),
          itemBuilder: (context, index) => Padding(
            padding: EdgeInsets.only(
              left: index == 0 ? 16 : 0,
              right: index == 9 ? 16 : 0,
            ),
            child: const ShimmerBox(
              width: 100,
              height: 35,
              radius: 8,
            ),
          ),
        ),
      );
}
