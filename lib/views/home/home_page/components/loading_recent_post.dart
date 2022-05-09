import 'package:flutter/material.dart';
import '../../../../core/components/dummy_article_tile_large.dart';

import '../../../../core/components/column_builder.dart';
import '../../../../core/components/dummy_article_tile.dart';
import '../../../../core/constants/constants.dart';

class LoadingRecentPosts extends StatelessWidget {
  const LoadingRecentPosts({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppDefaults.padding / 2,
        horizontal: AppDefaults.padding,
      ),
      child: ColumnBuilder(
        itemBuilder: ((context, index) {
          if (index == 2) {
            return const DummyArticleTileLarge();
          } else {
            return const DummyArticleTile();
          }
        }),
        itemCount: 3,
      ),
    );
  }
}
