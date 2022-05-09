import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../../core/constants/constants.dart';
import '../../../core/models/article.dart';
import 'empty_saved_list.dart';
import 'saved_article_tile.dart';

class SavedListViewBuilder extends StatelessWidget {
  const SavedListViewBuilder({
    Key? key,
    required this.data,
    required this.listKey,
    required this.onRefresh,
  }) : super(key: key);

  final List<ArticleModel> data;
  final GlobalKey<AnimatedListState> listKey;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const EmptySavedList();
    } else {
      return RefreshIndicator(
        onRefresh: onRefresh,
        child: AnimatedList(
          padding: const EdgeInsets.only(top: 16),
          key: listKey,
          initialItemCount: data.length,
          itemBuilder: (context, index, animation) {
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: AppDefaults.duration,
              child: SlideAnimation(
                child: SavedArticleTile(
                  article: data[index],
                  animation: animation,
                  index: index,
                ),
              ),
            );
          },
        ),
      );
    }
  }
}
