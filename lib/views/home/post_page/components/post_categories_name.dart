import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../../../core/controllers/category/categories_controller.dart';
import '../../../../core/models/article.dart';

class PostCategoriesName extends StatelessWidget {
  const PostCategoriesName({
    Key? key,
    required this.article,
  }) : super(key: key);

  final ArticleModel article;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final _allCategories = ref
            .read(categoriesController.notifier)
            .categoriesName(article.categories);
        return Wrap(
          spacing: 8.0,
          children: AnimationConfiguration.toStaggeredList(
            childAnimationBuilder: (child) => SlideAnimation(
              child: child,
              horizontalOffset: 0,
              verticalOffset: 50,
            ),
            children: List.generate(
              _allCategories.length,
              (index) => Chip(
                padding: const EdgeInsets.all(4.0),
                labelStyle: Theme.of(context).textTheme.caption,
                backgroundColor: Theme.of(context).cardColor,
                label: AutoSizeText(
                  _allCategories[index],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
