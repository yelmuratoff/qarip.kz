import 'package:base_starter/src/app/router/routes/router.dart';
import 'package:base_starter/src/app/router/widgets/route_wrapper.dart';
import 'package:base_starter/src/common/presentation/widgets/buttons/app_button.dart';
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
              child: SizedBox(
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
                    child: ChoiceChip(
                      label: Text(
                        'Категория $index',
                        style: context.textStyles.s14w400.copyWith(
                          color: context.theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      selected: false,
                      side: BorderSide(
                        color: context.colors.border,
                      ),
                      onSelected: (selected) {},
                      backgroundColor: context.theme.colorScheme.surface,
                      selectedColor: context.theme.colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ),
            const SliverGap(16),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Wrap(
                alignment: WrapAlignment.center,
                children: List.generate(
                  3,
                  (index) {
                    final isFolder = index.isEven;
                    return Padding(
                      padding: const EdgeInsets.all(8),
                      child: InkWell(
                        onTap: () {},
                        borderRadius: const BorderRadius.all(
                          Radius.circular(16),
                        ),
                        child: SizedBox.square(
                          dimension: 150,
                          child: Ink(
                            decoration: BoxDecoration(
                              color: context.theme.colorScheme.surface,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(16),
                              ),
                              border: Border.all(
                                color: context.colors.border,
                              ),
                            ),
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
                                        topLeft: Radius.circular(14),
                                        bottomRight: Radius.circular(14),
                                      ),
                                    ),
                                    child: Text(
                                      isFolder ? 'Folder' : 'ttf',
                                      style:
                                          context.textStyles.s12w400.copyWith(
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
                                      isFolder
                                          ? IconsaxPlusLinear.arrow_right_3
                                          : IconsaxPlusLinear.arrow_down_2,
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    'Name $index',
                                    style: context.textStyles.s16w400.copyWith(
                                      color: context
                                          .theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
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
