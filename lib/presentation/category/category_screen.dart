import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:speezu/core/utils/media_querry_extention.dart';
import 'package:speezu/routes/route_names.dart';
import 'package:speezu/widgets/custom_app_bar.dart';
import 'package:speezu/widgets/search_animated_container.dart';
import 'package:speezu/widgets/sub_category_widget.dart';

import '../../core/assets/font_family.dart';
import '../../core/utils/labels.dart';
import '../../paractise.dart';
import '../../widgets/shop_box_widget.dart';

class CategoryScreen extends StatelessWidget {
  CategoryScreen({super.key});
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
  final List<ProductCategory> dummyFoodSubCategories = [
    ProductCategory(
      name: "Pizza",
      imageUrl:
      "https://upload.wikimedia.org/wikipedia/commons/d/d3/Supreme_pizza.jpg",
    ),
    ProductCategory(
      name: "Burgers",
      imageUrl:
      "https://upload.wikimedia.org/wikipedia/commons/0/0b/RedDot_Burger.jpg",
    ),
    ProductCategory(
      name: "Sandwiches",
      imageUrl:
      "https://www.laurafuentes.com/wp-content/uploads/2021/09/Salad-sandwich_post_01.jpg",
    ),
    ProductCategory(
      name: "Biryani",
      imageUrl:
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTP8l2kuZDANQExDsYteLg0NEUEjLkjudABRg&s",
    ),
    ProductCategory(
      name: "BBQ",
      imageUrl:
      "https://fnsharp.com/cdn/shop/articles/backyard-bbq-meat-grilling-guide-850x600_850x.jpg?v=1617738809",
    ),
    ProductCategory(
      name: "Desserts",
      imageUrl:
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTxdjsHGOKAWHPRU-DRZ4a_-V2vBe1wIbtYVA&s",
    ),
    ProductCategory(
      name: "Drinks",
      imageUrl:
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQm6lDF9LgCkiPN1GW7Nsb_i9tG4eZ21N_YQQ&s",
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Categories'),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 13.0, vertical: 8),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SearchContainer(onSearchTap: () {}),
              SizedBox(height: context.heightPct(0.01)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.store_mall_directory_outlined,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSecondary.withValues(alpha: .7),
                    ),
                    SizedBox(width: context.widthPct(0.02)),
                    Text(
                      Labels.topStores,
                      style: TextStyle(
                        fontSize: context.scaledFont(15),
                        fontFamily: FontFamily.fontsPoppinsSemiBold,
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: context.heightPct(0.01)),
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
                          Navigator.pushNamed(context, RouteNames.shopNavBarScreen);
                          },
                          onDirectionTap: () {
                            print('Direction to ${shop.shopName}');
                          },
                        );
                      }).toList(),
                ),
              ),
              SizedBox(height: context.heightPct(0.01)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.category_rounded,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSecondary.withValues(alpha: .7),
                    ),
                    SizedBox(width: context.widthPct(0.02)),
                    Text(
                      Labels.trendingSubCategories,
                      style: TextStyle(
                        fontSize: context.scaledFont(15),
                        fontFamily: FontFamily.fontsPoppinsSemiBold,
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: context.heightPct(0.01)),
              StaggeredGrid.count(
                crossAxisCount: 3, // Defines 2 columns
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                children: List.generate(dummyFoodSubCategories.length, (index) {
                  var subCategory = dummyFoodSubCategories[index];
                  return StaggeredGridTile.fit(
                    crossAxisCellCount:
                    1, // Each item takes 1 column space
                    child: SubCategoryBox(
                      marginPadding: EdgeInsets.zero,
                      title: subCategory.name,
                     imageUrl: subCategory.imageUrl,
                      onTap: (){},

                    ),
                  );
                }),
              )


                ],
          ),
        ),
      ),
    );
  }
}
