import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/constants.dart';
import 'package:tiktok_clone/models/user.dart' as model;
import 'package:image_picker/image_picker.dart';
import 'package:tiktok_clone/views/screens/auth/login_screen.dart';
import 'package:tiktok_clone/views/screens/auth/signup_screen.dart';
import 'package:tiktok_clone/views/screens/home_screen.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  late Rx<File> _pickedImage;
  late Rx<User?> _user;

  User? get user => _user.value;
  File get profilePhoto => _pickedImage.value;
  Future<String> _uploadToStrorage(File image) async {
    Reference ref = firebaseStorage
        .ref()
        .child('profilePics')
        .child(firebaseAuth.currentUser!.uid);
    UploadTask uploadTask = ref.putFile(image);
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  @override
  void onReady() {
    //current user
    _user = Rx(firebaseAuth.currentUser);
    //listen the change of  user and assign to _user variable
    _user.bindStream(firebaseAuth.authStateChanges());
    //worker ever will be triggered any time the _user variable change
    ever(_user, _setInitialScreen);

    // TODO: implement onReady
    super.onReady();
  }

  _setInitialScreen(User? user) {
    print('user:$user');
    if (user == null) {
      Get.offAll(() => LoginScreen());
    } else {
      Get.offAll(() => const HomeScreen());
    }
  }

  //registering the user
  void registerUser(
      String username, String password, String email, File? image) async {
    try {
      if (username.isNotEmpty &&
          email.isNotEmpty &&
          password.isNotEmpty &&
          image != null) {
        //save out user to authentication and firebase firestore
        UserCredential cred = await firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        String downloadUrl = await _uploadToStrorage(image);

        model.User user = model.User(
          email: email,
          name: username,
          uid: cred.user!.uid,
          profilePhoto: downloadUrl,
        );
        await firestore
            .collection('users')
            .doc(cred.user!.uid)
            .set(user.toJson());

        Get.snackbar(
          'Login success',
          'You just have login tiktok app.',
        );
      } else {
        Get.snackbar(
          'Error Creating Account',
          'Please fill all the fields',
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error Creating Account',
        e.toString(),
      );
    }
  }

  //pick image
  void pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      Get.snackbar('Profile Picture',
          'You have successfully selected your profile picture!');
    }
    _pickedImage = Rx(File(pickedImage!.path));
  }

  //login user
  void loginUser(String email, String password) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        Get.snackbar(
          'Login success',
          'You just have login tiktok app.',
        );
      } else {
        Get.snackbar(
          'Error Login Account',
          'Please fill all the fields',
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error login Account',
        e.toString(),
      );
    }
  }

  //sign out
  void signOut() async {
    await firebaseAuth.signOut();
    Get.snackbar(
      'Logout success',
      'You just have Logout tiktok app.',
    );
  }
}
