import 'package:base_starter/src/common/utils/extensions/context_extension.dart';
import 'package:base_starter/src/core/l10n/localization.dart';
import 'package:base_starter/src/features/home/data/models/storage_folder.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class FilesSliverList extends StatelessWidget {
  const FilesSliverList({
    this.files = const [],
    this.onTap,
    super.key,
  });

  final List<StorageFile> files;
  final void Function({
    required StorageFile file,
    required String path,
  })? onTap;

  @override
  Widget build(BuildContext context) => SliverList.builder(
        itemCount: files.length,
        itemBuilder: (context, index) {
          final file = files[index];
          return Padding(
            padding: const EdgeInsets.all(8),
            child: FileCard(onTap: onTap, file: file),
          );
        },
      );
}

class FileCard extends StatelessWidget {
  const FileCard({
    required this.onTap,
    required this.file,
    super.key,
  });

  final void Function({required StorageFile file, required String path})? onTap;
  final StorageFile file;

  @override
  Widget build(BuildContext context) => Container(
        height: 80,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: context.theme.colorScheme.surface,
          borderRadius: const BorderRadius.all(
            Radius.circular(16),
          ),
          border: Border.all(
            color: context.colors.border,
            strokeAlign: BorderSide.strokeAlignOutside,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              onTap?.call(
                file: file,
                path: file.name ?? '',
              );
            },
            borderRadius: const BorderRadius.all(
              Radius.circular(16),
            ),
            child: SizedBox.square(
              dimension: 150,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: context.theme.colorScheme.primary,
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(12),
                        ),
                      ),
                      child: Text(
                        file.mimeType ?? L10n.current.folder,
                        style: context.textStyles.s12w400.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Icon(
                        file.isFolder
                            ? IconsaxPlusLinear.arrow_right_3
                            : IconsaxPlusLinear.arrow_down_2,
                      ),
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          file.name ?? '',
                          textAlign: TextAlign.center,
                          style: context.textStyles.s16w400.copyWith(
                            color: context.theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        if (!file.isFolder)
                          Text(
                            'Қазақтың көркем тілі – ұлттың рухани қазынасы',
                            textAlign: TextAlign.center,
                            style: context.textStyles.s16w400.copyWith(
                              fontFamily:
                                  file.isFolder ? null : file.withoutExtension,
                              color: context.theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
