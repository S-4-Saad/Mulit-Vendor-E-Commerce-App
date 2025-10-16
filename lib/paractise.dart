import 'package:flutter/material.dart';
import 'package:speezu/core/assets/app_images.dart';
import 'package:speezu/core/utils/media_querry_extention.dart';
import 'package:speezu/widgets/carousel_slider_widget.dart';
import 'package:speezu/widgets/category_box_widget.dart';
import 'package:speezu/widgets/image_type_extention.dart';
import 'package:speezu/widgets/rating_display_widget.dart';
import 'package:speezu/widgets/search_result_shimmar.dart';
import 'package:speezu/widgets/shop_box_widget.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Notification Screen',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}


class PractiseScreen extends StatefulWidget {

  PractiseScreen({super.key});

  @override
  State<PractiseScreen> createState() => _PractiseScreenState();
}

class _PractiseScreenState extends State<PractiseScreen> {

  List<String> imageUrl = [
    'https://t3.ftcdn.net/jpg/04/65/46/52/360_F_465465254_1pN9MGrA831idD6zIBL7q8r`1zxc nZZpUCQTy.jpg',
    "https://static.vecteezy.com/system/resources/thumbnails/002/006/774/small/paper-art-shopping-online-on-smartphone-and-new-buy-sale-promotion-backgroud-for-banner-market-ecommerce-free-vector.jpg",
    "https://static.vecteezy.com/system/resources/thumbnails/004/299/835/small/online-shopping-on-phone-buy-sell-business-digital-web-banner-application-money-advertising-payment-ecommerce-illustration-search-free-vector.jpg",
  ];

  final List<ProductCategory> dummyCategories = [
    ProductCategory(name: "Food", imageUrl: AppImages.foodStoreIcon),
    ProductCategory(name: "Supermarket", imageUrl: AppImages.superMarketIcon),
    ProductCategory(
      name: "Retail Stores",
      imageUrl: AppImages.utilityStoreIcon,
    ),
    ProductCategory(name: "Pharmacy", imageUrl: AppImages.pharmacyIcon),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: () {
            print('tapped');
          },
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children:
                        dummyCategories.map((category) {
                          return CategoryBoxWidget(
                            title: category.name,
                            imageUrl: category.imageUrl,
                            onTap: () {
                              print('Tapped on ${category.name}');
                            },
                          );
                        }).toList(),
                  ),
                ),
                SizedBox(height: context.heightPct(.02)),
                SearchResultShimmar(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProductCategory {
  final String name;
  final String imageUrl;

  ProductCategory({required this.name, required this.imageUrl});
}




class ShopMapScreen extends StatelessWidget {
  const ShopMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Shop Map Screen',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}

class ShopProductScreen extends StatelessWidget {
  const ShopProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Shop Products Screen',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}


// Dummy data
