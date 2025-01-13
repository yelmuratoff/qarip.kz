import 'package:base_starter/src/common/utils/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class FontCategoryItem extends StatelessWidget {
  const FontCategoryItem({
    required this.name,
    required this.onSelected,
    this.isSelected = false,
    super.key,
  });

  final String name;
  final bool isSelected;
  final void Function({
    required bool selected,
  }) onSelected;

  @override
  Widget build(BuildContext context) => ChoiceChip(
        label: Text(
          name,
          style: context.textStyles.s14w400.copyWith(
            color: isSelected
                ? Colors.white
                : context.theme.colorScheme.onSurfaceVariant,
          ),
        ),
        checkmarkColor: Colors.white,
        selected: isSelected,
        side: BorderSide(
          color: context.colors.border,
        ),
        onSelected: (selected) {
          onSelected(selected: selected);
        },
        backgroundColor: context.theme.colorScheme.surface,
        selectedColor: context.theme.colorScheme.primary,
      );
}
