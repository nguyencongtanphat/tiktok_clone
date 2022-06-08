import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String name;
  String profilePhoto;
  String email;
  String uid;
  User({
    required this.email,
    required this.name,
    required this.profilePhoto,
    required this.uid,
  });

  Map<String, dynamic> toJson() => {
        "email": email,
        "name": name,
        "profilePhoto": profilePhoto,
        "uid": uid,
      };
  static User fromSnap(DocumentSnapshot snap) {
    var snapShot = snap.data() as Map<String, dynamic>;
    return User(
      email: snapShot['email'],
      name: snapShot['name'],
      profilePhoto: snapShot['profilePhoto'],
      uid: snapShot['uid'],
    );
  }
}
