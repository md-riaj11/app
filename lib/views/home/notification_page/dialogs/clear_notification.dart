import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/controllers/notifications/notification_local.dart';

class ClearNotificationDialog extends StatelessWidget {
  const ClearNotificationDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      backgroundColor: Theme.of(context).cardColor,
      child: Padding(
        padding: const EdgeInsets.all(AppDefaults.padding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'warning'.tr(),
              style: Theme.of(context).textTheme.headline6?.copyWith(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const Divider(),
            AppSizedBox.h10,
            Text(
              'clear_notification'.tr(),
              style: Theme.of(context).textTheme.bodyText1,
              textAlign: TextAlign.center,
            ),
            AppSizedBox.h10,
            Text(
              'clear_notification_message'.tr(),
              style: Theme.of(context).textTheme.caption,
              textAlign: TextAlign.center,
            ),
            AppSizedBox.h16,
            Consumer(builder: (context, ref, child) {
              return SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    await ref
                        .read(localNotificationProvider.notifier)
                        .clearAllNotifications();
                    Navigator.pop(context);
                  },
                  child: Text('delete'.tr()),
                  style: ElevatedButton.styleFrom(primary: Colors.red),
                ),
              );
            }),
            AppSizedBox.h16,
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('cancel'.tr()),
                style: OutlinedButton.styleFrom(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
