import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/controllers/upload_video_controller.dart';
import 'package:tiktok_clone/views/widgets/text_input_field.dart';
import 'package:video_player/video_player.dart';

class ConfirmSceen extends StatefulWidget {
  const ConfirmSceen(
      {Key? key, required this.videoFile, required this.videoPath})
      : super(key: key);
  final File videoFile;
  final String videoPath;

  @override
  State<ConfirmSceen> createState() => _ConfirmSceenState();
}

class _ConfirmSceenState extends State<ConfirmSceen> {
  late VideoPlayerController controller;
  TextEditingController songController = TextEditingController();
  TextEditingController captionController = TextEditingController();

  UploadVideoController _uploadVideoController =
      Get.put(UploadVideoController());

  @override
  void initState() {
    //TODO: implement initState
    super.initState();
    setState(() {
      controller = VideoPlayerController.file(widget.videoFile);
    });
    controller.initialize();
    controller.play();
    controller.setVolume(1);
    controller.setLooping(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 1.5,
              child: VideoPlayer(controller),
            ),
            const SizedBox(
              height: 30,
            ),
            Column(
              children: [
                //song name input
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  width: MediaQuery.of(context).size.width - 20,
                  child: TextInputField(
                    controller: songController,
                    labelText: 'Song Name',
                    icon: Icons.music_note,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                //caption name input
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  width: MediaQuery.of(context).size.width - 20,
                  child: TextInputField(
                    controller: captionController,
                    labelText: 'Caption Name',
                    icon: Icons.music_note,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                //confirm button
                ElevatedButton(
                  onPressed: () {
                    _uploadVideoController.uploadVideo(
                      songController.text,
                      captionController.text,
                      widget.videoPath,
                    );
                  },
                  child: const Text(
                    'Share!',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
    //   body: Container(
    //     width: MediaQuery.of(context).size.width,
    //     height: MediaQuery.of(context).size.height,
    //     child: Column(
    //       children: [
    //         //caption name input
    //         Container(
    //           width: MediaQuery.of(context).size.width,
    //           margin: const EdgeInsets.symmetric(horizontal: 20),
    //           child: TextInputField(
    //             controller: captionController,
    //             labelText: 'Caption Name',
    //             icon: Icons.music_note,
    //           ),
    //         ),

    //       ],
    //     ),
    //   ),
    // );
  }
}
