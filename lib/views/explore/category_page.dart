import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sliver_tools/sliver_tools.dart';

import '../../core/ads/ad_state_provider.dart';
import '../../core/components/article_tile_large.dart';
import '../../core/components/dummy_article_tile.dart';
import '../../core/constants/constants.dart';
import '../../core/controllers/posts/categories_post_controller.dart';
import '../../core/controllers/posts/post_pagination_class.dart';
import '../../core/models/category.dart';
import 'components/empty_categories.dart';

class CategoryPageArguments {
  final CategoryModel category;
  final String backgroundImage;
  CategoryPageArguments({
    required this.category,
    required this.backgroundImage,
  });
}

class CategoryPage extends StatelessWidget {
  const CategoryPage({
    Key? key,
    required this.arguments,
  }) : super(key: key);

  final CategoryPageArguments arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scrollbar(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              leadingWidth: MediaQuery.of(context).size.width * 0.2,
              expandedHeight: MediaQuery.of(context).size.height * 0.20,
              backgroundColor: AppColors.primary,
              iconTheme: const IconThemeData(color: Colors.white),
              flexibleSpace: FlexibleSpaceBar(
                title: Html(
                  data: arguments.category.name,
                  style: {
                    'body': Style(
                      margin: EdgeInsets.zero,
                      padding: EdgeInsets.zero,
                      fontSize: const FontSize(16.0),
                      lineHeight: const LineHeight(1.4),
                      color: Colors.white,
                      textAlign: TextAlign.center,
                      fontWeight: FontWeight.bold,
                    ),
                    'figure': Style(
                        margin: EdgeInsets.zero, padding: EdgeInsets.zero),
                  },
                ),
                expandedTitleScale: 2,
                centerTitle: true,
                background: AspectRatio(
                  aspectRatio: AppDefaults.aspectRatio,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(
                          arguments.backgroundImage,
                        ),
                        fit: BoxFit.cover,
                        colorFilter: const ColorFilter.mode(
                          Colors.black54,
                          BlendMode.darken,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(AppDefaults.padding),
              sliver: CategoriesArticles(
                arguments: CategoryPostsArguments(
                  categoryId: arguments.category.id,
                  isHome: false,
                ),
              ),
            ),
            SliverFillRemaining(
              child: Container(color: Theme.of(context).cardColor),
              hasScrollBody: false,
            )
          ],
        ),
      ),
    );
  }
}

class CategoriesArticles extends ConsumerWidget {
  const CategoriesArticles({
    Key? key,
    required this.arguments,
  }) : super(key: key);

  final CategoryPostsArguments arguments;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(loadInterstitalAd);
    final _paginationController = ref.watch(categoryPostController(arguments));
    final _controller = ref.watch(categoryPostController(arguments).notifier);

    if (_paginationController.refershError) {
      return SliverToBoxAdapter(
        child: Center(child: Text(_paginationController.errorMessage)),
      );

      /// on Initial State it will be empty
    } else if (_paginationController.initialLoaded == false) {
      return const SliverToBoxAdapter(child: LoadingCategoriesList());
    } else if (_paginationController.posts.isEmpty) {
      return const SliverToBoxAdapter(child: EmptyCategoriesList());
    } else {
      return MultiSliver(
        children: [
          CategoriesArticlesList(
            controller: _controller,
            paginationController: _paginationController,
          ),
          if (_paginationController.isPaginationLoading)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: LoadingAnimationWidget.threeArchedCircle(
                    color: AppColors.primary, size: 36),
              ),
            ),
        ],
      );
    }
  }
}

class CategoriesArticlesList extends StatelessWidget {
  const CategoriesArticlesList({
    Key? key,
    required CategoryPostsController controller,
    required PostPagination paginationController,
  })  : _controller = controller,
        _paginationController = paginationController,
        super(key: key);

  final CategoryPostsController _controller;
  final PostPagination _paginationController;

  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      child: SliverList(
        delegate: SliverChildBuilderDelegate(
          ((context, index) {
            _controller.handleScrollWithIndex(index);
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: AppDefaults.duration,
              child: FadeInAnimation(
                child: ArticleTileLarge(
                  article: _paginationController.posts[index],
                ),
              ),
            );
          }),
          childCount: _paginationController.posts.length,
        ),
      ),
    );
  }
}

class LoadingCategoriesList extends StatelessWidget {
  const LoadingCategoriesList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      itemBuilder: (context, index) => AnimationConfiguration.staggeredList(
        position: index,
        duration: AppDefaults.duration,
        child: const SlideAnimation(
          child: DummyArticleTile(),
        ),
      ),
      itemCount: 5,
    );
  }
}
