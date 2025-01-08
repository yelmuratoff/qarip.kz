import 'package:base_starter/src/common/utils/extensions/context_extension.dart';
import 'package:base_starter/src/features/settings/presentation/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class ThemeSwitcher extends StatelessWidget {
  const ThemeSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final themeScope = SettingsScope.themeOf(context);
    return IconButton.filled(
      style: ElevatedButton.styleFrom(
        backgroundColor: context.theme.colorScheme.outlineVariant.withValues(
          alpha: 0.5,
        ),
      ),
      onPressed: () {
        themeScope.setThemeMode(
          themeScope.isDarkMode ? ThemeMode.light : ThemeMode.dark,
        );
      },
      color: Colors.white,
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) => ScaleTransition(
          scale: animation,
          child: RotationTransition(
            turns: animation,
            child: child,
          ),
        ),
        child: themeScope.isDarkMode
            ? const Icon(
                key: ValueKey('dark'),
                IconsaxPlusLinear.sun_1,
              )
            : const Icon(
                key: ValueKey('light'),
                IconsaxPlusLinear.moon,
              ),
      ),
    );
  }
}
