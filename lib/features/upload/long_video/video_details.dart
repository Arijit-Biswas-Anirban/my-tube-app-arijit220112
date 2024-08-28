import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mytube/cores/methods.dart';
import 'package:mytube/features/upload/long_video/video_repository.dart';
import 'package:uuid/uuid.dart';

class VideoDetailsPage extends ConsumerStatefulWidget {
  final File? video;

  const VideoDetailsPage({this.video});

  @override
  ConsumerState<VideoDetailsPage> createState() => _VideoDetailsPageState();
}

class _VideoDetailsPageState extends ConsumerState<VideoDetailsPage> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  File? image;
  bool isThumbnailSelected = false;
  String randomNumber = const Uuid().v4();
  String videoId = const Uuid().v4();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 20, left: 12, right: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Enter the title",
                style: TextStyle(fontSize: 15, color: Colors.grey),
              ),
              const SizedBox(
                height: 5,
              ),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                    hintText: "Enter the title",
                    prefixIcon: Icon(Icons.title),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                      color: Colors.lightBlue,
                    ))),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Enter the description",
                style: TextStyle(fontSize: 15, color: Colors.grey),
              ),
              const SizedBox(
                height: 5,
              ),
              TextField(
                controller: descriptionController,
                maxLines: 5,
                decoration: const InputDecoration(
                    hintText: "Enter the description",
                    prefixIcon: Icon(Icons.description),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                      color: Colors.lightBlue,
                    ))),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                decoration: const BoxDecoration(
                  color: Colors.lightBlue,
                  borderRadius: BorderRadius.all(
                    Radius.circular(12),
                  ),
                ),
                child: TextButton(
                  onPressed: () async {
                    //picking image for thumbnail
                    image = await pickImage();
                    isThumbnailSelected = true;
                    setState(() {});
                  },
                  child: const Text(
                    "Select Thumbnail",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              isThumbnailSelected
                  ? Padding(
                      padding: const EdgeInsets.only(top: 12, bottom: 12),
                      child: Image.file(
                        image!,
                        cacheHeight: 260,
                        cacheWidth: 400,
                      ),
                    )
                  : const SizedBox(),
              isThumbnailSelected
                  ? Container(
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.all(
                          Radius.circular(12),
                        ),
                      ),
                      child: TextButton(
                        onPressed: () async {
                          //publish the video
                          String thumbnail = await putFileInStorage(
                              image, randomNumber, "image");
                          String videoUrl = await putFileInStorage(
                              widget.video, randomNumber, "video");
                          ref.watch(longVideoProvider).uploadVideoToFirestore(
                                videoUrl: videoUrl,
                                thumbnail: thumbnail,
                                title: titleController.text,
                                datePublished: DateTime.now(),
                                videoId: videoId,
                                userId: FirebaseAuth.instance.currentUser!.uid,
                              );
                        },
                        child: const Text(
                          "Publish",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
