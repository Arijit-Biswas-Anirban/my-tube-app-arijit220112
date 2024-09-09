import 'dart:io';

import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:flutter/material.dart';
import 'package:mytube/cores/methods.dart';
import 'package:mytube/features/upload/short_video/model/short_video_model.dart';
import 'package:mytube/features/upload/short_video/pages/short_video_details_page.dart';
import 'package:mytube/features/upload/short_video/widgets/trim_slinder.dart';
import 'package:video_editor/video_editor.dart';

class ShortVideoScreen extends StatefulWidget {
  final File shortVideo;

  const ShortVideoScreen({super.key, required this.shortVideo});

  @override
  State<ShortVideoScreen> createState() => _ShortVideoScreenState();
}

class _ShortVideoScreenState extends State<ShortVideoScreen> {
  VideoEditorController? editorController;
  final isExporting = ValueNotifier<bool>(false);
  final exportingProgress = ValueNotifier<double>(0.0);

  @override
  void initState() {
    super.initState();
    editorController = VideoEditorController.file(
      widget.shortVideo,
      minDuration: const Duration(seconds: 3),
      maxDuration: const Duration(seconds: 60),
    );
    editorController!
        .initialize(aspectRatio: 4 / 3.6)
        .then((_) => setState(() {}));
  }

  Future<void> exportVideo() async {
    isExporting.value = true;
    final config = VideoFFmpegVideoEditorConfig(editorController!);
    final execute = await config.getExecuteConfig();
    final String command = execute.command;

    FFmpegKit.executeAsync(
      command,
      (session) async {
        final ReturnCode? code = await session.getReturnCode();
        if (ReturnCode.isSuccess(code)) {
          // export the video
          isExporting.value = false;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ShortVideoDetailsPage(
                video: widget.shortVideo
              ),
            ),
          );
        } else {
          //show errors
          showErrorSnackBar("Failed, video can not be exported", context);
        }
      },
      null,
      (status) {
        exportingProgress.value =
            config.getFFmpegProgress(status.getTime().toInt());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: editorController!.initialized
              ? Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.arrow_back),
                          ),
                          const CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.blueGrey,
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    CropGridViewer.preview(controller: editorController!),
                    const Spacer(),
                    MyTrimSlider(
                      controller: editorController!,
                      height: 40,
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 6.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(18),
                            ),
                          ),
                          child: TextButton(
                            onPressed: exportVideo,
                            child: const Text("Done"),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : const SizedBox(),
        ),
      ),
    );
  }
}
