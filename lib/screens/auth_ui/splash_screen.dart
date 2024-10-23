import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../utils/app_utils.dart';
import 'welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(const Duration(seconds: 3), () {
      Get.offAll(() => const WelcomeScreen());
    });

    super.initState();
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
