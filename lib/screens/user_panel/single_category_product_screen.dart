import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_card/image_card.dart';
import 'package:shopping_app/models/product_model.dart';
import 'package:shopping_app/utils/app_utils.dart';

import 'product_details_screen.dart';

// ignore: must_be_immutable
class SingleCategoryProductScreen extends StatefulWidget {
  String categoryId;
  SingleCategoryProductScreen({super.key, required this.categoryId});

  @override
  State<SingleCategoryProductScreen> createState() =>
      _SingleCategoryProductScreen();
}

class _SingleCategoryProductScreen extends State<SingleCategoryProductScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.appMainColor,
        title: const Text("Products"),
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('products')
            .where('categoryId', isEqualTo: widget.categoryId)
            .get(),
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
              child: Text("No Categories Found"),
            );
          }
          if (snapshot.data != null) {
            return GridView.builder(
                itemCount: snapshot.data!.docs.length,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 3,
                  crossAxisSpacing: 3,
                  childAspectRatio: 1.19,
                ),
                itemBuilder: (context, index) {
                  final productData = snapshot.data!.docs[index];
                  ProductModel productModel = ProductModel(
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
                      updatedAt: productData['updatedAt']);
                  // CategoriesModel categoriesModel = CategoriesModel(
                  //     categoryId: snapshot.data!.docs[index]['categoryId'],
                  //     categoryImg: snapshot.data!.docs[index]['categoryImg'],
                  //     categoryName: snapshot.data!.docs[index]['categoryName'],
                  //     createdAt: snapshot.data!.docs[index]['createdAt'],
                  //     updatedAt: snapshot.data!.docs[index]['updatedAt']);
                  return Row(
                    children: [
                      GestureDetector(
                        onTap: () => Get.to(() =>
                            ProductDetailsScreen(productModel: productModel)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FillImageCard(
                            color: Colors.white,
                            borderRadius: 20.0,
                            width: Get.width / 2.3,
                            heightImage: Get.height / 10,
                            imageProvider: CachedNetworkImageProvider(
                                productModel.productImages[0]),
                            title: Center(
                                child: Text(
                              productModel.productName,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 12.0),
                            )),
                          ),
                        ),
                      )
                    ],
                  );
                });

            // SizedBox(
            //   height: Get.height / 5.5,
            //   child: ListView.builder(
            //       itemCount: snapshot.data!.docs.length,
            //       shrinkWrap: true,
            //       scrollDirection: Axis.horizontal,
            //       ),
            // );
          }
          return Container();
        },
      ),
    );
  }
}
