import 'dart:ui';

import 'package:base_starter/src/app/router/routes/router.dart';
import 'package:base_starter/src/common/presentation/widgets/buttons/theme_switcher.dart';
import 'package:base_starter/src/common/utils/extensions/context_extension.dart';
import 'package:base_starter/src/common/utils/extensions/string_extension.dart';
import 'package:base_starter/src/core/l10n/localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:octopus/octopus.dart';

class QaripAppBanner extends SliverPersistentHeaderDelegate {
  QaripAppBanner();

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final progress = shrinkOffset / maxExtent;

    final fontSizeClamped = ((1 - progress) * 28).clamp(18, 28);

    final isCollapsed = (maxExtent - shrinkOffset) < minExtent;

    return Stack(
      fit: StackFit.expand,
      children: [
        //
        // <--- Background Blur (only AppBar area) --->
        //
        if (isCollapsed)
          ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                color: context.theme.colorScheme.surface.withValues(
                  alpha: 0.5,
                ),
              ),
            ),
          )
        else
          Container(
            color: context.theme.colorScheme.surface,
          ),

        //
        // <--- Title --->
        //
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              L10n.current.appTitle.capitalize(),
              style: context.textStyles.s20w600.copyWith(
                fontSize: fontSizeClamped.toDouble(),
              ),
            ),
          ),
        ),

        //
        // <--- Buttons --->
        //
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
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
        ),
      ],
    );
  }

  @override
  double get maxExtent => kToolbarHeight;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}
