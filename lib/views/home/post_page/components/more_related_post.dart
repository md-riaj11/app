import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sliver_tools/sliver_tools.dart';

import '../../../../core/components/article_tile_large.dart';
import '../../../../core/components/column_builder.dart';
import '../../../../core/components/dummy_article_tile.dart';
import '../../../../core/components/headline_with_row.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/controllers/posts/more_post_controller.dart';

class MoreRelatedPost extends ConsumerWidget {
  const MoreRelatedPost({
    Key? key,
    required this.categoryID,
    required this.currentArticleID,
  }) : super(key: key);

  final int categoryID;
  final int currentArticleID;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _morePost = ref.watch(moreRelatedPostController(categoryID));
    return SliverPadding(
      padding: const EdgeInsets.all(AppDefaults.padding),
      sliver: MultiSliver(
        children: [
          const SliverToBoxAdapter(
            child: HeadlineRow(headline: 'more_related_posts'),
          ),
          const SliverToBoxAdapter(child: AppSizedBox.h16),

          /// LIST
          _morePost.map(
            data: (data) {
              final _updatedList = data.value
                  .where((element) => element.id != currentArticleID)
                  .toList();
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                    (context, index) => ArticleTileLarge(
                          article: _updatedList[index],
                          isHeroDisabled: true,
                        ),
                    childCount: _updatedList.length),
              );
            },
            error: (t) =>
                SliverToBoxAdapter(child: Center(child: Text(t.toString()))),
            loading: (t) => SliverToBoxAdapter(
              child: ColumnBuilder(
                  itemBuilder: (context, index) => const DummyArticleTile(),
                  itemCount: 3),
            ),
          ),
        ],
      ),
    );
  }
}
