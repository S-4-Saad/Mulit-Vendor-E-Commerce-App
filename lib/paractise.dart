import 'package:flutter/material.dart';
import 'package:speezu/core/assets/app_images.dart';
import 'package:speezu/core/assets/font_family.dart';
import 'package:speezu/core/utils/media_querry_extention.dart';
import 'package:speezu/widgets/app_cache_image.dart';
import 'package:speezu/widgets/carousel_slider_widget.dart';
import 'package:speezu/widgets/category_box_widget.dart';
import 'package:speezu/widgets/image_type_extention.dart';
import 'package:speezu/widgets/product_box_widget.dart';
import 'package:speezu/widgets/rating_display_widget.dart';
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

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'MapScreen Screen',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'MapScreen Screen',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}

class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'MapScreen Screen',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}

class PractiseScreen extends StatelessWidget {
  final List<ShopModel> dummyShops = [
    ShopModel(
      imageUrl:
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSGUr0VYvQolmz3IkAsjFKavNsPcmmof6eWJg&s",
      shopName: "Fresh Mart",
      shopDescription: "Groceries & daily needs",
      shopRating: 4.5,
      isOpen: true,
      isDelivering: true,
    ),
    ShopModel(
      imageUrl: "https://picsum.photos/270/130?random=2",
      shopName: "Pizza Palace",
      shopDescription: "Italian & Fast Food",
      shopRating: 4.2,
      isOpen: false,
      isDelivering: false,
    ),
    ShopModel(
      imageUrl: "https://picsum.photos/270/130?random=3",
      shopName: "Cafe Aroma",
      shopDescription: "Coffee & Snacks",
      shopRating: 4.8,
      isOpen: true,
      isDelivering: false,
    ),
  ];
  List<String> imageUrl = [
    'https://t3.ftcdn.net/jpg/04/65/46/52/360_F_465465254_1pN9MGrA831idD6zIBL7q8r`1zxc nZZpUCQTy.jpg',
    "https://static.vecteezy.com/system/resources/thumbnails/002/006/774/small/paper-art-shopping-online-on-smartphone-and-new-buy-sale-promotion-backgroud-for-banner-market-ecommerce-free-vector.jpg",
    "https://static.vecteezy.com/system/resources/thumbnails/004/299/835/small/online-shopping-on-phone-buy-sell-business-digital-web-banner-application-money-advertising-payment-ecommerce-illustration-search-free-vector.jpg",
  ];
  PractiseScreen({super.key});
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
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children:
                        dummyShops.map((shop) {
                          return ShopBox(
                            imageUrl: shop.imageUrl,
                            shopName: shop.shopName,
                            shopDescription: shop.shopDescription,
                            shopRating: shop.shopRating,
                            isOpen: shop.isOpen,
                            isDelivering: shop.isDelivering,
                            onShopBoxTap: () {
                              print('Tapped on ${shop.shopName}');
                            },
                            onDirectionTap: () {
                              print('Direction to ${shop.shopName}');
                            },
                          );
                        }).toList(),
                  ),
                ),
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

class DummyProductModel {
  final String id;
  final String productTitle;
  final double productPrice; // discounted price or final price
  final double productOriginalPrice; // actual/original price
  final String productImageUrl;
  final double productRating;
  final String? productCategory;
  final bool isProductFavourite;

  DummyProductModel({
    required this.id,
    required this.productTitle,
    required this.productPrice,
    required this.productOriginalPrice,
    required this.productImageUrl,
    this.productRating = 0.0,
    this.productCategory,
    this.isProductFavourite = false,
  });
}

class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Store Screen',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
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

class ShopModel {
  final String imageUrl;
  final String shopName;
  final String shopDescription;
  final double shopRating;
  final bool isOpen;
  final bool isDelivering;

  ShopModel({
    required this.imageUrl,
    required this.shopName,
    required this.shopDescription,
    required this.shopRating,
    required this.isOpen,
    required this.isDelivering,
  });
}

// Dummy data
