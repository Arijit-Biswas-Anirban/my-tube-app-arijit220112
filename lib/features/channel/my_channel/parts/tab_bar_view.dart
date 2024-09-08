import 'package:flutter/material.dart';
import 'package:mytube/features/channel/my_channel/pages/home_channel_page.dart';

class PageTabBarView extends StatelessWidget {
  const PageTabBarView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Expanded(
      child: TabBarView(
        children: [
          HomeChannelPage(),
          Center(
            child: Text("Videos"),
          ),
          Center(
            child: Text("Shorts"),
          ),
          Center(
            child: Text("Community"),
          ),
          Center(
            child: Text("Playlists"),
          ),
          Center(
            child: Text("Channels"),
          ),
          Center(
            child: Text("About"),
          ),
        ],
      ),
    );
  }
}
