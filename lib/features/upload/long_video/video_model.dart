import 'package:cloud_firestore/cloud_firestore.dart';

class VideoModel {
  final String videoUrl;
  final String thumbnail;
  final String title;
  final DateTime datePublished;
  final int views;
  final String videoId;
  final String userId;
  final List likes;
  final String type;

  VideoModel({
    required this.videoUrl,
    required this.thumbnail,
    required this.title,
    required this.datePublished,
    required this.views,
    required this.videoId,
    required this.userId,
    required this.likes,
    required this.type,
  });

  // Method to convert a VideoModel to a Map<String, dynamic>
  Map<String, dynamic> toMap() {
    return {
      'videoUrl': videoUrl,
      'thumbnail': thumbnail,
      'title': title,
      'datePublished': datePublished,
      'views': views,
      'videoId': videoId,
      'userId': userId,
      'likes': likes,
      'type': type,
    };
  }

  // Factory constructor to create a VideoModel from a Map<String, dynamic>
  factory VideoModel.fromMap(Map<String, dynamic> map) {
    return VideoModel(
      videoUrl: map['videoUrl'] as String,
      thumbnail: map['thumbnail'] as String,
      title: map['title'] as String,
      datePublished: map["datePublished"] is Timestamp
          ? (map["datePublished"] as Timestamp).toDate()
          : DateTime.fromMillisecondsSinceEpoch(
              map["datePublished"] as int,
            ),
      views: map['views'] as int,
      videoId: map['videoId'] as String,
      userId: map['userId'] as String,
      likes: List<dynamic>.from(map['likes']),
      // Ensure it's a List
      type: map['type'] as String,
    );
  }
}
