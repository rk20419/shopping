import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:get/get.dart';
import 'package:shopping_app/controllers/cart_price_controller.dart';

import 'package:shopping_app/models/cart_models.dart';
import 'package:shopping_app/screens/user_panel/check_out_screen.dart';
import 'package:shopping_app/utils/app_utils.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  final ProductPriceController productPriceController =
      Get.put(ProductPriceController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.appMainColor,
        title: const Text("Cart Screen"),
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
                    productTotalPrice: cartData['productTotalPrice']);

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
                          SizedBox(
                            width: Get.width / 20.0,
                          ),
                          GestureDetector(
                            onTap: () async {
                              if (cartModel.productQuantity > 1) {
                                await FirebaseFirestore.instance
                                    .collection('cart')
                                    .doc(user!.uid)
                                    .collection('cartOrders')
                                    .doc(cartModel.productId)
                                    .update({
                                  'productQuantity':
                                      cartModel.productQuantity - 1,
                                  'productTotalPrice':
                                      (double.parse(cartModel.fullPrice) *
                                          (cartModel.productQuantity - 1))
                                });
                              }
                            },
                            child: const CircleAvatar(
                              radius: 14,
                              backgroundColor: AppConstant.appMainColor,
                              child: Text("-"),
                            ),
                          ),
                          SizedBox(
                            width: Get.width / 20.0,
                          ),
                          GestureDetector(
                            onTap: () async {
                              if (cartModel.productQuantity > 0) {
                                await FirebaseFirestore.instance
                                    .collection('cart')
                                    .doc(user!.uid)
                                    .collection('cartOrders')
                                    .doc(cartModel.productId)
                                    .update({
                                  'productQuantity':
                                      cartModel.productQuantity + 1,
                                  'productTotalPrice':
                                      double.parse(cartModel.fullPrice) +
                                          double.parse(cartModel.fullPrice) *
                                              (cartModel.productQuantity)
                                });
                              }
                            },
                            child: const CircleAvatar(
                              radius: 14,
                              backgroundColor: AppConstant.appMainColor,
                              child: Text("+"),
                            ),
                          )
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
                      "Check Out",
                      style: TextStyle(color: AppConstant.appTextColor),
                    ),
                    onPressed: () {
                      Get.to(() => const CheckOutScreen());
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
}
