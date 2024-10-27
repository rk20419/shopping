import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shopping_app/screens/auth_ui/signin_screen.dart';

import '../../controllers/google_signin_controller.dart';
import '../../utils/app_utils.dart';

class WelcomeScreen extends StatelessWidget {
  WelcomeScreen({super.key});

  //initialize Google controller
  final GoogleSignInController _googleSignInController =
      Get.put(GoogleSignInController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //elevation use for hide appbar border
        elevation: 0,
        backgroundColor: AppConstant.appSecondaryColor,
        centerTitle: true,
        title: const Text(
          "Welcome to Shopping App",
          style: TextStyle(color: AppConstant.appTextColor),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            decoration:
                const BoxDecoration(color: AppConstant.appSecondaryColor),
            child: Lottie.asset(
              'assets/images/splash1.json',
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20.0),
            child: const Text(
              "Happy Shopping ",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: Get.height / 12,
          ),
          Material(
            child: Container(
              width: Get.width / 1.2,
              height: Get.height / 15,
              decoration: BoxDecoration(
                color: AppConstant.appSecondaryColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextButton.icon(
                onPressed: () {
                  _googleSignInController.signInWithGoogle();
                },
                icon: Image.asset(
                  'assets/images/google.png',
                  width: Get.width / 12,
                  height: Get.height / 12,
                ),
                label: const Text("Sign in with google"),
              ),
            ),
          ),
          SizedBox(
            height: Get.height / 40,
          ),
          Material(
            child: Container(
              width: Get.width / 1.2,
              height: Get.height / 15,
              decoration: BoxDecoration(
                color: AppConstant.appSecondaryColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextButton.icon(
                icon: const Icon(
                  Icons.email_rounded,
                  color: AppConstant.appTextColor,
                ),
                label: const Text("Sign in with email"),
                onPressed: () {
                  Get.to(() => const SigninScreen());
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
