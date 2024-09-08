import 'package:flutter/cupertino.dart';
import 'package:mytube/features/content/Long_video/long_video_screen.dart';
import 'package:mytube/features/content/short_video/pages/short_video_page.dart';

List pages = [
  LongVideoScreen(),
  ShortVideoPage(),
  const Center(
    child: Text("Upload"),
  ),
  const Center(
    child: Text("Home"),
  ),
  const Center(
    child: Text("Home"),
  ),
];