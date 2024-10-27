import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_app/utils/app_utils.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.appMainColor,
        title: const Text("Cart Screen"),
      ),
      body: Container(
        child: ListView.builder(
          itemCount: 20,
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return Card(
              elevation: 5,
              color: AppConstant.appTextColor,
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: AppConstant.appMainColor,
                  child: Text("Me"),
                ),
                title: const Text("New Dress For you"),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text("2200"),
                    SizedBox(
                      width: Get.width / 20.0,
                    ),
                    const CircleAvatar(
                      radius: 14,
                      backgroundColor: AppConstant.appMainColor,
                      child: Text("_"),
                    ),
                    SizedBox(
                      width: Get.width / 20.0,
                    ),
                    const CircleAvatar(
                      radius: 14,
                      backgroundColor: AppConstant.appMainColor,
                      child: Text("+"),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(bottom: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Total",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: Get.width / 40,
            ),
            const Text("Price: 1400"),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                child: Container(
                  width: Get.width / 2.0,
                  height: Get.height / 18,
                  decoration: BoxDecoration(
                    color: AppConstant.appSecondaryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextButton(
                    child: const Text(
                      "Check Out",
                      style: TextStyle(color: AppConstant.appTextColor),
                    ),
                    onPressed: () {},
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
