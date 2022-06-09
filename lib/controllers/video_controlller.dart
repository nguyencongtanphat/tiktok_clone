import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/constants.dart';
import 'package:tiktok_clone/models/video.dart';

class VideoController extends GetxController {
  // Rx<List<Video>> _videos = Rx<List<Video>>([]);

  // Rx<List<Video>> get videos => _videos;
  // @override
  // void onInit() async {
  //   _videos.bindStream(
  //     firestore.collection("videos").snapshots().map(
  //       (QuerySnapshot query) {
  //         print('here');
  //         print('query:${query.docs}');
  //         List<Video> retValue = [];
  //         for (var element in query.docs) {
  //           retValue.add(Video.fromSnap(element));
  //         }

  //         return retValue;
  //       },
  //     ),
  //   );

  //   // TODO: implement onInit
  //   super.onInit();
  // }

  final Rx<List<Video>> _videoList = Rx<List<Video>>([]);

  List<Video> get videoList => _videoList.value;

  @override
  void onInit() {
    super.onInit();
    _videoList.bindStream(
        firestore.collection('videos').snapshots().map((QuerySnapshot query) {
      List<Video> retVal = [];
      for (var element in query.docs) {
        print("ele:${element.data()}");
        retVal.add(
          Video.fromSnap(element),
        );
      }
      return retVal;
    }));
  }

  likeVideo(String id) async {
    DocumentSnapshot doc = await firestore.collection('videos').doc(id).get();
    var uid = authController.user!.uid;
    if ((doc.data()! as dynamic)['likes'].contains(uid)) {
      await firestore.collection('videos').doc(id).update({
        'likes': FieldValue.arrayRemove([uid]),
      });
    } else {
      await firestore.collection('videos').doc(id).update({
        'likes': FieldValue.arrayUnion([uid]),
      });
    }
  }
}
