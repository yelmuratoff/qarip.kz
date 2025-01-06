import 'package:base_starter/src/app/router/enums/root_tabs_enum.dart';
import 'package:base_starter/src/common/utils/extensions/context_extension.dart';
import 'package:base_starter/src/common/utils/extensions/string_extension.dart';
import 'package:base_starter/src/core/l10n/localization.dart';
import 'package:base_starter/src/features/home/presentation/state/counter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:ispect/ispect.dart';
import 'package:octopus/octopus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) => BucketNavigator(
        bucket: RootTabsEnum.home.bucket,
        transitionDelegate: const DefaultTransitionDelegate<void>(),
        observers: [
          ISpectNavigatorObserver(),
        ],
      );
}

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
        backgroundColor: context.theme.colorScheme.surface,
        appBar: AppBar(
          title: GestureDetector(
            onTap: () async {
              final user =
                  await Supabase.instance.client.auth.signInAnonymously();
              print(user);
              final folders =
                  await Supabase.instance.client.storage.from('fonts').list();
              print(folders.map((e) => e.name));
              final subFolder = await Supabase.instance.client.storage
                  .from('fonts')
                  .list(path: 'Accident');

              print(subFolder.map((e) => e.name));

              final file = await Supabase.instance.client.storage
                  .from('fonts')
                  .getPublicUrl('Accident/Afolkalips.woff2');
              print(file);
              // Toaster.showToast(
              //   context: context,
              //   title: L10n.current.appTitle,
              // );
              // context.octopus.setState(
              //   (state) => state
              //     ..add(
              //       Routes.splash.node(),
              //     ),
              // );
            },
            child: Text(
              L10n.current.appTitle.capitalize(),
              style: context.textStyles.s24w700,
            ),
          ),
          centerTitle: false,
        ),
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton(
              heroTag: 'increment',
              onPressed: () => ref.read(counterProvider.notifier).increment(),
              child: const Icon(IconsaxPlusLinear.add),
            ),
            const Gap(8),
            FloatingActionButton(
              heroTag: 'decrement',
              onPressed: () => ref.read(counterProvider.notifier).decrement(),
              child: const Icon(IconsaxPlusLinear.minus),
            ),
          ],
        ),
        body: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  L10n.current.counterTimesText(
                    ref.watch(counterProvider),
                  ),
                  textAlign: TextAlign.center,
                  style: context.textStyles.s18w600,
                ),
              ),
            ),
          ],
        ),
      );
}
