import 'package:base_starter/src/app/router/routes/router.dart';
import 'package:base_starter/src/app/router/widgets/route_wrapper.dart';
import 'package:base_starter/src/common/presentation/widgets/dialogs/app_dialogs.dart';
import 'package:base_starter/src/common/utils/extensions/context_extension.dart';
import 'package:base_starter/src/features/home/bloc/download_file/download_file_cubit.dart';
import 'package:base_starter/src/features/home/bloc/font_files/font_files_cubit.dart';
import 'package:base_starter/src/features/home/controllers/files_controller.dart';
import 'package:base_starter/src/features/home/presentation/widgets/files_sliver_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:octopus/octopus.dart';
import 'package:provider/provider.dart';

class FolderScreen extends StatefulWidget implements RouteWrapper {
  const FolderScreen({
    required this.path,
  });

  final String? path;

  @override
  State<FolderScreen> createState() => _FolderScreenState();

  @override
  Widget wrappedRoute(BuildContext context) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => FontFilesBloc(
              repository: context.repositories.driveRepository,
            ),
          ),
          BlocProvider(
            create: (context) => DownloadFileCubit(
              repository: context.repositories.driveRepository,
            ),
          ),
        ],
        child: this,
      );
}

class _FolderScreenState extends State<FolderScreen> {
  @override
  void initState() {
    if (widget.path != null) {
      context.read<FontFilesBloc>().add(
            FetchFontFilesEvent(
              path: widget.path!,
              reset: true,
            ),
          );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(widget.path ?? ''),
          leading: IconButton(
            onPressed: () {
              context.octopus.pop();
            },
            icon: const Icon(
              IconsaxPlusLinear.arrow_square_left,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(
                right: 8,
              ),
              child: IconButton(
                onPressed: () {
                  context.read<DownloadFileCubit>().downloadFile(
                        path: widget.path ?? '',
                      );
                },
                icon: const Icon(
                  IconsaxPlusLinear.arrow_down_2,
                ),
              ),
            ),
          ],
        ),
        body: CustomScrollView(
          slivers: [
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
                              'path': Uri.encodeComponent(file.fullPath ?? ''),
                            },
                          );
                        } else {
                          context.read<DownloadFileCubit>().downloadFile(
                                path: file.fullPath ?? '',
                              );
                        }
                      },
                    ),
                  _ => const SliverToBoxAdapter(),
                },
              ),
            ),
          ],
        ),
      );
}
