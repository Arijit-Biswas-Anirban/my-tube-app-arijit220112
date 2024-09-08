import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mytube/features/auth/model/user_model.dart';
import 'package:mytube/features/upload/long_video/video_model.dart';

final allChannelsProvider = FutureProvider<List<UserModel>>((ref) async {
  final usersMap = await FirebaseFirestore.instance.collection("users").get();
  List<UserModel> users = usersMap.docs
      .map(
        (user) => UserModel.fromMap(user.data()),
  )
      .toList();
  return users;
});

final allVideosProvider = FutureProvider<List<VideoModel>>((ref) async {
  final videosMap = await FirebaseFirestore.instance.collection("videos").get();
  List<VideoModel> videos = videosMap.docs
      .map(
        (video) => VideoModel.fromMap(video.data()),
  )
      .toList();
  return videos;
});

