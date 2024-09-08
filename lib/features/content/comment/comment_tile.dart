import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mytube/features/upload/comments/comment_model.dart';

class CommentTile extends StatelessWidget {
  final CommentModel comment;

  const CommentTile({
    Key? key,
    required this.comment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 7.0),
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 7.0),
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.grey,
                  backgroundImage: CachedNetworkImageProvider(comment.profilePic),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                comment.displayName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              const Text(
                "a moment ago",
                style: TextStyle(color: Colors.blueGrey),
              ),
              const Spacer(),
              const Icon(Icons.more_vert),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(right: MediaQuery.sizeOf(context).width*0.57),
            child: Text(comment.commentText),
          ),
        ],
      ),
    );
  }
}
