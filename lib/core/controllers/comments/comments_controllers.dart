import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../repositories/auth/auth_repository.dart';
import '../../repositories/posts/comment_repository.dart';
import 'comment_pagination.dart';

final postCommentController = StateNotifierProvider.family
    .autoDispose<CommentPaginationController, CommentPagination, int>(
        (ref, int postID) {
  final _repo = CommentRepository();
  final _authRepo = ref.read(authRepositoryProvider);
  return CommentPaginationController(_repo, postID, _authRepo);
});

class CommentPaginationController extends StateNotifier<CommentPagination> {
  CommentPaginationController(
    this.repository,
    this.postID,
    this._authRepo, [
    CommentPagination? state,
  ]) : super(state ?? CommentPagination.initial()) {
    {
      getComments();
    }
  }

  final CommentRepository repository;
  final int postID;
  final AuthRepository _authRepo;

  getComments() async {
    try {
      // get comments
      final _comments = await repository.getComments(
        page: state.page,
        postId: postID,
        perPage: 10,
      );
      // for initial loading screen
      if (mounted && state.page == 1) {
        state = state.copyWith(initialLoaded: true);
      }
      if (mounted) {
        state = state.copyWith(
          comments: [...state.comments, ..._comments],
          page: state.page + 1,
          isPaginationLoading: false,
        );
      }
    } on Exception {
      state = state.copyWith(
        errorMessage: 'Fetch Error',
        initialLoaded: true,
        isPaginationLoading: false,
      );
    }
  }

  void handlePagination(int index) {
    final itemPosition = index + 1;
    final requestMoreData = itemPosition % 10 == 0 && itemPosition != 0;

    final pageToRequest = itemPosition ~/ 10;
    if (requestMoreData && pageToRequest + 1 >= state.page) {
      getComments();
    }
  }

  Future<void> onRefresh() async {
    state = CommentPagination.initial();
    await getComments();
  }

  /// Write a comment
  writeComment({
    required String email,
    required String name,
    required String content,
  }) async {
    final _oldState = state;

    final _token = await _authRepo.getToken();
    if (_token != null) {
      bool _isAdded = await repository.createComment(
        email: email,
        name: name,
        content: content,
        postID: postID,
        token: _token,
      );
      if (_isAdded) {
        state = CommentPagination.initial();
        await getComments();
      }
    } else {
      state = _oldState;
    }
  }

  /// Reply To A Comment
  writeReply({
    required String email,
    required String name,
    required String content,
    required int parentCommentID,
  }) async {
    final _oldState = state;

    final _token = await _authRepo.getToken();
    if (_token != null) {
      bool _isAdded = await repository.replyToComment(
        email: email,
        name: name,
        content: content,
        postID: postID,
        token: _token,
        parentCommentID: parentCommentID,
      );
      if (_isAdded) {
        state = CommentPagination.initial();
        await getComments();
      }
    } else {
      state = _oldState;
    }
  }
}
