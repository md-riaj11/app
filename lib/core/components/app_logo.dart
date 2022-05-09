import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/constants.dart';
import '../themes/theme_manager.dart';

/// Dynamic App Logo Based on Theme
class AppLogo extends ConsumerWidget {
  const AppLogo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _themeMode = ref.watch(themeModeProvider);
    if (_themeMode == AdaptiveThemeMode.dark) {
      return Image.asset(AppImages.appLogoDark);
    } else {
      return Image.asset(AppImages.appLogo);
    }
  }
}
