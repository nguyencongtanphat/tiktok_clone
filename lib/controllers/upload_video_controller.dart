import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/constants.dart';
import 'package:tiktok_clone/models/video.dart';
import 'dart:io';

import 'package:video_compress/video_compress.dart';

class UploadVideoController extends GetxController {
  _compressVideo(String videoPath) async {
    final compressedVideo = await VideoCompress.compressVideo(
      videoPath,
      quality: VideoQuality.MediumQuality,
    );
    return compressedVideo!.file;
  }

  Future<String> _uploadVideoToStorage(String id, String videoPath) async {
    //reference to address where to store video
    Reference ref = firebaseStorage.ref().child('videos').child(id);

    //upload file  to storage but need to compress video first( compress video to resize file
    // and make video compatible with all browser)

    UploadTask uploadTask = ref.putFile(await _compressVideo(videoPath));
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  _getThumbnail(String videoPath) async {
    final thumbnail = await VideoCompress.getFileThumbnail(videoPath);
    return thumbnail;
  }

  Future<String> _uploadImageToStorage(String id, String videoPath) async {
    Reference ref = firebaseStorage.ref().child('thumbnails').child(id);
    UploadTask uploadTask = ref.putFile(await _getThumbnail(videoPath));
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  // upload video
  uploadVideo(String songName, String caption, String videoPath) async {
    try {
      Get.defaultDialog(
        content: const CircularProgressIndicator(),
      );

      //get current user id
      String uid = firebaseAuth.currentUser!.uid;
      //get infomation of user by id in firebase
      DocumentSnapshot userDoc =
          await firestore.collection('users').doc(uid).get();
      // get id of video by the length of list video in firestore
      var allDocs = await firestore.collection('videos').get();
      //set len
      int len = allDocs.docs.length;

      //upload video to storage
      String videoUrl = await _uploadVideoToStorage("Video $len", videoPath);
      //upload thumbnail to firestore
      String thumbnail = await _uploadImageToStorage("Video $len", videoPath);

      //create video model
      Video video = Video(
        userName: (userDoc.data()! as Map<String, dynamic>)['name'],
        uid: uid,
        id: "Video $len",
        likes: [],
        commentCount: 0,
        shareCount: 0,
        songName: songName,
        caption: caption,
        videoUrl: videoUrl,
        profilePhoto: (userDoc.data()! as Map<String, dynamic>)['profilePhoto'],
        thumbnail: thumbnail,
      );

      //store video to firestore
      await firestore.collection('videos').doc('Video $len').set(
            video.toJson(),
          );
      Get.back();
      Get.back();
    } catch (e) {
      Get.snackbar(
        'Error Uploading Video',
        e.toString(),
      );
    }
  }
}
