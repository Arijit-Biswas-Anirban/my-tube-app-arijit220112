import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mytube/features/auth/provider/user_provider.dart';
import 'package:mytube/features/content/Long_video/parts/video.dart';
import 'package:mytube/features/upload/long_video/video_model.dart';

import '../../../auth/model/user_model.dart';

class Post extends ConsumerWidget {
  final VideoModel video;

  const Post({Key? key, required this.video}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<UserModel> userModel =
        ref.watch(anyUserDataProvider(video.userId));
    final user = userModel.whenData((user) => user);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Video(
              video: video,
            ),
          ),
        );
      },
      child: Column(
        children: [
          CachedNetworkImage(
            imageUrl: video.thumbnail,
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 5),
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey,
                  backgroundImage:
                      CachedNetworkImageProvider(user.value!.profilePic),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(
                  video.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.more_vert),
              ),
            ],
          ),
          Padding(
            padding:
                EdgeInsets.only(left: MediaQuery.sizeOf(context).width * 0.12),
            child: Row(
              children: [
                Text(
                  user.value!.displayName,
                  style: const TextStyle(
                    color: Colors.blueGrey,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    video.views == 0 ? "No View" : "${video.views}",
                    style: const TextStyle(
                      color: Colors.blueGrey,
                    ),
                  ),
                ),
                const Text(
                  "a moment ago",
                  style: const TextStyle(
                    color: Colors.blueGrey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
