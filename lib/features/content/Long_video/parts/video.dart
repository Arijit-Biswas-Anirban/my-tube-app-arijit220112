// ignore_for_file: public_member_api_docs, sort_constructors_first, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mytube/cores/colors.dart';
import 'package:mytube/cores/screens/error_page.dart';
import 'package:mytube/cores/screens/loader.dart';
import 'package:mytube/cores/widgets/flat_button.dart';
import 'package:mytube/features/auth/model/user_model.dart';
import 'package:mytube/features/auth/provider/user_provider.dart';
import 'package:mytube/features/content/Long_video/parts/post.dart';
import 'package:mytube/features/content/Long_video/widgets/video_externel_buttons.dart';
import 'package:mytube/features/content/Long_video/widgets/video_first_comment.dart';
import 'package:mytube/features/content/comment/comment_provider.dart';
import 'package:mytube/features/upload/long_video/video_model.dart';
import 'package:mytube/features/upload/long_video/video_repository.dart';
import 'package:video_player/video_player.dart';

import '../../../channel/user_channel/subscribe_repository.dart';
import '../../../upload/comments/comment_model.dart';
import '../../comment/comment_sheet.dart';

class Video extends ConsumerStatefulWidget {
  final VideoModel video;

  const Video({
    Key? key,
    required this.video,
  }) : super(key: key);

  @override
  ConsumerState<Video> createState() => _VideoState();
}

class _VideoState extends ConsumerState<Video> {
  bool isShowIcons = false;
  bool isPlaying = false;

  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        VideoPlayerController.networkUrl(Uri.parse(widget.video.videoUrl))
          ..initialize().then((_) {
            setState(() {});
          });
  }

  toggleVideoPlayer() {
    if (_controller!.value.isPlaying) {
      //pause the video by click
      _controller!.pause();
      isPlaying = false;
      setState(() {});
    } else {
      //play the video by click
      _controller!.play();
      isPlaying = true;
      setState(() {});
    }
  }

  goBackward() {
    Duration position = _controller!.value.position;
    position = position - Duration(seconds: 1);
    _controller!.seekTo(position);
  }

  goForward() {
    Duration position = _controller!.value.position;
    position = position + Duration(seconds: 1);
    _controller!.seekTo(position);
  }

  likeVideo() async {
    await ref.watch(longVideoProvider).likeVideo(
          currentUserId: FirebaseAuth.instance.currentUser!.uid,
          likes: widget.video.likes,
          videoId: widget.video.videoId,
        );
  }

  @override
  @override
  Widget build(BuildContext context) {
    final AsyncValue<UserModel> user =
        ref.watch(anyUserDataProvider(widget.video.userId));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(176),
          child: Container(
            height: MediaQuery.sizeOf(context).height * 0.26,
            width: MediaQuery.sizeOf(context).width,
            child: _controller!.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controller!.value.aspectRatio,
                    child: GestureDetector(
                      onTap: isShowIcons
                          ? () {
                              isShowIcons = false;
                              setState(() {});
                            }
                          : () {
                              isShowIcons = true;
                              setState(() {});
                            },
                      child: Stack(
                        children: [
                          VideoPlayer(_controller!),
                          isShowIcons
                              ? Positioned(
                                  left: 170,
                                  top: 92,
                                  child: GestureDetector(
                                    onTap: toggleVideoPlayer,
                                    child: SizedBox(
                                      height: 50,
                                      child: Image.asset(
                                        "assets/images/play.png",
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                          isShowIcons
                              ? Positioned(
                                  right: 55,
                                  top: 96,
                                  child: GestureDetector(
                                    onTap: goForward,
                                    child: SizedBox(
                                      height: 50,
                                      child: Image.asset(
                                        "assets/images/go ahead final.png",
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                          isShowIcons
                              ? Positioned(
                                  left: 48,
                                  top: 96,
                                  child: GestureDetector(
                                    onTap: goBackward,
                                    child: SizedBox(
                                      height: 50,
                                      child: Image.asset(
                                        "assets/images/go_back_final.png",
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                              : SizedBox(),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: SizedBox(
                              height: 7.5,
                              child: VideoProgressIndicator(
                                _controller!,
                                allowScrubbing: true,
                                colors: VideoProgressColors(
                                  playedColor: Colors.red,
                                  bufferedColor: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Loader(),
                  ),
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 13.0, top: 4),
              child: Text(
                widget.video.title,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 7, top: 5),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 4),
                    child: Text(
                      widget.video.views == 0
                          ? "No View"
                          : "${widget.video.views} views",
                      style: const TextStyle(
                        fontSize: 13.4,
                        color: Color(0xff5F5F5F),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4, right: 8),
                    child: Text(
                      "5 minutes ago",
                      style: const TextStyle(
                        fontSize: 13.4,
                        color: Color(0xff5F5F5F),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 12,
                top: 9,
                right: 9,
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.grey,
                    backgroundImage:
                        CachedNetworkImageProvider(user.value!.profilePic),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 10,
                      right: 5,
                    ),
                    child: Text(
                      user.value!.displayName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 6.0, left: 6),
                    child: Text(
                      user.value!.subscriptions.isEmpty
                          ? "No Subscription"
                          : "${user.value!.subscriptions.length} Subscriptions",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    height: 35,
                    width: 100,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white, backgroundColor: Colors.black, // Text color
                        ),
                        onPressed: () async {
                          // Ensure subscriptions is a List<String>
                          final subscriptions = List<String>.from(user.value!.subscriptions);

                          await ref.read(subscribeChannelProvider).subscribeChannel(
                            userId: user.value!.userId,
                            currentUserId: FirebaseAuth.instance.currentUser!.uid,
                            subscriptions: subscriptions,
                          );
                          ref.refresh(anyUserDataProvider(widget.video.userId));
                        },
                        child: Text(
                          user.value!.subscriptions.contains(FirebaseAuth.instance.currentUser!.uid)
                              ? "Unsubscribe"
                              : "Subscribe",
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 9, top: 10.5, right: 9),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 6,
                      ),
                      decoration: const BoxDecoration(
                        color: softBlueGreyBackGround,
                        borderRadius: BorderRadius.all(
                          Radius.circular(25),
                        ),
                      ),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: likeVideo,
                            child: Icon(
                              Icons.thumb_up,
                              color: widget.video.likes.contains(
                                      FirebaseAuth.instance.currentUser!.uid)
                                  ? Colors.blue
                                  : Colors.black,
                              size: 15.5,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text("${widget.video.likes.length}"),
                          const SizedBox(width: 20),
                          const Icon(
                            Icons.thumb_down,
                            size: 15.5,
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 9, right: 9),
                      child: VideoExtraButton(
                        text: "Share",
                        iconData: Icons.share,
                      ),
                    ),
                    const VideoExtraButton(
                      text: "Remix",
                      iconData: Icons.analytics_outlined,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 9, right: 9),
                      child: VideoExtraButton(
                        text: "Download",
                        iconData: Icons.download,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //comment section
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
              child: GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => CommentSheet(
                      video: widget.video,
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.all(
                      Radius.circular(9),
                    ),
                  ),
                  height: 65,
                  width: 200,
                  child: Consumer(
                    builder: (context, ref, child) {
                      final AsyncValue<List<CommentModel>> comments = ref.watch(
                        commentsProvider(widget.video.videoId),
                      );
                      if (comments.value!.isEmpty) {
                        return const SizedBox(
                          height: 20,
                        );
                      }
                      return VideoFirstComment(
                          comments: comments.value!, user: user.value!);
                    },
                  ),
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("videos")
                    .where("userId", isEqualTo: widget.video.userId)
                    .where("videoId", isNotEqualTo: widget.video.videoId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Loader();
                  }

                  if (snapshot.hasError) {
                    print('Error fetching suggested videos: ${snapshot.error}');
                    return Center(
                      child: Text(
                        "There was an error fetching suggested videos. Please try again later.",
                        style: TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  if (!snapshot.hasData ||
                      snapshot.data == null ||
                      snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(
                        "No suggested videos available at the moment.",
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }

                  try {
                    final videosMap = snapshot.data?.docs;
                    final videos = videosMap
                        ?.map((video) => VideoModel.fromMap(video.data()))
                        .toList();

                    return Padding(
                      padding: const EdgeInsets.all(8),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: videos?.length ?? 0,
                        itemBuilder: (context, index) {
                          return Post(video: videos![index]);
                        },
                      ),
                    );
                  } catch (error) {
                    print('Error mapping suggested videos: $error');
                    return Center(
                      child: Text(
                        "Error displaying suggested videos. Please try again later.",
                        style: TextStyle(color: Colors.red),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
