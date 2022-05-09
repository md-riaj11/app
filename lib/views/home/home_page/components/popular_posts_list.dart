import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_pro/core/components/article_tile_large.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/controllers/posts/popular_posts_controller.dart';
import '../../../../core/models/article.dart';
import 'loading_recent_post.dart';

class PopularPostFetcherSection extends ConsumerWidget {
  const PopularPostFetcherSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _popularPosts = ref.watch(popularPostsController);
    return _popularPosts.map(
      data: (data) {
        return PopularPostsList(articles: data.value);
      },
      error: (t) => Center(
        child: Text(t.toString()),
      ),
      loading: (t) => const SliverToBoxAdapter(child: LoadingRecentPosts()),
    );
  }
}

class PopularPostsList extends StatelessWidget {
  const PopularPostsList({
    Key? key,
    required this.articles,
  }) : super(key: key);

  final List<ArticleModel> articles;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDefaults.padding,
        vertical: AppDefaults.padding / 2,
      ),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return ArticleTileLarge(
              article: articles[index],
            );
          },
          childCount: articles.length,
        ),
        // padding: const EdgeInsets.symmetric(
      ),
    );
  }
}
