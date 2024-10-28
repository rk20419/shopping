import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:get/get.dart';
import 'package:shopping_app/controllers/cart_price_controller.dart';
import 'package:shopping_app/controllers/get_customer_device_token.dart';

import 'package:shopping_app/models/cart_models.dart';
import 'package:shopping_app/utils/app_utils.dart';

import '../../services/place_order_services.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({super.key});

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  final ProductPriceController productPriceController =
      Get.put(ProductPriceController());

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.appMainColor,
        title: const Text("Check Out Screen"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('cart')
            .doc(user!.uid)
            .collection('cartOrders')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("Error"),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox(
              height: Get.height / 5,
              child: const Center(
                child: CupertinoActivityIndicator(),
              ),
            );
          }
          if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("No products Found"),
            );
          }
          if (snapshot.data != null) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final cartData = snapshot.data!.docs[index];
                CartModel cartModel = CartModel(
                  productId: cartData['productId'],
                  categoryId: cartData['categoryId'],
                  productName: cartData['productName'],
                  categoryName: cartData['categoryName'],
                  salePrice: cartData['salePrice'],
                  fullPrice: cartData['fullPrice'],
                  productImages: cartData['productImages'],
                  deliveryTime: cartData['deliveryTime'],
                  isSale: cartData['isSale'],
                  productDescription: cartData['productDescription'],
                  createdAt: cartData['createdAt'],
                  updatedAt: cartData['updatedAt'],
                  productQuantity: cartData['productQuantity'],
                  productTotalPrice:
                      double.parse(cartData['productTotalPrice'].toString()),
                );

                //delete when swipe
                productPriceController.fetchProductPrice();
                return SwipeActionCell(
                  key: ObjectKey(cartModel.productId),
                  trailingActions: [
                    SwipeAction(
                      title: 'delete',
                      forceAlignmentToBoundary: true,
                      performsFirstActionWithFullSwipe: true,
                      onTap: (CompletionHandler handler) async {
                        await FirebaseFirestore.instance
                            .collection('cart')
                            .doc(user!.uid)
                            .collection('cartOrders')
                            .doc(cartModel.productId)
                            .delete();
                        log('deleted');
                      },
                    )
                  ],
                  // show item in cart
                  child: Card(
                    elevation: 5,
                    color: AppConstant.appTextColor,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppConstant.appMainColor,
                        backgroundImage:
                            NetworkImage(cartModel.productImages[0]),
                      ),
                      title: Text(cartModel.productName),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(cartModel.productTotalPrice.toString()),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return Container();
        },
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(bottom: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //For Real Time Update
            Obx(
              () => Text(
                "Total Price : ${productPriceController.totalPrice.value.toStringAsFixed(1)}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
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
                      "Confirm Order",
                      style: TextStyle(color: AppConstant.appTextColor),
                    ),
                    onPressed: () {
                      showCustomBottomSheet();
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showCustomBottomSheet() {
    Get.bottomSheet(
      Container(
        height: Get.height * 0.8,
        decoration: const BoxDecoration(
          color: AppConstant.appTextColor,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(16),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 20.0),
                child: SizedBox(
                  height: 55,
                  child: TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                      hintStyle: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 20.0),
                child: SizedBox(
                  height: 55,
                  child: TextFormField(
                    controller: phoneController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Phone',
                      contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                      hintStyle: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 20.0),
                child: SizedBox(
                  height: 55,
                  child: TextFormField(
                    controller: addressController,
                    decoration: const InputDecoration(
                      labelText: 'Address',
                      contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                      hintStyle: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstant.appMainColor,
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10)),
                onPressed: () async {
                  if (nameController.text != '' &&
                      phoneController.text != '' &&
                      addressController.text != '') {
                    String name = nameController.text.trim();
                    String phone = phoneController.text.trim();
                    String address = addressController.text.trim();
                    String customerToken = await getCustomerDeviceToken();

                    //for placing order
                    placeOrder(
                      // ignore: use_build_context_synchronously
                      context: context,
                      customerName: name,
                      customerPhone: phone,
                      customerAddress: address,
                      customerDeviceToken: customerToken,
                    );
                  } else {
                    log('Please Fill All Details');
                  }
                },
                child: const Text(
                  "Place Order",
                  style: TextStyle(color: AppConstant.appTextColor),
                ),
              )
            ],
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
      elevation: 6,
    );
  }
}
