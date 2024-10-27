import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shopping_app/controllers/getuserdata_controller.dart';
import 'package:shopping_app/controllers/signin_controller.dart';
import 'package:shopping_app/screens/admin_panel/admin_main_screen.dart';
import 'package:shopping_app/screens/auth_ui/forget_password_screen.dart';
import 'package:shopping_app/screens/user_panel/main_screen.dart';
import '../../utils/app_utils.dart';
import 'signup_screen.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final SignInConroller signInConroller = Get.put(SignInConroller());
  final GetuserdataController getuserdataController =
      Get.put(GetuserdataController());
  TextEditingController userEmail = TextEditingController();
  TextEditingController userPassword = TextEditingController();
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
        body: SingleChildScrollView(
          child: Column(
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
                    controller: userEmail,
                    decoration: InputDecoration(
                      hintText: "Email",
                      prefixIcon: const Icon(Icons.email_rounded),
                      contentPadding:
                          const EdgeInsets.only(top: 2.0, left: 8.0),
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
                    child: Obx(
                      () => TextFormField(
                        cursorColor: AppConstant.appSecondaryColor,
                        obscureText: signInConroller.isPasswordVisible.value,
                        keyboardType: TextInputType.visiblePassword,
                        controller: userPassword,
                        decoration: InputDecoration(
                          hintText: "password",
                          prefixIcon: const Icon(Icons.password_rounded),
                          suffixIcon: GestureDetector(
                              onTap: () {
                                signInConroller.isPasswordVisible.toggle();
                              },
                              child: signInConroller.isPasswordVisible.value
                                  ? const Icon(Icons.visibility_off_rounded)
                                  : const Icon(Icons.visibility)),
                          contentPadding:
                              const EdgeInsets.only(top: 2.0, left: 8.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    )),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10.0),
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    Get.to(() => const ForgetPasswordScreen());
                  },
                  child: const Text(
                    "Forget Password?",
                    style: TextStyle(
                        color: AppConstant.appSecondaryColor,
                        fontWeight: FontWeight.bold),
                  ),
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
                    onPressed: () async {
                      String email = userEmail.text.trim();
                      String password = userPassword.text.trim();

                      if (email.isEmpty || password.isEmpty) {
                        Get.snackbar("Error", "Please Enter all details");
                      } else {
                        UserCredential? userCredential =
                            await signInConroller.signInMethod(email, password);

                        var userData = await getuserdataController
                            .getUserData(userCredential!.user!.uid);
                        if (userCredential.user!.emailVerified) {
                          // if admin
                          if (userData[0]['isAdmin'] == true) {
                            Get.snackbar(
                              "Success",
                              "Admin login SuccessFull",
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: AppConstant.appSecondaryColor,
                              colorText: AppConstant.appTextColor,
                            );
                            Get.offAll(() => const AdminMainScreen());
                          } else {
                            Get.snackbar(
                              "Success",
                              "login SuccessFull",
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: AppConstant.appSecondaryColor,
                              colorText: AppConstant.appTextColor,
                            );
                            Get.offAll(() => const MainScreen());
                          }
                        } else {
                          Get.snackbar(
                            "Error",
                            "Please verify your email before login",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: AppConstant.appSecondaryColor,
                            colorText: AppConstant.appTextColor,
                          );
                        }
                      }
                    },
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
        ),
      );
    });
  }
}
