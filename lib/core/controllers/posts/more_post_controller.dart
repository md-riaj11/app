import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/article.dart';
import '../../repositories/posts/post_repository.dart';

final moreRelatedPostController = FutureProvider.autoDispose
    .family<List<ArticleModel>, int>((ref, categoryID) async {
  final _repository = ref.read(postRepoProvider);
  List<ArticleModel> _allPosts = [];

  _allPosts = await _repository.getPostByCategory(
      pageNumber: 1, categoryID: categoryID);

  if (_allPosts.isEmpty) {
    _allPosts = await _repository.getAllPost(pageNumber: 1);
  }

  final _returnList = _allPosts
      .map((e) => e.copyWith(heroTag: e.link + 'more_related_posts'))
      .toList();

  return _returnList;
});
