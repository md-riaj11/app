import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

import '../../../core/components/bottom_sheet_top_handler.dart';
import '../../../core/constants/constants.dart';
import '../../../core/localization/app_locales.dart';

class ChangeLanguageDialog extends StatelessWidget {
  const ChangeLanguageDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDefaults.padding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const BottomSheetTopHandler(),
          const _ChangeLanguageHeader(),
          const Divider(),

          /// All Languages
          ListView.separated(
            itemCount: AppLocales.supportedLocales.length,
            itemBuilder: (context, index) {
              Locale _current = AppLocales.supportedLocales[index];
              return ListTile(
                onTap: () async {
                  await context.setLocale(_current);
                  Navigator.pop(context);
                },
                title: Text(AppLocales.formattedLanguageName(_current)),
                leading: const Icon(Icons.language),
                trailing: context.locale == _current
                    ? const Icon(Icons.check_circle, color: Colors.green)
                    : const SizedBox(),
              );
            },
            separatorBuilder: (context, index) => const Divider(),
            shrinkWrap: true,
          ),
          AppSizedBox.h16,
        ],
      ),
    );
  }
}

class _ChangeLanguageHeader extends StatelessWidget {
  const _ChangeLanguageHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'change_lanuage'.tr(),
          style: Theme.of(context).textTheme.headline6,
        ),
        const Spacer(),
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            IconlyLight.closeSquare,
          ),
        ),
      ],
    );
  }
}
