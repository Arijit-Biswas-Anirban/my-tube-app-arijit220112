import 'package:flutter/cupertino.dart';
import 'package:mytube/features/auth/pages/logout_page.dart';
import 'package:mytube/features/content/Long_video/long_video_screen.dart';
import 'package:mytube/features/content/short_video/pages/short_video_page.dart';
import 'package:mytube/features/search/pages/search_screen.dart';

List pages = [
  const LongVideoScreen(),
  const ShortVideoPage(),
  const Center(
    child: Text("Upload"),
  ),
  const SearchScreen(),
  const LogoutPage(),
];