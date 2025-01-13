import 'package:base_starter/src/common/utils/extensions/context_extension.dart';
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
            child: Container(
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
                              'Folder',
                              // file.isFolder
                              //     ? L10n.current.folder
                              //     : file.mimeType ?? '',
                              style: context.textStyles.s12w400.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: Icon(
                              // file.isFolder
                              //     ? IconsaxPlusLinear.arrow_right_3
                              //     : IconsaxPlusLinear.arrow_down_2,
                              IconsaxPlusLinear.arrow_right_3,
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            file.name ?? '',
                            textAlign: TextAlign.center,
                            style: context.textStyles.s16w400.copyWith(
                              // fontFamily: file.isFolder ? null : file.name,

                              color: context.theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
}
