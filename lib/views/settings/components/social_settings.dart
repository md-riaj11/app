import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../config/wp_config.dart';
import '../../../core/constants/constants.dart';
import '../../../core/utils/app_utils.dart';
import 'setting_list_tile.dart';

class SocialSettings extends StatelessWidget {
  const SocialSettings({
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
            'social'.tr(),
            style: Theme.of(context).textTheme.caption,
          ),
        ),
        SettingTile(
          label: 'Contact Us',
          shouldTranslate: false,
          icon: Icons.contact_mail_rounded,
          iconColor: Colors.blueGrey,
          trailing: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(IconlyLight.arrowRight2),
          ),
          onTap: () {
            const _url = WPConfig.supportEmail;
            if (_url.isNotEmpty) {
              AppUtil.launchUrl('mailto:$_url');
            } else {
              Fluttertoast.showToast(msg: 'No App Url link provided');
            }
          },
        ),
        SettingTile(
          label: 'Website',
          shouldTranslate: false,
          icon: FontAwesomeIcons.globeAsia,
          isFaIcon: true,
          iconColor: Colors.green,
          trailing: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(IconlyLight.arrowRight2),
          ),
          onTap: () {
            const _url = WPConfig.url;
            if (_url.isNotEmpty) {
              AppUtil.openLink('https://$_url');
            } else {
              Fluttertoast.showToast(msg: 'No App Url link provided');
            }
          },
        ),
        SettingTile(
          label: 'Facebook',
          icon: FontAwesomeIcons.facebook,
          shouldTranslate: false,
          isFaIcon: true,
          iconColor: Colors.blue,
          trailing: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(IconlyLight.arrowRight2),
          ),
          onTap: () {
            const _url = WPConfig.facebookUrl;
            if (_url.isNotEmpty) {
              AppUtil.openLink(_url);
            } else {
              Fluttertoast.showToast(msg: 'No Facebook link provided');
            }
          },
        ),
        SettingTile(
          label: 'Youtube',
          shouldTranslate: false,
          icon: FontAwesomeIcons.youtube,
          isFaIcon: true,
          iconColor: Colors.red,
          trailing: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(IconlyLight.arrowRight2),
          ),
          onTap: () {
            const _url = WPConfig.youtubeUrl;
            if (_url.isNotEmpty) {
              AppUtil.openLink(_url);
            } else {
              Fluttertoast.showToast(msg: 'No Youtube link provided');
            }
          },
        ),
        SettingTile(
          label: 'Twitter',
          shouldTranslate: false,
          icon: FontAwesomeIcons.twitter,
          isFaIcon: true,
          iconColor: Colors.lightBlue,
          trailing: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(IconlyLight.arrowRight2),
          ),
          onTap: () {
            const _url = WPConfig.twitterUrl;
            if (_url.isNotEmpty) {
              AppUtil.openLink(_url);
            } else {
              Fluttertoast.showToast(msg: 'No Twitter link provided');
            }
          },
        ),
      ],
    );
  }
}
