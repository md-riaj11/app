import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../core/components/article_tile_large.dart';
import '../../../core/components/column_builder.dart';
import '../../../core/components/dummy_article_tile.dart';
import '../../../core/constants/constants.dart';
import '../../../core/models/article.dart';

class SearchedArticleList extends StatelessWidget {
  const SearchedArticleList({
    Key? key,
    required List<ArticleModel> searchedList,
    required this.isSearching,
  })  : _searchedList = searchedList,
        super(key: key);

  final List<ArticleModel> _searchedList;
  final bool isSearching;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDefaults.padding),
      child: isSearching
          ? const SearchLoading()
          : _searchedList.isEmpty
              ? const SearchedListEmpty()
              : ColumnBuilder(
                  itemBuilder: ((context, index) => ArticleTileLarge(
                        article: _searchedList[index],
                      )),
                  itemCount: _searchedList.length,
                ),
    );
  }
}

class SearchLoading extends StatelessWidget {
  const SearchLoading({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ColumnBuilder(
      itemBuilder: (context, index) => const DummyArticleTile(),
      itemCount: 5,
    );
  }
}

class SearchedListEmpty extends StatelessWidget {
  const SearchedListEmpty({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          child: Image.asset(AppImages.emptyPost),
        ),
        AppSizedBox.h16,
        AppSizedBox.h16,
        Text(
          'search_empty'.tr(),
          style: Theme.of(context).textTheme.headline6,
        ),
        AppSizedBox.h16,
        Text(
          'search_empty_message'.tr(),
          style: Theme.of(context).textTheme.caption,
        )
      ],
    );
  }
}
