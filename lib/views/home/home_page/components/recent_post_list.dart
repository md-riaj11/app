import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sliver_tools/sliver_tools.dart';

import '../../../../core/components/article_tile_large.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/controllers/posts/post_pagination_class.dart';
import '../../../../core/controllers/posts/recent_posts_controller.dart';
import 'loading_recent_post.dart';

class RecentPostFetcherSection extends ConsumerWidget {
  const RecentPostFetcherSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _recentPosts = ref.watch(recentPostController);
    final _notifer = ref.watch(recentPostController.notifier);

    if (_recentPosts.initialLoaded == false) {
      return const SliverToBoxAdapter(child: LoadingRecentPosts());
    } else if (_recentPosts.refershError) {
      return Center(child: Text(_recentPosts.errorMessage));
    } else if (_recentPosts.posts.isEmpty) {
      return const SliverToBoxAdapter(
        child: Center(child: Text('No Posts Found')),
      );
    } else {
      return MultiSliver(
        children: [
          RecentPostList(
            recentPosts: _recentPosts,
            notifer: _notifer,
          ),
          if (_recentPosts.isPaginationLoading)
            const SliverToBoxAdapter(child: LinearProgressIndicator()),
        ],
      );
    }
  }
}

class RecentPostList extends StatelessWidget {
  const RecentPostList({
    Key? key,
    required PostPagination recentPosts,
    required RecentPostsController notifer,
  })  : _recentPosts = recentPosts,
        _notifer = notifer,
        super(key: key);

  final PostPagination _recentPosts;
  final RecentPostsController _notifer;

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
            _notifer.handleScrollWithIndex(index);
            if (index % 5 == 0) {
              return ArticleTileLarge(
                article: _recentPosts.posts[index],
              );
            } else {
              return ArticleTileLarge(
                article: _recentPosts.posts[index],
              );
            }
          },
          childCount: _recentPosts.posts.length,
        ),
      ),
    );
  }
}
