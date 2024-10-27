import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shopping_app/controllers/devicetoken_controller.dart';
import 'package:shopping_app/models/user_model.dart';

import '../screens/user_panel/main_screen.dart';

class GoogleSignInController extends GetxController {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signInWithGoogle() async {
    final DevicetokenController devicetokenController =
        Get.put(DevicetokenController());
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        //its loading start and builder used in main page
        EasyLoading.show(status: "Please Wait...");

        //Google Authentication
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        //for credential
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        //for  user credential
        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);

        // store user credentials in fire store
        final User? user = userCredential.user;
        if (user != null) {
          UserModel userModel = UserModel(
              uId: user.uid,
              username: user.displayName.toString(),
              email: user.email.toString(),
              phone: user.phoneNumber.toString(),
              userImg: user.photoURL.toString(),
              userDeviceToken: devicetokenController.deviceToken.toString(),
              country: '',
              userAddress: '',
              street: '',
              isAdmin: false,
              isActive: true,
              createdOn: DateTime.now(),
              city: '');
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set(userModel.toMap());

          //Easy Loading end here
          EasyLoading.dismiss();

          // move to main screen
          Get.offAll(() => const MainScreen());
        }
      }
    } catch (e) {
      // if we get any error then Loading dismis here
      EasyLoading.dismiss();
      log('error $e');
    }
  }
}
