import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../config/wp_config.dart';
import '../../models/article.dart';
import '../../repositories/posts/post_repository.dart';

/// Provides Popular Posts
final popularPostsController = FutureProvider<List<ArticleModel>>((ref) async {
  final _repo = ref.read(postRepoProvider);

  /// If popular post plugin is enabled and no custom feature category is provided
  List<ArticleModel> _allPosts = await _repo.getPopularPosts(
      isPlugin: WPConfig.isPopularPostPluginEnabled);

  /// If popular post plugin is disabled
  if (WPConfig.isPopularPostPluginEnabled == false) {
    _allPosts = await _repo.getAllPost(pageNumber: 1);
  }

  /// On Smaller sites the popular post plugin takes some time to indexing
  /// the most popular sites, so if we don't want our users to go empty hand
  /// we must use a backup category
  if (_allPosts.isEmpty) {
    _allPosts = await _repo.getPopularPosts(isPlugin: false);
  }

  final _updatedList =
      _allPosts.map((e) => e.copyWith(heroTag: e.link + 'popular')).toList();

  return _updatedList;
});
