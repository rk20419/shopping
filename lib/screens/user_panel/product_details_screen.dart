// ignore: must_be_immutable
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:shopping_app/controllers/rating_controller.dart';
import 'package:shopping_app/models/review_model.dart';
import 'package:shopping_app/screens/user_panel/cart_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/cart_models.dart';
import '../../models/product_model.dart';
import '../../utils/app_utils.dart';

// ignore: must_be_immutable
class ProductDetailsScreen extends StatefulWidget {
  ProductModel productModel;
  ProductDetailsScreen({super.key, required this.productModel});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    CalculateProductRatingController calculateProductRatingController = Get.put(
        CalculateProductRatingController(widget.productModel.productId));
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppConstant.appTextColor),
        backgroundColor: AppConstant.appMainColor,
        title: const Text("Product Details"),
        actions: [
          GestureDetector(
            onTap: () => Get.to(() => const CartScreen()),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.shopping_cart),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: Get.height / 60,
          ),
          CarouselSlider(
            items: widget.productModel.productImages
                .map((imageUrls) => ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl: imageUrls,
                        fit: BoxFit.cover,
                        width: Get.width - 10,
                        placeholder: (context, url) => const ColoredBox(
                          color: Colors.white,
                          child: CupertinoActivityIndicator(),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ))
                .toList(),
            options: CarouselOptions(
                scrollDirection: Axis.horizontal,
                autoPlay: true,
                aspectRatio: 2.5,
                viewportFraction: 1),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Card(
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.productModel.productName,
                          ),
                          const Icon(Icons.favorite_outline)
                        ],
                      ),
                    ),
                  ),
                  //review
                  Row(
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        child: RatingBar.builder(
                          glow: false,
                          ignoreGestures: true,
                          initialRating: double.parse(
                              calculateProductRatingController.averageRating
                                  .toString()),
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemSize: 25,
                          itemPadding:
                              const EdgeInsets.symmetric(horizontal: 2.0),
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          // ignore: avoid_types_as_parameter_names
                          onRatingUpdate: (value) {},
                        ),
                      ),
                      Text(calculateProductRatingController.averageRating
                          .toString()),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          widget.productModel.isSale == true &&
                                  widget.productModel.salePrice != ''
                              ? Text(
                                  "Price:${widget.productModel.salePrice}",
                                )
                              : Text(
                                  "Price:${widget.productModel.fullPrice}",
                                ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Category: ${widget.productModel.categoryName}",
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.productModel.productDescription,
                      ),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // For whatsapp
                          Material(
                            child: Container(
                              width: Get.width / 3.0,
                              height: Get.height / 16,
                              decoration: BoxDecoration(
                                color: AppConstant.appSecondaryColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: TextButton(
                                child: const Text(
                                  "WhatsApp",
                                  style: TextStyle(
                                      color: AppConstant.appTextColor),
                                ),
                                onPressed: () {
                                  sendMessageOnWhatsApp(
                                      productModel: widget.productModel);

                                  //Get.to(() => const SigninScreen());
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            width: Get.width / 5.0,
                          ),

                          // Add Product to whatsapp
                          Material(
                            child: Container(
                              width: Get.width / 3.0,
                              height: Get.height / 16,
                              decoration: BoxDecoration(
                                color: AppConstant.appSecondaryColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: TextButton(
                                child: const Text(
                                  "Add to Cart",
                                  style: TextStyle(
                                      color: AppConstant.appTextColor),
                                ),
                                onPressed: () async {
                                  //Get.to(() => const SigninScreen());
                                  await checkProductExistence(uId: user!.uid);
                                },
                              ),
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            ),
          ),

          // for Review Show
          FutureBuilder(
            future: FirebaseFirestore.instance
                .collection('products')
                .doc(widget.productModel.productId)
                .collection('review')
                .get(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                  child: Text("No review Found"),
                );
              }
              if (snapshot.data != null) {
                return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var data = snapshot.data!.docs[index];
                      ReviewModel reviewModel = ReviewModel(
                        customerName: data['customerName'],
                        customerPhone: data['customerPhone'],
                        customerDeviceToken: data['customerDeviceToken'],
                        customerId: data['customerId'],
                        feedback: data['feedback'],
                        rating: data['rating'],
                        createdAt: data['createdAt'],
                      );
                      return Card(
                        elevation: 5,
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text(reviewModel.customerName[0]),
                          ),
                          title: Text(reviewModel.customerName),
                          subtitle: Text(reviewModel.feedback),
                          trailing: Text(reviewModel.rating),
                        ),
                      );
                    });
              }
              return Container();
            },
          ),
        ],
      ),
    );
  }

  // Whatsapp
  static Future<void> sendMessageOnWhatsApp({
    required ProductModel productModel,
  }) async {
    const number = "++917290908661";
    final message =
        "Hello Techi4u \n i want to know about this product \n ${productModel.productName} \n ${productModel.productId}";

    final url = 'https://wa.me/$number?text=${Uri.encodeComponent(message)}';

    // ignore: deprecated_member_use
    if (await canLaunch(url)) {
      // ignore: deprecated_member_use
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  // check product exist or not
  Future<void> checkProductExistence({
    required String uId,
    int quantityIncrement = 1,
  }) async {
    final DocumentReference documentReference = FirebaseFirestore.instance
        .collection('cart')
        .doc(uId)
        .collection('cartOrders')
        .doc(widget.productModel.productId.toString());

    DocumentSnapshot snapshot = await documentReference.get();

    if (snapshot.exists) {
      //if product exists increase Product Quantuty and price
      int currentQuantity = snapshot['productQuantity'];
      int updatedQuantity = currentQuantity + quantityIncrement;
      double totalPrice = double.parse(widget.productModel.isSale
              ? widget.productModel.salePrice
              : widget.productModel.fullPrice) *
          updatedQuantity;

      await documentReference.update({
        'productQuantity': updatedQuantity,
        'productTotalPrice': totalPrice
      });

      log('product product exists');
    } else {
      //Add Product in cart and add price
      await FirebaseFirestore.instance.collection('cart').doc(uId).set(
        {
          'uId': uId,
          'createdAt': DateTime.now(),
        },
      );

      CartModel cartModel = CartModel(
          productId: widget.productModel.productId,
          categoryId: widget.productModel.categoryId,
          productName: widget.productModel.productName,
          categoryName: widget.productModel.categoryName,
          salePrice: widget.productModel.salePrice,
          fullPrice: widget.productModel.fullPrice,
          productImages: widget.productModel.productImages,
          deliveryTime: widget.productModel.deliveryTime,
          isSale: widget.productModel.isSale,
          productDescription: widget.productModel.productDescription,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          productQuantity: 1,
          productTotalPrice: double.parse(widget.productModel.isSale
              ? widget.productModel.salePrice
              : widget.productModel.fullPrice));

      await documentReference.set(cartModel.toMap());

      log('product added');
    }
  }
}
