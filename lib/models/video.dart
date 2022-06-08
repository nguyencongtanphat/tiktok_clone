import 'package:cloud_firestore/cloud_firestore.dart';

class Video {
  String userName;
  String uid;
  String id;
  List likes;
  int commentCount;
  int shareCount;
  String songName;
  String caption;
  String profilePhoto;
  String videoUrl;
  String thumbnail;

  Video({
    required this.userName,
    required this.uid,
    required this.id,
    required this.likes,
    required this.commentCount,
    required this.shareCount,
    required this.songName,
    required this.caption,
    required this.profilePhoto,
    required this.videoUrl,
    required this.thumbnail,
  });

  Map<String, dynamic> toJson() => {
        "user": userName,
        "uid": uid,
        "id": id,
        "likes": likes,
        "commentCount": commentCount,
        "shareCount": shareCount,
        "songName": songName,
        "caption": caption,
        "profilePhoto": profilePhoto,
        "videoUrl": videoUrl,
        "thumbnail": thumbnail,
      };

  static Video fromSnap(DocumentSnapshot snap) {
    var snapShot = snap.data() as Map<String, dynamic>;
    return Video(
      userName: snapShot['userName'],
      uid: snapShot['uid'],
      id: snapShot['id'],
      likes: snapShot['likes'],
      commentCount: snapShot['commentCount'],
      shareCount: snapShot['shareCount'],
      songName: snapShot['songName'],
      caption: snapShot['caption'],
      profilePhoto: snapShot['profilePhoto'],
      videoUrl: snapShot['videoUrl'],
      thumbnail: snapShot['thumbnail'],
    );
  }
}
