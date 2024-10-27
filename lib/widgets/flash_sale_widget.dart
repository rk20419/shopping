import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_card/image_card.dart';
import 'package:shopping_app/models/product_model.dart';
import 'package:shopping_app/screens/user_panel/product_details_screen.dart';
import 'package:shopping_app/utils/app_utils.dart';

class FlashSaleWidget extends StatelessWidget {
  const FlashSaleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection('products')
          .where('isSale', isEqualTo: true)
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
            child: Text("No products Found"),
          );
        }
        if (snapshot.data != null) {
          return SizedBox(
            height: Get.height / 4.5,
            child: ListView.builder(
                itemCount: snapshot.data!.docs.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
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
                          padding: const EdgeInsets.all(5.0),
                          child: FillImageCard(
                            color: Colors.white,
                            borderRadius: 20.0,
                            width: Get.width / 3.5,
                            heightImage: Get.height / 12,
                            imageProvider: CachedNetworkImageProvider(
                                // for only show first image of server image array
                                productModel.productImages[0]),
                            title: Center(
                              child: Text(
                                productModel.productName,
                                //if product name is long then its take first word and use .... for another word
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 12.0),
                              ),
                            ),
                            footer: Row(
                              //mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Rs ${productModel.salePrice}",
                                  style: const TextStyle(fontSize: 10),
                                ),
                                const SizedBox(
                                  width: 2.0,
                                ),
                                Text(
                                  productModel.fullPrice,
                                  style: const TextStyle(
                                      fontSize: 10,
                                      color: AppConstant.appSecondaryColor,
                                      decoration: TextDecoration.lineThrough),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
          );
        }
        return Container();
      },
    );
  }
}
