import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/app_utils.dart';

final themeModeProvider =
    StateNotifierProvider<ThemeModeNotifier, AdaptiveThemeMode>((ref) {
  final mode = ThemeModeNotifier();
  mode.onInit();
  return mode;
});

class ThemeModeNotifier extends StateNotifier<AdaptiveThemeMode> {
  ThemeModeNotifier() : super(AdaptiveThemeMode.light);

  void onInit() {
    getThemeMode();
  }

  Future<AdaptiveThemeMode> getThemeMode() async {
    state = await AdaptiveTheme.getThemeMode() ?? AdaptiveThemeMode.light;
    return state;
  }

  void changeThemeMode(bool isDark, BuildContext context) {
    if (isDark == false) {
      AdaptiveTheme.of(context).setLight();
      state = AdaptiveThemeMode.light;
      AppUtil.setStatusBarLight();
    } else {
      AdaptiveTheme.of(context).setDark();
      state = AdaptiveThemeMode.dark;
      AppUtil.setStatusBarDark();
    }
  }
}
