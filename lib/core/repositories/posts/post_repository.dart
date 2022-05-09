import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import '../../../config/wp_config.dart';
import '../../models/article.dart';
import 'post_local_repository.dart';

final postRepoProvider = Provider<PostRepository>((ref) {
  final _localRepo = ref.read(postLocalRepoProvider);
  final _repo = PostRepository(_localRepo);
  return _repo;
});

abstract class PostRepoAbstract {
  /// Get All Posts [Paginated]
  Future<List<ArticleModel>> getAllPost({required int pageNumber});

  /// Get Post By Category
  Future<List<ArticleModel>> getPostByCategory({
    required int pageNumber,
    required int categoryID,
  });

  Future<List<ArticleModel>> getPostByTag({
    required int pageNumber,
    required int tagID,
  });

  /// Get Post
  Future<ArticleModel?> getPost({required int postID});

  /// Get Popular Posts
  ///
  /// [isPlugin] This is because sometimes the popular post plugin returns an empty
  /// array or you wanna just add a feature post by yourself, which
  /// in this case this is required
  Future<List<ArticleModel>> getPopularPosts({bool isPlugin = true});

  /// Search Posts
  Future<List<ArticleModel>> searchPost({required String keyword});

  /// Retrieve all saved posts
  Future<List<ArticleModel>> getsavedPosts();
}

/// [PostRepository] that is responsible for posts getting
/// It is an implementation from the above abstract class
class PostRepository extends PostRepoAbstract {
  PostRepository(this._postLocalRepo);
  final PostLocalRepository _postLocalRepo;

  /* <---- Get All Posts -----> */
  @override
  Future<List<ArticleModel>> getAllPost({
    required int pageNumber,
  }) async {
    final _client = http.Client();
    String _url =
        'https://${WPConfig.url}/wp-json/wp/v2/posts/?page=$pageNumber';
    List<ArticleModel> _articles = [];
    try {
      final _response = await _client.get(Uri.parse(_url));
      if (_response.statusCode == 200) {
        final posts = jsonDecode(_response.body) as List;
        _articles = posts.map(((e) => ArticleModel.fromMap(e))).toList();
      }
      return _articles;
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      return [];
    } finally {
      _client.close();
    }
  }

  /* <---- Get Post By Category -----> */
  @override
  Future<List<ArticleModel>> getPostByCategory({
    required int pageNumber,
    required int categoryID,
  }) async {
    final _client = http.Client();
    String _url =
        'https://${WPConfig.url}/wp-json/wp/v2/posts/?categories=$categoryID&page=$pageNumber';
    List<ArticleModel> _articles = [];
    try {
      final _response = await _client.get(Uri.parse(_url));
      if (_response.statusCode == 200) {
        final posts = jsonDecode(_response.body) as List;
        _articles = posts.map((e) => ArticleModel.fromMap(e)).toList();
      }
      return _articles;
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      return [];
    } finally {
      _client.close();
    }
  }

  @override
  Future<List<ArticleModel>> getPostByTag({
    required int pageNumber,
    required int tagID,
  }) async {
    final _client = http.Client();
    String _url =
        'https://${WPConfig.url}/wp-json/wp/v2/posts/?tags=$tagID&page=$pageNumber';
    List<ArticleModel> _articles = [];
    try {
      final _response = await _client.get(Uri.parse(_url));
      if (_response.statusCode == 200) {
        final posts = jsonDecode(_response.body) as List;
        _articles = posts.map((e) => ArticleModel.fromMap(e)).toList();
      }
      return _articles;
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      return [];
    } finally {
      _client.close();
    }
  }

  /* <---- Get Popular Posts -----> */
  @override
  Future<List<ArticleModel>> getPopularPosts({
    bool isPlugin = true,
    int featureCategory = 1,
  }) async {
    final _client = http.Client();
    List<ArticleModel> _articles = [];

    /// Fetching from Plugin
    if (isPlugin) {
      String _url =
          'https://${WPConfig.url}/wp-json/wordpress-popular-posts/v1/popular-posts/';
      try {
        final _response = await _client.get(Uri.parse(_url));
        if (_response.statusCode == 200) {
          final posts = jsonDecode(_response.body) as List;
          _articles = posts.map(((e) => ArticleModel.fromMap(e))).toList();
        }
      } on Exception catch (e) {
        Fluttertoast.showToast(msg: e.toString());
      } finally {
        _client.close();
      }
      return _articles;
    }

    /// If not plugin then we are going to fetch feature category
    else {
      String _url =
          'https://${WPConfig.url}/wp-json/wp/v2/posts/?categories=$featureCategory';
      try {
        final _response = await _client.get(Uri.parse(_url));
        if (_response.statusCode == 200) {
          final posts = jsonDecode(_response.body) as List;
          _articles = posts.map(((e) => ArticleModel.fromMap(e))).toList();
        }
      } on Exception catch (e) {
        Fluttertoast.showToast(msg: e.toString());
      } finally {
        _client.close();
      }
      return _articles;
    }
  }

  /* <---- Get a Post -----> */
  @override
  Future<ArticleModel?> getPost({required int postID}) async {
    final _client = http.Client();
    String _url = 'https://${WPConfig.url}/wp-json/wp/v2/posts/$postID';

    try {
      final _response = await _client.get(Uri.parse(_url));
      if (_response.statusCode == 200) {
        return ArticleModel.fromJson(_response.body);
      } else {
        return null;
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    } finally {
      _client.close();
    }
    return null;
  }

  /* <---- Search a post -----> */
  @override
  Future<List<ArticleModel>> searchPost({required String keyword}) async {
    final _client = http.Client();
    String _url =
        'https://${WPConfig.url}/wp-json/wp/v2/posts/?search=$keyword';
    List<ArticleModel> _articles = [];

    try {
      final _response = await _client.get(Uri.parse(_url));
      if (_response.statusCode == 200) {
        final posts = jsonDecode(_response.body) as List;
        _articles = posts.map(((e) => ArticleModel.fromMap(e))).toList();
      }

      return _articles;
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      return [];
    } finally {
      _client.close();
    }
  }

  @override
  Future<List<ArticleModel>> getsavedPosts() async {
    final _ids = await _postLocalRepo.getSavedPostsID();
    List<ArticleModel> _allPosts = [];
    for (var id in _ids) {
      final _post = await getPost(postID: id);
      if (_post != null) _allPosts.add(_post);
    }
    return _allPosts;
  }
}
