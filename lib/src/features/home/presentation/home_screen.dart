import 'dart:async';

import 'package:base_starter/src/app/router/routes/router.dart';
import 'package:base_starter/src/common/presentation/widgets/buttons/app_button.dart';
import 'package:base_starter/src/common/presentation/widgets/buttons/theme_switcher.dart';
import 'package:base_starter/src/common/utils/extensions/context_extension.dart';
import 'package:base_starter/src/common/utils/extensions/string_extension.dart';
import 'package:base_starter/src/core/l10n/localization.dart';
import 'package:base_starter/src/features/home/bloc/download_file/download_file_cubit.dart';
import 'package:base_starter/src/features/home/bloc/font_categories/font_categories.dart';
import 'package:base_starter/src/features/home/bloc/font_files/font_files_cubit.dart';
import 'package:base_starter/src/features/home/controllers/files_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:octopus/octopus.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
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
      // Проверяем, что достигли конца списка
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        final selectedCategory =
            context.read<FilesController>().selectedCategory;

        if (selectedCategory != null) {
          context.read<FontFilesCubit>().get(category: selectedCategory.name);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: context.theme.colorScheme.surface,
        appBar: AppBar(
          title: Text(
            L10n.current.appTitle.capitalize(),
            style: context.textStyles.s24w700,
          ),
          centerTitle: false,
          backgroundColor: context.theme.colorScheme.surface.withValues(
            alpha: 0.5,
          ),
          scrolledUnderElevation: 0,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Row(
                children: [
                  IconButton.filled(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          context.theme.colorScheme.outlineVariant.withValues(
                        alpha: 0.5,
                      ),
                    ),
                    onPressed: () => context.octopus.setState(
                      (state) => state
                        ..add(
                          Routes.settings.node(),
                        ),
                    ),
                    icon: const Icon(IconsaxPlusLinear.setting_3),
                    color: Colors.white,
                  ),
                  const Gap(8),
                  const ThemeSwitcher(),
                ],
              ),
            ),
          ],
        ),
        body: CustomScrollView(
          controller: _scrollController,
          slivers: [
            const SliverGap(32),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverToBoxAdapter(
                child: Text(
                  'Qazaqşa qarıp qory',
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
                  '''Qarıp (Font) — älıpbidegı ärıpter men tynys belgılerı ortaq grafikalyq stilde jasalğan tañbalar jiyny.''',
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
                        context.read<FontFilesCubit>().get(
                              category: controller.selectedCategory!.name,
                            );
                      }
                    }
                  },
                  builder: (context, state) => switch (state) {
                    FontCategoriesLoaded() => SizedBox(
                        height: 35,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: state.categories.length,
                          separatorBuilder: (context, index) => const Gap(8),
                          itemBuilder: (context, index) => Padding(
                            padding: EdgeInsets.only(
                              left: index == 0 ? 16 : 0,
                              right: index == 9 ? 16 : 0,
                            ),
                            child: ChoiceChip(
                              label: Text(
                                state.categories[index].name,
                                style: context.textStyles.s14w400.copyWith(
                                  color: context
                                      .theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                              selected: controller.selectedCategory ==
                                  state.categories[index],
                              side: BorderSide(
                                color: context.colors.border,
                              ),
                              onSelected: (selected) {
                                controller.selectedCategory =
                                    selected ? state.categories[index] : null;

                                if (controller.selectedCategory != null) {
                                  context.read<FontFilesCubit>().get(
                                        category:
                                            controller.selectedCategory!.name,
                                        reset: true,
                                      );
                                }
                              },
                              backgroundColor:
                                  context.theme.colorScheme.surface,
                              selectedColor: context.theme.colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                    _ => const SizedBox.shrink(),
                  },
                ),
              ),
            ),
            const SliverGap(16),
            Consumer<FilesController>(
              builder: (context, controller, child) =>
                  BlocBuilder<FontFilesCubit, FontFilesState>(
                builder: (context, state) => switch (state) {
                  FontFilesLoaded() => SliverList.builder(
                      itemCount: state.files.length,
                      itemBuilder: (context, index) {
                        final file = state.files[index];
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
                                  if (file.isFolder) {
                                    context.octopus.push(
                                      Routes.folder,
                                      arguments: {
                                        'path': file.name,
                                      },
                                    );
                                  } else {
                                    context
                                        .read<DownloadFileCubit>()
                                        .downloadFile(
                                          path: file.name,
                                          category:
                                              controller.selectedCategory!.name,
                                        );
                                  }
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
                                            color: context
                                                .theme.colorScheme.primary,
                                            borderRadius:
                                                const BorderRadius.only(
                                              bottomRight: Radius.circular(12),
                                            ),
                                          ),
                                          child: Text(
                                            file.isFolder
                                                ? 'Folder'
                                                : file.mimeType,
                                            style: context.textStyles.s12w400
                                                .copyWith(
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
                                                ? IconsaxPlusLinear
                                                    .arrow_right_3
                                                : IconsaxPlusLinear
                                                    .arrow_down_2,
                                          ),
                                        ),
                                      ),
                                      Center(
                                        child: Text(
                                          file.name,
                                          textAlign: TextAlign.center,
                                          style: context.textStyles.s16w400
                                              .copyWith(
                                            fontFamily: file.isFolder
                                                ? null
                                                : file.name,
                                            color: context.theme.colorScheme
                                                .onSurfaceVariant,
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
                    text: 'Жаңа қаріп қосу',
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
                    text:
                        '''Ūsynystar jäne sūraqtar boiynşa osy poştağa jazyñyzdar: ''',
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
                    text:
                        '''Şriftterdı ūsynğan ÄIÑĞÜŪQÖH kazahskie şrifty tobyna rahmet!\n''',
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
