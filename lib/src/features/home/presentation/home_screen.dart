import 'package:base_starter/src/app/router/routes/router.dart';
import 'package:base_starter/src/app/router/widgets/route_wrapper.dart';
import 'package:base_starter/src/common/constants/app_constants.dart';
import 'package:base_starter/src/common/presentation/widgets/buttons/app_button.dart';
import 'package:base_starter/src/common/presentation/widgets/dialogs/app_dialogs.dart';
import 'package:base_starter/src/common/utils/extensions/context_extension.dart';
import 'package:base_starter/src/core/l10n/localization.dart';
import 'package:base_starter/src/features/home/bloc/download_file/download_file_cubit.dart';
import 'package:base_starter/src/features/home/bloc/drive_files/drive_files_bloc.dart';
import 'package:base_starter/src/features/home/bloc/font_categories/font_categories.dart';
import 'package:base_starter/src/features/home/bloc/font_files/font_files_cubit.dart';
import 'package:base_starter/src/features/home/controllers/files_controller.dart';
import 'package:base_starter/src/features/home/presentation/widgets/app_bar.dart';
import 'package:base_starter/src/features/home/presentation/widgets/categories_list.dart';
import 'package:base_starter/src/features/home/presentation/widgets/files_sliver_list.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:octopus/octopus.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class HomeScreen extends StatefulWidget implements RouteWrapper {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();

  @override
  Widget wrappedRoute(BuildContext context) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => FontCategoriesCubit(
              repository: context.repositories.driveRepository,
            ),
          ),
          BlocProvider(
            create: (_) => FontFilesBloc(
              repository: context.repositories.driveRepository,
            ),
          ),
          BlocProvider(
            create: (context) => DriveFilesBloc(
              driveRepository: context.repositories.driveRepository,
            ),
          ),
          BlocProvider(
            create: (_) => DownloadFileCubit(
              repository: context.repositories.driveRepository,
            ),
          ),
        ],
        child: this,
      );
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<FontCategoriesCubit>().get();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: context.theme.colorScheme.surface,
        body: CustomScrollView(
          slivers: [
            //
            // <--- App Bar --->
            //
            SliverPersistentHeader(
              pinned: true,
              delegate: QaripAppBanner(),
            ),
            const SliverGap(32),
            //
            // <--- Kazakh Font Fund --->
            //
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
            //
            // <--- Qarip Site Description --->
            //
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
            //
            // <--- Categories List --->
            //
            SliverToBoxAdapter(
              child: Consumer<FilesController>(
                builder: (context, controller, child) =>
                    BlocConsumer<FontCategoriesCubit, FontCategoriesState>(
                  listener: (context, state) {
                    if (state is FontCategoriesLoaded) {
                      controller.selectedCategory =
                          state.categories.firstOrNull;

                      if (controller.selectedCategory?.fullPath != null) {
                        context.read<FontFilesBloc>().add(
                              FetchFontFilesEvent(
                                path: controller.selectedCategory!.fullPath!,
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
                            controller.clearFiles();
                            context.read<FontFilesBloc>().add(
                                  FetchFontFilesEvent(
                                    path: selectedFile.name ?? '',
                                    reset: true,
                                  ),
                                );
                          }
                        },
                      ),
                    FontCategoriesLoading() => FontCategoriesList.loader,
                    _ => const SizedBox.shrink(),
                  },
                ),
              ),
            ),
            const SliverGap(16),
            //
            // <--- Files List --->
            //
            Consumer<FilesController>(
              builder: (context, controller, child) =>
                  BlocConsumer<FontFilesBloc, FontFilesState>(
                listener: (context, state) {
                  switch (state) {
                    case FontFilesLoading():
                      AppDialogs.showLoader(context);
                    case FontFilesLoaded():
                      AppDialogs.dismiss();
                      controller.addAllFiles(state.files);
                    default:
                      AppDialogs.dismiss();
                  }
                },
                builder: (context, state) => FilesSliverList(
                  files: controller.files,
                  onTap: ({required file, required path}) {
                    if (file.isFolder) {
                      context.octopus.push(
                        Routes.folder,
                        arguments: {
                          'path': Uri.encodeComponent(file.fullPath ?? ''),
                        },
                      );
                    } else {
                      if (file.fullPath != null) {
                        context.read<DownloadFileCubit>().downloadFile(
                              path: file.fullPath!,
                            );
                      }
                    }
                  },
                ),
              ),
            ),
            //
            //
            //
            const SliverGap(16),
            Consumer<FilesController>(
              builder: (context, controller, child) =>
                  BlocBuilder<FontFilesBloc, FontFilesState>(
                builder: (context, state) => switch (state) {
                  FontFilesLoaded() => state.hasMore
                      ? SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: SizedBox(
                              height: 50,
                              child: AppButton(
                                onPressed: () {
                                  context.read<FontFilesBloc>().add(
                                        FetchFontFilesEvent(
                                          path: controller
                                              .selectedCategory!.fullPath!,
                                          pageToken: state.nextPageToken,
                                        ),
                                      );
                                },
                                text: L10n.current.showMore,
                                textColor: Colors.white,
                              ),
                            ),
                          ),
                        )
                      : const SliverToBoxAdapter(),
                  _ => const SliverToBoxAdapter(),
                },
              ),
            ),
            const SliverGap(16),
            //
            // <--- Email For Suggestions And Questions --->
            //
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverToBoxAdapter(
                child: Text.rich(
                  TextSpan(
                    text: '${L10n.current.emailForSuggestionsAndQuestions}: ',
                    style: context.textStyles.s20w500,
                    children: [
                      TextSpan(
                        text: AppConstants.emailUrl,
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            launchUrlString(
                              'mailto:${AppConstants.emailUrl}',
                            );
                          },
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
            //
            // <--- Thanks To Group --->
            //
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverToBoxAdapter(
                child: Text.rich(
                  TextSpan(
                    text: '${L10n.current.thanksToGroup} ',
                    style: context.textStyles.s14w400,
                    children: [
                      TextSpan(
                        text: '${AppConstants.kazfontGroup} 💙',
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            launchUrlString(AppConstants.kazfontGroup);
                          },
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
