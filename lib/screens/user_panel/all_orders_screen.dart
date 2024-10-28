import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_app/controllers/cart_price_controller.dart';

import 'package:shopping_app/models/order_model.dart';
import 'package:shopping_app/utils/app_utils.dart';

class AllOrdersScreen extends StatefulWidget {
  const AllOrdersScreen({super.key});

  @override
  State<AllOrdersScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<AllOrdersScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  final ProductPriceController productPriceController =
      Get.put(ProductPriceController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.appMainColor,
        title: const Text("All Orders"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .doc(user!.uid)
            .collection('confirmOrders')
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
                final productData = snapshot.data!.docs[index];
                OrderModel orderModel = OrderModel(
                  productId: productData['productId'],
                  categoryId: productData['categoryId'],
                  productName: productData['productName'],
                  categoryName: productData['categoryName'],
                  salePrice: productData['salePrice'],
                  fullPrice: productData['fullPrice'],
                  productImages: productData['productImages'],
                  deliveryTime: productData['deliveryTime'],
                  isSale: productData['isSale'],
                  productDescription: productData['productDescription'],
                  createdAt: productData['createdAt'],
                  updatedAt: productData['updatedAt'],
                  productQuantity: productData['productQuantity'],
                  productTotalPrice:
                      double.parse(productData['productTotalPrice'].toString()),
                  customerId: productData['customerId'],
                  customerPhone: productData['customerPhone'],
                  customerName: productData['customerName'],
                  customerAddress: productData['customerAddress'],
                  customerDeviceToken: productData['customerDeviceToken'],
                  status: productData['status'],
                );

                //delete when swipe
                productPriceController.fetchProductPrice();
                return Card(
                  elevation: 5,
                  color: AppConstant.appTextColor,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppConstant.appMainColor,
                      backgroundImage:
                          NetworkImage(orderModel.productImages[0]),
                    ),
                    title: Text(orderModel.productName),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(orderModel.productTotalPrice.toString()),
                        const SizedBox(
                          width: 10.0,
                        ),
                        orderModel.status != true
                            ? const Text(
                                'Pending...',
                                style: TextStyle(color: Colors.green),
                              )
                            : const Text('Delivered',
                                style: TextStyle(color: Colors.red))
                      ],
                    ),
                    trailing: orderModel.status == true
                        ? ElevatedButton(
                            onPressed: () {}, child: const Text("Review"))
                        : const SizedBox.shrink(),
                  ),
                );
              },
            );
          }
          return Container();
        },
      ),
    );
  }
}
