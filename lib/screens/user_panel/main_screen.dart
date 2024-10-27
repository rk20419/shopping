import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_app/screens/user_panel/all_categories_screen.dart';
import 'package:shopping_app/screens/user_panel/all_product_screen.dart';
import 'package:shopping_app/screens/user_panel/cart_screen.dart';
import 'package:shopping_app/widgets/all_product_widget.dart';
import 'package:shopping_app/widgets/banner_widget.dart';
import 'package:shopping_app/widgets/categories_widget.dart';
import 'package:shopping_app/widgets/drawer_widget.dart';
import 'package:shopping_app/widgets/flash_sale_widget.dart';
import 'package:shopping_app/widgets/heading_widget%20.dart';
import '../../utils/app_utils.dart';
import 'all_flash_sale_products.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppConstant.appTextColor),
        backgroundColor: AppConstant.appMainColor,
        title: Text(
          AppConstant.appMainName,
          style: const TextStyle(color: AppConstant.appTextColor),
        ),
        actions: [
          GestureDetector(
            onTap: () => Get.to(() => const CartScreen()),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.shopping_cart),
            ),
          )
        ],
        centerTitle: true,
      ),
      //for access drawer widget
      drawer: const DrawerWidget(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(
              height: Get.height / 90,
            ),

            //banner widget
            const BannerWidget(),

            //sub categories
            HeadingWidget(
              headingTitle: "Categories",
              headingSubTitle: "According to your Budget",
              onTap: () => Get.to(() => const AllCategoriesScreen()),
              buttonText: "See More >",
            ),

            //categories
            const CategoriesWidget(),

            HeadingWidget(
              headingTitle: "Flash Sale",
              headingSubTitle: "According to your Budget",
              onTap: () => Get.to(() => const AllFlashSaleProducts()),
              buttonText: "See More >",
            ),

            //flash sale
            const FlashSaleWidget(),

            //All Product
            HeadingWidget(
              headingTitle: "All Products",
              headingSubTitle: "According to your Budget",
              onTap: () => Get.to(() => const AllProductScreen()),
              buttonText: "See More >",
            ),
            //AllProduct
            const AllProductWidget()
          ],
        ),
      ),
    );
  }
}
