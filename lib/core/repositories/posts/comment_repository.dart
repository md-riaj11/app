import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import '../../../config/wp_config.dart';
import '../../models/comment.dart';

abstract class CommentRepoAbstract {
  /// Create a Comment to the post
  Future<bool> createComment({
    required String email,
    required String name,
    required String content,
    required int postID,
    required String token,
  });

  /// Get All Comments of Specifiied post
  Future<List<CommentModel>> getComments({
    required int postId,
    required int page,
  });

  Future<bool> replyToComment({
    required int parentCommentID,
    required String email,
    required String name,
    required String content,
    required int postID,
    required String token,
  });
}

class CommentRepository extends CommentRepoAbstract {
  @override
  Future<bool> createComment({
    required String email,
    required String name,
    required String content,
    required int postID,
    required String token,
  }) async {
    String _url =
        'https://${WPConfig.url}/wp-json/wp/v2/comments/?post=$postID&author_email=$email&author_name=$name&content=$content';

    try {
      final _response = await http
          .post(Uri.parse(_url), headers: {'Authorization': 'Bearer $token'});
      if (_response.statusCode == 201) {
        Fluttertoast.showToast(
          msg: 'Comment has been added',
        );
        return true;
      } else if (_response.statusCode == 409) {
        Fluttertoast.showToast(msg: 'Duplicate Comment');
        return false;
      } else if (_response.statusCode == 409) {
        Fluttertoast.showToast(msg: 'Duplicate Comment');
        return false;
      } else if (_response.statusCode == 400) {
        Fluttertoast.showToast(msg: 'Too many comments');
        return false;
      } else {
        Fluttertoast.showToast(msg: 'Something gone wrong');
        return false;
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      return false;
    }
  }

  @override
  Future<List<CommentModel>> getComments({
    required int postId,
    required int page,
    int perPage = 3,
  }) async {
    final _client = http.Client();
    String _url =
        'https://${WPConfig.url}/wp-json/wp/v2/comments?post=$postId&page=$page&per_page=$perPage';
    List<CommentModel> _fetchedComments = [];
    try {
      final _response = await _client.get(Uri.parse(_url));
      if (_response.statusCode == 200) {
        final _allComments = jsonDecode(_response.body) as List;
        _fetchedComments =
            _allComments.map((e) => CommentModel.fromMap(e)).toList();
        return _fetchedComments;
      } else {
        return _fetchedComments;
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error while getting comments');
      return _fetchedComments;
    } finally {
      _client.close();
    }
  }

  @override
  Future<bool> replyToComment(
      {required int parentCommentID,
      required String email,
      required String name,
      required String content,
      required int postID,
      required String token}) async {
    String _url =
        'https://${WPConfig.url}/wp-json/wp/v2/comments/?post=$postID&author_email=$email&author_name=$name&content=$content&parent=$parentCommentID';

    try {
      final _response = await http
          .post(Uri.parse(_url), headers: {'Authorization': 'Bearer $token'});
      if (_response.statusCode == 201) {
        Fluttertoast.showToast(
          msg: 'Comment has been added',
        );
        return true;
      } else if (_response.statusCode == 409) {
        Fluttertoast.showToast(msg: 'Duplicate Comment');
        return false;
      } else if (_response.statusCode == 409) {
        Fluttertoast.showToast(msg: 'Duplicate Comment');
        return false;
      } else if (_response.statusCode == 400) {
        Fluttertoast.showToast(msg: 'Too many comments');
        return false;
      } else {
        Fluttertoast.showToast(msg: 'Something gone wrong');
        return false;
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      return false;
    }
  }
}
