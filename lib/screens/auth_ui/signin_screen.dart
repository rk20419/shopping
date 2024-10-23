import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../utils/app_utils.dart';
import 'signup_screen.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  @override
  Widget build(BuildContext context) {
    // keyboard visible or not it check
    return KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: AppConstant.appSecondaryColor,
          title: const Text(
            "Sign In",
            style: TextStyle(color: AppConstant.appTextColor),
          ),
        ),
        body: Column(
          children: [
            isKeyboardVisible
                ? const Text("Welcome To Shopping")
                : Column(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                            color: AppConstant.appSecondaryColor),
                        child: Lottie.asset('assets/images/splash1.json'),
                      ),
                    ],
                  ),
            SizedBox(
              height: Get.height / 20,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 5.0),
              width: Get.width,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  cursorColor: AppConstant.appSecondaryColor,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: "Email",
                    prefixIcon: const Icon(Icons.email_rounded),
                    contentPadding: const EdgeInsets.only(top: 2.0, left: 8.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 5.0),
              width: Get.width,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  cursorColor: AppConstant.appSecondaryColor,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    hintText: "password",
                    prefixIcon: const Icon(Icons.password_rounded),
                    suffixIcon: const Icon(Icons.visibility_off_rounded),
                    contentPadding: const EdgeInsets.only(top: 2.0, left: 8.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10.0),
              alignment: Alignment.centerRight,
              child: const Text(
                "Forget Password?",
                style: TextStyle(
                    color: AppConstant.appSecondaryColor,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: Get.height / 20,
            ),
            Material(
              child: Container(
                width: Get.width / 2,
                height: Get.height / 18,
                decoration: BoxDecoration(
                  color: AppConstant.appSecondaryColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    "SIGN IN",
                    style: TextStyle(color: AppConstant.appTextColor),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: Get.height / 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don't have an account ",
                  style: TextStyle(color: AppConstant.appSecondaryColor),
                ),
                GestureDetector(
                  onTap: () => Get.offAll(() => const SignupScreen()),
                  child: const Text(
                    " Sign Up",
                    style: TextStyle(
                        color: AppConstant.appSecondaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            )
          ],
        ),
      );
    });
  }
}
