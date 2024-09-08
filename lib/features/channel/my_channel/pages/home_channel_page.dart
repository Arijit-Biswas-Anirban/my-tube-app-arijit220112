import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../cores/screens/error_page.dart';
import '../../../../cores/screens/loader.dart';
import '../../../content/Long_video/parts/post.dart';
import '../../user_channel/provider/chennel_provider.dart';

class HomeChannelPage extends StatelessWidget {
  const HomeChannelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(
        builder: (context, ref, child) {
          return ref.watch(eachChennelVideosProvider(
              FirebaseAuth.instance.currentUser!.uid)).when(
            data: (videos) {
              if (videos.isEmpty) {
                return const Center(child: Text("No videos available"));
              }
              return Padding(
                padding: const EdgeInsets.only(top: 12.0, bottom: 12),
                child: Container(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.45,
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
    );
  }
}
