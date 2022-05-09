import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/models/comment.dart';
import 'user_comments.dart';

class AllComments extends StatelessWidget {
  const AllComments({
    Key? key,
    required this.allComments,
    required this.articleID,
    required this.handlePagination,
    required this.onRefresh,
    required this.onReply,
  }) : super(key: key);

  final List<CommentModel> allComments;
  final int articleID;
  final void Function(int) handlePagination;
  final Future<void> Function() onRefresh;
  final void Function(String userName, int parentCommentID) onReply;

  @override
  Widget build(BuildContext context) {
    /// COMMENTS
    final _comments =
        allComments.where((element) => element.parentCommentID == 0).toList();

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        itemBuilder: (context, index) {
          final CommentModel _comment = _comments[index];

          /// REPLIES
          final _replies = allComments
              .where(
                (element) => element.parentCommentID == _comment.id,
              )
              .toList();

          handlePagination(index);
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: AppDefaults.duration,
            child: SlideAnimation(
              child: UserComment(
                userName: _comment.authorName,
                userImage: _comment.avatarURL,
                comment: _comment.content,
                timeStamp: DateFormat.yMMMMEEEEd(context.locale.toLanguageTag())
                    .format(_comment.time),
                replies: _replies
                    .where((element) => element.parentCommentID == _comment.id)
                    .toList(),
                onReply: () {
                  onReply(_comment.authorName, _comment.id);
                },
              ),
            ),
          );
        },
        itemCount: _comments.length,
      ),
    );
  }
}

class CommentIsEmpty extends StatelessWidget {
  const CommentIsEmpty({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppSizedBox.h16,
                Image.asset(
                  AppImages.emptyPost,
                  width: MediaQuery.of(context).size.width * 0.6,
                ),
                AppSizedBox.h16,
                AppSizedBox.h16,
                Text(
                  'comment_empty'.tr(),
                  style: Theme.of(context).textTheme.headline6,
                ),
                AppSizedBox.h10,
                Text(
                  'comment_empty_message'.tr(),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
