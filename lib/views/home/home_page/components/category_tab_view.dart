import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../../../config/ad_config.dart';
import '../../../../core/components/article_tile_large.dart';
import '../../../../core/components/banner_ad.dart';
import '../../../../core/components/dummy_article_tile.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/controllers/posts/categories_post_controller.dart';
import '../../../../core/models/article.dart';

class CategoryTabView extends ConsumerWidget {
  const CategoryTabView({
    Key? key,
    required this.arguments,
  }) : super(key: key);

  final CategoryPostsArguments arguments;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _postsProvider = ref.watch(categoryPostController(arguments));
    final _controller = ref.watch(categoryPostController(arguments).notifier);

    if (_postsProvider.refershError) {
      return Center(
        child: Text(_postsProvider.errorMessage),
      );

      /// on Initial State it will be empty
    } else if (_postsProvider.initialLoaded == false) {
      return const LoadingCategoriesPost();
    } else if (_postsProvider.posts.isEmpty) {
      return const CategoiesPostEmpty();
    } else {
      return RefreshIndicator(
        onRefresh: _controller.onRefresh,
        child: Scrollbar(
          child: CustomScrollView(
            slivers: [
              CategoryPostListView(
                data: _postsProvider.posts,
                handlePagination: _controller.handleScrollWithIndex,
                onRefresh: _controller.onRefresh,
              ),
              if (_postsProvider.isPaginationLoading)
                const SliverToBoxAdapter(
                  child: LinearProgressIndicator(),
                )
            ],
          ),
        ),
      );
    }
  }
}

class LoadingCategoriesPost extends StatelessWidget {
  const LoadingCategoriesPost({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      key: const Key('Category_List'),
      padding: const EdgeInsets.all(AppDefaults.padding),
      itemCount: 5,
      itemBuilder: (context, index) {
        return AnimationConfiguration.staggeredList(
          position: index,
          child: const SlideAnimation(
            child: DummyArticleTile(),
          ),
        );
      },
    );
  }
}

class CategoryPostListView extends StatelessWidget {
  const CategoryPostListView({
    Key? key,
    required this.data,
    required this.handlePagination,
    required this.onRefresh,
  }) : super(key: key);

  final List<ArticleModel> data;
  final void Function(int) handlePagination;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    final int every = AdConfig.adIntervalInCategory;

    final int size = data.length + data.length ~/ every;
    final List<Widget> items = List.generate(size, (i) {
      if (i != 0 && i % every == 0) {
        if (AdConfig.isAdOn) {
          return const BannerAdWidget();
        } else {
          return const SizedBox();
        }
      }
      return ArticleTileLarge(article: data[i - i ~/ every]);
    });

    return AnimationLimiter(
      child: SliverPadding(
        padding: const EdgeInsets.only(
          top: AppDefaults.padding,
          left: AppDefaults.padding,
          right: AppDefaults.padding,
        ),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            handlePagination(index);
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: AppDefaults.duration,
              child: FadeInAnimation(
                child: items[index],
              ),
            );
          }, childCount: items.length),
        ),
      ),
    );
  }
}

class CategoiesPostEmpty extends StatelessWidget {
  const CategoiesPostEmpty({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDefaults.padding * 2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppDefaults.padding),
            child: Image.asset(AppImages.emptyPost),
          ),
          AppSizedBox.h16,
          Text(
            'Ooh! It\'s empty here',
            style: Theme.of(context).textTheme.headline6?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          AppSizedBox.h10,
          Text(
            'You can explore other categories as well',
            style: Theme.of(context).textTheme.caption,
          ),
        ],
      ),
    );
  }
}
