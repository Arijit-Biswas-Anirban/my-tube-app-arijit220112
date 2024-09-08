import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mytube/cores/screens/error_page.dart';
import 'package:mytube/cores/screens/loader.dart';
import 'package:mytube/cores/widgets/flat_button.dart';
import 'package:mytube/features/auth/provider/user_provider.dart';
import 'package:mytube/features/channel/user_channel/provider/chennel_provider.dart';
import 'package:mytube/features/content/Long_video/parts/post.dart';

class UserChannelPage extends StatefulWidget {
  final String userId;

  const UserChannelPage({super.key, required this.userId});

  @override
  State<UserChannelPage> createState() => _UserChannelPageState();
}

class _UserChannelPageState extends State<UserChannelPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Consumer(
                builder: (context, ref, child) {
                  return ref.watch(anyUserDataProvider(widget.userId)).when(
                      data: (user) => Padding(
                            padding: const EdgeInsets.only(top: 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Image.asset(
                                    "assets/images/my_channel_setting.jpeg"),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20, left: 12, right: 12),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 37,
                                        backgroundColor: Colors.grey,
                                        backgroundImage:
                                            CachedNetworkImageProvider(
                                                user.profilePic),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 12.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              user.displayName,
                                              style: const TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              "@${user.username}",
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.blueGrey,
                                              ),
                                            ),
                                            RichText(
                                              text: TextSpan(
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.blueGrey,
                                                ),
                                                children: [
                                                  TextSpan(
                                                      text:
                                                          "${user.subscriptions.length} subscriptions  "),
                                                  TextSpan(
                                                      text:
                                                          "${user.videos} videos"),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 20.0,
                                    left: 12,
                                    right: 12,
                                  ),
                                  child: FlatButton(
                                    text: "SUBSCRIBE",
                                    onPressed: () {},
                                    colour: Colors.redAccent,
                                  ),
                                ),
                                Padding(
                                      padding: const EdgeInsets.only(left: 10.0, top: 14),
                                      child: Text(
                                          "${user.displayName}'Videos",
                                          style: const TextStyle(
                                              fontSize: 23,
                                              fontWeight: FontWeight.bold),
                                        ),
                                    ),
                              ],
                            ),
                          ),
                      error: (error, stackTrace) => const ErrorPage(),
                      loading: () => const Loader());
                },
              ),
              Consumer(
                builder: (context, ref, child) {
                  return ref.watch(eachChennelVideosProvider(widget.userId)).when(
                    data: (videos) {
                      if (videos.isEmpty) {
                        return const Center(child: Text("No videos available"));
                      }
                      return Padding(
                        padding: const EdgeInsets.only(top: 12.0, bottom: 12),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.45,
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const AlwaysScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 5,
                            ),
                            itemCount: videos.length,
                            itemBuilder: (context, index) {
                              return Post(video: videos[index]);
                            },
                          ),
                        ),
                      );
                    },
                    error: (error, stackTrace) => const ErrorPage(),
                    loading: () => const Loader(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
