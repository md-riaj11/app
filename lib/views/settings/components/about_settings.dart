import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../config/wp_config.dart';
import '../../../core/constants/constants.dart';
import '../../../core/utils/app_utils.dart';
import '../../../core/utils/ui_util.dart';
import '../dialogs/license_dialog.dart';
import 'setting_list_tile.dart';

class AboutSettings extends StatelessWidget {
  const AboutSettings({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(AppDefaults.margin),
          child: Text(
            'about'.tr(),
            style: Theme.of(context).textTheme.caption,
          ),
        ),
        SettingTile(
          label: 'terms_conditions',
          icon: IconlyLight.paper,
          iconColor: Colors.pink,
          trailing: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(IconlyLight.arrowRight2),
          ),
          onTap: () {
            const _theURL = WPConfig.termsAndServicesUrl;
            if (_theURL.isNotEmpty) {
              AppUtil.openLink(_theURL);
            } else {
              Fluttertoast.showToast(
                  msg: 'No Terms And Conditions URL provided');
            }
          },
        ),
        SettingTile(
          label: 'about',
          icon: IconlyLight.paper,
          iconColor: Colors.blueGrey,
          trailing: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(IconlyLight.arrowRight2),
          ),
          onTap: () {
            const _theURL = WPConfig.url;
            if (_theURL.isNotEmpty) {
              const _url = 'https://$_theURL';
              AppUtil.openLink(_url);
            } else {
              Fluttertoast.showToast(
                  msg: 'No Terms And Conditions URL provided');
            }
          },
        ),
        SettingTile(
          label: 'privacy_policy',
          icon: IconlyLight.lock,
          iconColor: Colors.green,
          trailing: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(IconlyLight.arrowRight2),
          ),
          onTap: () {
            const _privacyPolicy = WPConfig.privacyPolicyUrl;
            if (_privacyPolicy.isNotEmpty) {
              AppUtil.openLink(_privacyPolicy);
            } else {
              Fluttertoast.showToast(msg: 'No privacy policy provided');
            }
          },
        ),
        SettingTile(
          label: 'rate_this_app',
          icon: IconlyLight.star,
          iconColor: Colors.blueAccent,
          trailing: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(IconlyLight.arrowRight2),
          ),
          onTap: () {
            const _appStoreUrl = WPConfig.appStoreRatingUrl;
            const _playstoreUrl = WPConfig.playstoreRatingUrl;
            if (Platform.isAndroid) {
              if (_playstoreUrl.isNotEmpty) {
                AppUtil.openLink(_playstoreUrl);
              } else {
                Fluttertoast.showToast(msg: 'No Rating Url Provided');
              }
            } else if (Platform.isIOS) {
              if (_appStoreUrl.isNotEmpty) {
                AppUtil.openLink(_appStoreUrl);
              } else {
                Fluttertoast.showToast(msg: 'No Rating Url Provided');
              }
            } else {
              debugPrint('Unsupported Platform');
            }
          },
        ),
        SettingTile(
          label: 'license',
          icon: IconlyLight.wallet,
          iconColor: Colors.purple,
          trailing: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(IconlyLight.arrowRight2),
          ),
          onTap: () {
            UiUtil.openDialog(context: context, widget: const LicenseDialog());
          },
        ),
      ],
    );
  }
}
