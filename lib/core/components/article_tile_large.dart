import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/constants.dart';
import '../../views/home/post_page/components/save_post_button.dart';
import '../controllers/category/categories_controller.dart';
import '../models/article.dart';
import '../routes/app_routes.dart';

class ArticleTileLarge extends StatelessWidget {
  const ArticleTileLarge({
    Key? key,
    required this.article,
    this.backgroundColor,
    this.isHeroDisabled = false,
  }) : super(key: key);

  final ArticleModel article;

  /// This is for so that we will have a unique hero Tag to animate
  /// otherwise we will face Hero animation issues
  final Color? backgroundColor;
  final bool isHeroDisabled;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDefaults.margin / 2),
      child: Material(
        color: backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
        borderRadius: AppDefaults.borderRadius,
        child: InkWell(
          onTap: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.post,
              (v) => v.isFirst,
              arguments: article,
            );
          },
          borderRadius: AppDefaults.borderRadius,
          child: Container(
            decoration: BoxDecoration(
              boxShadow: AppDefaults.boxShadow,
            ),
            child: Stack(
              children: [
                Column(
                  children: [
                    AppSizedBox.h16,
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDefaults.padding,
                      ),
                      child: FittedBox(
                        child: Html(
                          data: article.title,
                          style: {
                            'body': Style(
                              margin: EdgeInsets.zero,
                              padding: EdgeInsets.zero,
                              fontSize: const FontSize(18.0),
                              lineHeight: const LineHeight(1.4),
                              fontWeight: FontWeight.bold,
                            ),
                            'figure': Style(
                                margin: EdgeInsets.zero,
                                padding: EdgeInsets.zero),
                          },
                        ),
                      ),
                    ),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.all(AppDefaults.padding),
                      child: Row(
                        children: [
                          Row(
                            children: [
                              // const Icon(
                              //   IconlyLight.timeCircle,
                              //   color: AppColors.placeholder,
                              //   size: 18,
                              // ),
                              // AppSizedBox.w5,
                              // Text(
                              //   AppUtil.totalMinute(article.content, context) +
                              //       ' ' +
                              //       'minute_read'.tr(),
                              //   style: Theme.of(context).textTheme.caption,
                              // ),
                              _CategoryWrap(article: article),
                            ],
                          ),
                          AppSizedBox.w16,
                          Row(
                            children: [
                              const Icon(
                                IconlyLight.calendar,
                                color: AppColors.placeholder,
                                size: 18,
                              ),
                              AppSizedBox.w5,
                              Text(
                                DateFormat.yMMMMd(
                                        context.locale.toLanguageTag())
                                    .format(article.date),
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 10,
                  right: 0,
                  child: SavePostButton(article: article),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryWrap extends StatelessWidget {
  const _CategoryWrap({
    Key? key,
    required this.article,
  }) : super(key: key);

  final ArticleModel article;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Consumer(
        builder: (context, ref, child) {
          final _allCategories = ref
              .read(categoriesController.notifier)
              .categoriesName(article.categories);
          return Row(
            children: List.generate(
              _allCategories.length,
              (index) => Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 2.0,
                ),
                child: Row(
                  children: [
                    const Icon(IconlyLight.category, size: 14),
                    AppSizedBox.w5,
                    AutoSizeText(
                      _allCategories[index],
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class VideoArticleWrapper extends StatelessWidget {
  const VideoArticleWrapper({
    Key? key,
    required this.isVideoArticle,
    required this.child,
  }) : super(key: key);

  final bool isVideoArticle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isVideoArticle)
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: AppDefaults.borderRadius,
                ),
                child: const Icon(
                  Icons.play_circle,
                  color: Colors.white,
                  size: 56,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
