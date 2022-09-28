import 'dart:ui';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../layout/Social_app/cubit/cubit.dart';
import '../../../layout/Social_app/cubit/status.dart';
import '../../../models/social_app/social_comment_model.dart';

class CommentsScreen extends StatelessWidget {
  final String postId;

  CommentsScreen({Key? key, required this.postId}) : super(key: key);

  final commentController = TextEditingController();
  final now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        SocialCubit.get(context).getComments(postId: postId);

        return BlocConsumer<SocialCubit, SocialStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                title: Text('Comments'),
              ),
              body: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [ConditionalBuilder(
                      condition:SocialCubit.get(context).comments.isNotEmpty,
                      builder: (context) => Expanded(
                        child: ListView.separated(
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return _buildCommentItem(context,
                                SocialCubit.get(context).comments[index]);
                          },
                          separatorBuilder: (context, index) => SizedBox(
                            height: 5,
                          ),
                          itemCount: SocialCubit.get(context).comments.length,
                        ),
                      ),
                  fallback:(context) => Expanded(
                      child: Center(
                          child: Text(
                            'No comments',
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey.shade600),
                          ))),),

                    _buildWriteCommentRow(context),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  _buildCommentItem(context, SocialCommentModel comment) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(
              '${comment.image}',
            ),
            radius: 22,
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            Text(
                              '${comment.name}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            right: 12, left: 12, bottom: 12),
                        child: Text(
                          '${comment.text}',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildWriteCommentRow(context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              decoration: InputDecoration(
                hintText: 'Write your comment..',
                border: InputBorder.none,
              ),
              controller: commentController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              style: TextStyle(fontSize: 16),
              cursorHeight: 20,
            ),
          ),
          IconButton(
            onPressed: () {
              SocialCubit.get(context).writeComment(
                postId: postId,
                dateTime: now.toString(),
                text: commentController.text,
              );
              commentController.clear();
            },
            icon: Transform.translate(
              offset: const Offset(10, 0),
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.blue,
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }
}