import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../../core/constants/constants.dart';
import '../../../core/controllers/notifications/notification_remote.dart';
import '../../../core/themes/theme_manager.dart';
import '../../../core/utils/ui_util.dart';
import '../dialogs/change_language.dart';
import 'about_settings.dart';
import 'buy_this_app.dart';
import 'setting_list_tile.dart';
import 'social_settings.dart';
import 'user_settings.dart';

class AllSettings extends StatelessWidget {
  const AllSettings({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: Theme.of(context).cardColor,
      child: AnimationLimiter(
        child: Column(
          children: AnimationConfiguration.toStaggeredList(
            childAnimationBuilder: (child) => SlideAnimation(
              child: child,
              duration: AppDefaults.duration,
              verticalOffset: 50.00,
            ),
            children: [
              const UserSettings(),
              const GeneralSettings(),
              const AboutSettings(),
              const SocialSettings(),
              const BuyAppSettings(),
            ],
          ),
        ),
      ),
    );
  }
}

class GeneralSettings extends ConsumerWidget {
  const GeneralSettings({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// Notifications
    bool _isNotificationOn = ref.watch(isNotificationOnProvider);
    final _notificationControlelr =
        ref.read(remoteNotificationProvider(context).notifier);

    /// Dark Mode
    bool _isDark = ref.watch(themeModeProvider).isDark;
    final _darkModeController = ref.read(themeModeProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(AppDefaults.margin),
          child: Text(
            'general_settings'.tr(),
            style: Theme.of(context).textTheme.caption,
          ),
        ),
        SettingTile(
          label: 'notification',
          icon: IconlyLight.notification,
          iconColor: Colors.green,
          trailing: CupertinoSwitch(
            value: _isNotificationOn,
            onChanged: (v) {
              _notificationControlelr.toggleNotification(_isNotificationOn);
            },
            activeColor: AppColors.primary,
          ),
        ),
        SettingTile(
          label: 'dark_mode',
          icon: Icons.dark_mode_rounded,
          iconColor: Colors.black87,
          trailing: CupertinoSwitch(
            value: _isDark,
            onChanged: (v) {
              _darkModeController.changeThemeMode(v, context);
            },
            activeColor: AppColors.primary,
          ),
        ),
        SettingTile(
          label: 'language',
          icon: Icons.language_rounded,
          iconColor: Colors.purple,
          trailing: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(IconlyLight.arrowRight2),
          ),
          onTap: () {
            UiUtil.openBottomSheet(
              context: context,
              widget: const ChangeLanguageDialog(),
            );
          },
        ),
      ],
    );
  }
}
