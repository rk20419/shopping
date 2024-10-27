import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shopping_app/controllers/getuserdata_controller.dart';
import 'package:shopping_app/screens/admin_panel/admin_main_screen.dart';
import 'package:shopping_app/screens/user_panel/main_screen.dart';
import '../../utils/app_utils.dart';
import 'welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  //if user if login then state
  User? user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    Timer(const Duration(seconds: 3), () {
      loggedin(context);
    });

    super.initState();
  }

  //if user if login then state
  Future<void> loggedin(BuildContext context) async {
    if (user != null) {
      final GetuserdataController getuserdataController =
          Get.put(GetuserdataController());
      var userData = await getuserdataController.getUserData(user!.uid);
      if (userData[0]['isAdmin'] == true) {
        Get.offAll(() => const AdminMainScreen());
      } else {
        Get.offAll(() => const MainScreen());
      }
    } else {
      Get.to(() => WelcomeScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    //final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppConstant.appSecondaryColor,
      appBar: AppBar(
        backgroundColor: AppConstant.appSecondaryColor,
        //hideAppbar
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              //Get use for Getx Here for width u can also use media query
              width: Get.width,
              alignment: Alignment.center,
              child: Lottie.asset(
                'assets/images/splash1.json',
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 20.0),
            //Get use for Getx Here for width u can also use media query
            width: Get.width,
            alignment: Alignment.center,
            child: Text(
              AppConstant.appPoweredBy,
              style: const TextStyle(
                  color: AppConstant.appTextColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}
