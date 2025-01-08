import 'package:base_starter/src/app/router/routes/router.dart';
import 'package:base_starter/src/app/router/widgets/route_wrapper.dart';
import 'package:base_starter/src/common/presentation/widgets/buttons/theme_switcher.dart';
import 'package:base_starter/src/common/utils/extensions/context_extension.dart';
import 'package:base_starter/src/common/utils/extensions/string_extension.dart';
import 'package:base_starter/src/core/l10n/localization.dart';
import 'package:base_starter/src/features/home/presentation/bloc/counter_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:octopus/octopus.dart';

class HomeScreen extends StatelessWidget implements RouteWrapper {
  const HomeScreen({super.key});

  @override
  Widget wrappedRoute(BuildContext context) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => CounterCubit(),
          ),
        ],
        child: this,
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: context.theme.colorScheme.surface,
        appBar: AppBar(
          title: Text(
            L10n.current.appTitle.capitalize(),
            style: context.textStyles.s24w700,
          ),
          centerTitle: false,
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
          slivers: [
            SliverFillRemaining(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  L10n.current.counterTimesText(
                    context.watch<CounterCubit>().state,
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
