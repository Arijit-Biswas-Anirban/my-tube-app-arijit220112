import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mytube/features/upload/short_video/model/short_video_model.dart';

final shortVideoProvider = Provider((ref) => ShortVideoRepository(firestore: FirebaseFirestore.instance, auth: FirebaseAuth.instance),);

class ShortVideoRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  ShortVideoRepository({
    required this.firestore,
    required this.auth,
  });

  Future<void> addShortVideoToFirestore({
    required String caption,
    required String video,
    required DateTime datePublished,
  }) async {
    ShortVideoModel shortVideo = ShortVideoModel(
      caption: caption,
      userId: auth.currentUser!.uid,
      shortVideo: video,
      datePublished: datePublished,
    );
    await firestore.collection("shorts").add(shortVideo.toMap());
  }
}
