import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../../../core/components/app_shimmer.dart';
import '../../../../core/components/dummy_article_tile.dart';
import '../../../../core/components/dummy_article_tile_large.dart';
import '../../../../core/components/headline_with_row.dart';
import '../../../../core/constants/constants.dart';
import 'post_slider.dart';

class LoadingFeaturePost extends StatelessWidget {
  const LoadingFeaturePost({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).cardColor,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSizedBox.h16,
            const DummyPostSlider(),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppDefaults.padding),
              child: AppShimmer(
                child: HeadlineRow(
                  headline: 'popular_posts',
                  isHeader: false,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppDefaults.padding,
                  vertical: AppDefaults.padding / 2),
              child: Column(
                children: AnimationConfiguration.toStaggeredList(
                  childAnimationBuilder: (child) =>
                      SlideAnimation(child: child),
                  children: List.generate(
                    2,
                    (index) => const DummyArticleTile(
                      isEnabled: false,
                    ),
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppDefaults.padding,
              ),
              child: DummyArticleTileLarge(
                isEnabled: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
