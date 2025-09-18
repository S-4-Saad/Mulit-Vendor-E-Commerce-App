import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:speezu/core/utils/media_querry_extention.dart';
import 'package:speezu/presentation/category/bloc/category_event.dart';
import 'package:speezu/presentation/category/bloc/category_state.dart';
import 'package:speezu/routes/route_names.dart';
import 'package:speezu/widgets/app_cache_image.dart';
import 'package:speezu/widgets/custom_app_bar.dart';
import 'package:speezu/widgets/image_type_extention.dart';
import 'package:speezu/widgets/rating_display_widget.dart';
import 'package:speezu/widgets/search_animated_container.dart';
import 'package:speezu/widgets/sub_category_widget.dart';

import '../../core/assets/font_family.dart';
import '../../core/utils/labels.dart';
import '../../paractise.dart';
import '../../widgets/shop_box_widget.dart';
import 'bloc/category_bloc.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Categories',
        action: BlocBuilder<CategoryBloc, CategoryState>(
          builder:
              (context, state) => IconButton(
                onPressed: () {
                  context.read<CategoryBloc>().add(ChangeViewEvent());
                },
                icon: Icon(
                  state.isGridView ? Icons.grid_4x4 : Icons.list_rounded,
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
              ),
        ),
      ),
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
              BlocBuilder<CategoryBloc, CategoryState>(
                builder: (context, state) {
                  bool isGridView = state.isGridView;
                  return isGridView
                      ? Column(
                        children:
                            dummyShops.map((shop) {
                              return ShopBoxBigWidget(
                                imageUrl: shop.imageUrl,
                                shopName: shop.shopName,
                                shopDescription: shop.shopDescription,
                                shopRating: shop.shopRating,
                                isOpen: shop.isOpen,
                                isDelivering: shop.isDelivering,
                                onShopBoxTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    RouteNames.shopNavBarScreen,
                                  );
                                },
                                onDirectionTap: () {
                                  print('Direction to ${shop.shopName}');
                                },
                              );
                            }).toList(),
                      )
                      : ListView.separated(
                        padding: EdgeInsets.zero,
                        itemCount: dummyShops.length,
                        separatorBuilder: (_, __) => SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final shop = dummyShops[index];
                          return Container(
                            clipBehavior: Clip.antiAlias,
                            margin: EdgeInsets.only(
                              right: 5,
                              bottom: 5,
                              left: 5,
                            ),

                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Theme.of(context).colorScheme.onPrimary,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withValues(alpha: 0.2),
                                  spreadRadius: 1,
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                CustomImageView(
                                  imagePath: shop.imageUrl,
                                  width: 100,
                                  height: 80,

                                  fit: BoxFit.cover,
                                ),
                                SizedBox(width: context.widthPct(0.03)),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        shop.shopName,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: context.scaledFont(14),
                                          fontFamily:
                                              FontFamily.fontsPoppinsSemiBold,
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.onSecondary,
                                        ),
                                      ),
                                      Text(
                                        shop.shopDescription,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: context.scaledFont(12),
                                          fontFamily:
                                              FontFamily.fontsPoppinsRegular,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSecondary
                                              .withValues(alpha: .7),
                                        ),
                                      ),

                                      RatingDisplayWidget(
                                        rating: shop.shopRating,
                                        starSize: 14,
                                      ),
                                      //  SizedBox(height: context.heightPct(0.005)),
                                    ],
                                  ),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Theme.of(context).colorScheme.primary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),

                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    elevation: 0,
                                  ),
                                  onPressed: () {},
                                  child: Icon(
                                    Icons.directions,
                                    color:
                                      Colors.white,
                                    size: 25,
                                  ),
                                ),
                                SizedBox(width: context.widthPct(0.02)),
                              ],
                            ),
                          );
                        },
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                      );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
