import 'dart:async';

import 'package:base_starter/src/app/router/routes/router.dart';
import 'package:base_starter/src/app/router/widgets/route_wrapper.dart';
import 'package:base_starter/src/common/presentation/widgets/buttons/app_button.dart';
import 'package:base_starter/src/common/presentation/widgets/dialogs/app_dialogs.dart';
import 'package:base_starter/src/common/utils/extensions/context_extension.dart';
import 'package:base_starter/src/core/l10n/localization.dart';
import 'package:base_starter/src/features/home/bloc/download_file/download_file_cubit.dart';
import 'package:base_starter/src/features/home/bloc/font_categories/font_categories.dart';
import 'package:base_starter/src/features/home/bloc/font_files/font_files_cubit.dart';
import 'package:base_starter/src/features/home/controllers/files_controller.dart';
import 'package:base_starter/src/features/home/data/models/storage_file.dart';
import 'package:base_starter/src/features/home/presentation/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:octopus/octopus.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget implements RouteWrapper {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();

  @override
  Widget wrappedRoute(BuildContext context) => BlocProvider(
        create: (_) => FontFilesBloc(),
        child: this,
      );
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        final selectedCategory =
            context.read<FilesController>().selectedCategory;

        if (selectedCategory != null) {
          context.read<FontFilesBloc>().add(
                FetchFontFilesEvent(
                  path: selectedCategory.name,
                ),
              );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: context.theme.colorScheme.surface,
        body: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverPersistentHeader(
              pinned: true,
              delegate: QaripAppBanner(),
            ),
            const SliverGap(32),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverToBoxAdapter(
                child: Text(
                  L10n.current.kazakhFontFund,
                  textAlign: TextAlign.center,
                  style: context.textStyles.s24w700,
                ),
              ),
            ),
            const SliverGap(16),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverToBoxAdapter(
                child: Text(
                  L10n.current.qaripSiteDescription,
                  textAlign: TextAlign.center,
                  style: context.textStyles.s20w400.copyWith(
                    color: context.theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
            const SliverGap(32),
            SliverToBoxAdapter(
              child: Consumer<FilesController>(
                builder: (context, controller, child) =>
                    BlocConsumer<FontCategoriesCubit, FontCategoriesState>(
                  listener: (context, state) {
                    if (state is FontCategoriesLoaded) {
                      controller.selectedCategory =
                          state.categories.firstOrNull;

                      if (controller.selectedCategory != null) {
                        context.read<FontFilesBloc>().add(
                              FetchFontFilesEvent(
                                path: controller.selectedCategory!.name,
                              ),
                            );
                      }
                    }
                  },
                  builder: (context, state) => switch (state) {
                    FontCategoriesLoaded() => FontCategoriesList(
                        categories: state.categories,
                        selectedCategory: controller.selectedCategory,
                        onSelected: ({selectedFile}) {
                          controller.selectedCategory = selectedFile;
                          if (selectedFile != null) {
                            context.read<FontFilesBloc>().add(
                                  FetchFontFilesEvent(
                                    path: selectedFile.name,
                                    reset: true,
                                  ),
                                );
                          }
                        },
                      ),
                    _ => const SizedBox.shrink(),
                  },
                ),
              ),
            ),
            const SliverGap(16),
            Consumer<FilesController>(
              builder: (context, controller, child) =>
                  BlocConsumer<FontFilesBloc, FontFilesState>(
                listener: (context, state) {
                  switch (state) {
                    case FontFilesLoading():
                      AppDialogs.showLoader(context);
                    default:
                      AppDialogs.dismiss();
                  }
                },
                builder: (context, state) => switch (state) {
                  FontFilesLoaded() => FilesSliverList(
                      files: state.files,
                      onTap: ({required file, required path}) {
                        if (file.isFolder) {
                          context.octopus.push(
                            Routes.folder,
                            arguments: {
                              'path': file.name,
                              'category':
                                  controller.selectedCategory?.name ?? '',
                            },
                          );
                        } else {
                          context.read<DownloadFileCubit>().downloadFile(
                                path: file.name,
                                category: controller.selectedCategory!.name,
                              );
                        }
                      },
                    ),
                  _ => const SliverToBoxAdapter(),
                },
              ),
            ),
            const SliverGap(16),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  height: 50,
                  child: AppButton(
                    onPressed: () {},
                    text: L10n.current.addNewFont,
                    textColor: Colors.white,
                  ),
                ),
              ),
            ),
            const SliverGap(32),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverToBoxAdapter(
                child: Text.rich(
                  TextSpan(
                    text: '${L10n.current.emailForSuggestionsAndQuestions}: ',
                    style: context.textStyles.s20w500,
                    children: [
                      TextSpan(
                        text: 'ylmuratovyelaman@gmail.com',
                        style: context.textStyles.s24w700.copyWith(
                          color: context.theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                  style: context.textStyles.s24w700,
                ),
              ),
            ),
            const SliverGap(16),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverToBoxAdapter(
                child: Text.rich(
                  TextSpan(
                    text: '${L10n.current.thanksToGroup} ',
                    style: context.textStyles.s14w400,
                    children: [
                      TextSpan(
                        text: 'https://vk.com/kazfont 💙',
                        style: context.textStyles.s14w500.copyWith(
                          color: context.theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                  style: context.textStyles.s24w700,
                ),
              ),
            ),
            const SliverGap(32),
          ],
        ),
      );
}

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
                      path: file.name,
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
                              file.isFolder
                                  ? L10n.current.folder
                                  : file.mimeType,
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
                          child: Text(
                            file.name,
                            textAlign: TextAlign.center,
                            style: context.textStyles.s16w400.copyWith(
                              fontFamily: file.isFolder ? null : file.name,
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
                right: index == 9 ? 16 : 0,
              ),
              child: FontCategoryItem(
                name: category.name,
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
