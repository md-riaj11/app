import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/constants.dart';
import '../../config/wp_config.dart';
import '../controllers/category/categories_controller.dart';
import '../models/article.dart';
import '../routes/app_routes.dart';
import '../utils/app_utils.dart';
import 'network_image.dart';

class ArticleTile extends StatelessWidget {
  const ArticleTile({
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
            child: Row(
              children: [
                // thumbnail
                Expanded(
                  flex: 3,
                  child: isHeroDisabled
                      ? VideoArticleWrapper(
                          isVideoArticle:
                              article.tags.contains(WPConfig.videoTagID),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(AppDefaults.radius),
                              bottomLeft: Radius.circular(AppDefaults.radius),
                            ),
                            child: AspectRatio(
                              aspectRatio: 2 / 2,
                              child:
                                  NetworkImageWithLoader(article.featuredImage),
                            ),
                          ),
                        )
                      : VideoArticleWrapper(
                          isVideoArticle:
                              article.tags.contains(WPConfig.videoTagID),
                          child: Hero(
                            tag: article.heroTag,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(AppDefaults.radius),
                                bottomLeft: Radius.circular(AppDefaults.radius),
                              ),
                              child: AspectRatio(
                                aspectRatio: 2 / 2,
                                child: NetworkImageWithLoader(
                                    article.featuredImage),
                              ),
                            ),
                          ),
                        ),
                ),
                // Description
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FittedBox(
                          child: Html(
                            data: article.title,
                            style: {
                              'body': Style(
                                margin: EdgeInsets.zero,
                                padding: EdgeInsets.zero,
                                fontSize: const FontSize(25.0),
                                lineHeight: const LineHeight(1.4),
                                fontWeight: FontWeight.bold,
                                maxLines: 2,
                              ),
                              'figure': Style(
                                  margin: EdgeInsets.zero,
                                  padding: EdgeInsets.zero),
                            },
                          ),
                        ),

                        /* <---- Category List -----> */
                        _CategoryWrap(article: article),
                        Row(
                          children: [
                            const Icon(
                              IconlyLight.timeCircle,
                              color: AppColors.placeholder,
                              size: 18,
                            ),
                            AppSizedBox.w5,
                            Text(
                              AppUtil.totalMinute(article.content, context) +
                                  ' ' +
                                  'minute_read'.tr(),
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ],
                        ),
                        AppSizedBox.h5,
                        Row(
                          children: [
                            const Icon(
                              IconlyLight.calendar,
                              color: AppColors.placeholder,
                              size: 18,
                            ),
                            AppSizedBox.w5,
                            Text(
                              DateFormat.yMMMMd(context.locale.toLanguageTag())
                                  .format(article.date),
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                )
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
                  horizontal: 4.0,
                ),
                child: Chip(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  label: AutoSizeText(
                    _allCategories[index],
                    style: Theme.of(context).textTheme.caption,
                  ),
                  side: const BorderSide(
                    width: 0.2,
                    color: AppColors.cardColor,
                  ),
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
