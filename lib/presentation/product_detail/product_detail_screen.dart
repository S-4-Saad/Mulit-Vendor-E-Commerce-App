import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:speezu/core/utils/currency_icon.dart';
import 'package:speezu/core/utils/media_querry_extention.dart';
import 'package:speezu/presentation/product_detail/bloc/product_detail_bloc.dart';
import 'package:speezu/routes/route_names.dart';
import 'package:speezu/widgets/app_cache_image.dart';
import 'package:speezu/widgets/rating_display_widget.dart';

import '../../core/assets/font_family.dart';
import '../../core/utils/labels.dart';
import '../../models/product_detail_model.dart';
import '../../models/product_model.dart';
import '../../paractise.dart';
import '../../widgets/custom_action_container.dart';
import '../../widgets/image_gallery_viewer_widget.dart';
import '../../widgets/image_type_extention.dart';
import '../../widgets/open_status_container.dart';
import '../../widgets/option_selector_widget.dart';
import '../../widgets/product_box_widget.dart';
import '../../widgets/shop_product_box.dart';
import 'bloc/product_detail_event.dart';
import 'bloc/product_detail_state.dart';

class ProductDetailScreen extends StatefulWidget {
  ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final dummyProduct = ProductDetail(
    productDiscountPercentage: 22,
    isAvailable: true,
    isDeliveryAvailable: true,
    price: 22.99,
    originalPrice: 30.00,
    rating: 4.5,
    isFavourite: false,
    name: "Delicious Pizza",
    thumbnail:
        "https://images.ctfassets.net/j8tkpy1gjhi5/5OvVmigx6VIUsyoKz1EHUs/b8173b7dcfbd6da341ce11bcebfa86ea/Salami-pizza-hero.jpg",
    images: [
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSeo_JMT1ZvwUNMHneItLQcNgYbwRsSs2mqYA&s",
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR7YNVwJV-2IIK2-ZMOrNnfA0BU33gVgNX-bQ&s",
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQSqEpYTIg-oPtHkAhKTfIrYzNvrtNTFKZmAw&s",
    ],
    categoryName: "Food",
    subCategoryName: 'Pizza',
    shopName: "Pizza Palace",
    description:
        "A delicious pizza with fresh ingredients and mouth-watering taste. A delicious pizza with fresh ingredients and mouth-watering taste. A delicious pizza with fresh ingredients and mouth-watering taste. A delicious pizza with fresh ingredients and mouth-watering taste. A delicious pizza with fresh ingredients and mouth-watering taste. A delicious pizza with fresh ingredients and mouth-watering taste. A delicious pizza with fresh ingredients and mouth-watering taste.",
    shop: ShopBoxModel(
      categoryName: "Food",
      name: "Pizza Palace",
      imageUrl: "https://images.unsplash.com/photo-1555396273-367ea4eb4db5",
      rating: 4.5,
    ),
    variations: [
      ProductVariation(
        parentName: "Fajita",
        parentOptionName: "Flavor",
        parentPrice: 1200,
        children: [
          ProductSubVariation(
            name: "Small",
            childOptionName: "Size",
            price: 700,
            stock: 10,
            stockTotal: 20,
          ),
          ProductSubVariation(
            name: "Medium",
            childOptionName: "Size",
            price: 1000,
            stock: 5,
            stockTotal: 15,
          ),
          ProductSubVariation(
            name: "Large",
            childOptionName: "Size",
            price: 1500,
            stock: 3,
            stockTotal: 10,
          ),
        ],
      ),
      ProductVariation(
        parentName: "Malai Boti",
        parentOptionName: "Flavor",
        parentPrice: 1300,
        children: [
          ProductSubVariation(
            name: "Small",
            childOptionName: "Size",
            price: 800,
            stock: 12,
            stockTotal: 20,
          ),
          ProductSubVariation(
            name: "Medium",
            childOptionName: "Size",
            price: 1100,
            stock: 7,
            stockTotal: 15,
          ),
          ProductSubVariation(
            name: "Large",
            childOptionName: "Size",
            price: 1600,
            stock: 2,
            stockTotal: 10,
          ),
        ],
      ),
      ProductVariation(
        parentName: "Special",
        parentOptionName: "Flavor",
        parentPrice: 1300,
        children: [
          ProductSubVariation(
            name: "Small",
            childOptionName: "Size",
            price: 800,
            stock: 12,
            stockTotal: 20,
          ),
          ProductSubVariation(
            name: "Medium",
            childOptionName: "Size",
            price: 1100,
            stock: 7,
            stockTotal: 15,
          ),
          ProductSubVariation(
            name: "Large",
            childOptionName: "Size",
            price: 1600,
            stock: 2,
            stockTotal: 10,
          ),
        ],
      ),
    ],
  );
  final List<DummyProductModel> dummyFoodProducts = [
    DummyProductModel(
      id: "1",
      productTitle: "Cheese Burger",
      productPrice: 4.99,
      productOriginalPrice: 6.99,
      productImageUrl:
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRctS9Fc8yYWbhqIqWuIJESV_PFF1e7Rg9i1Q&s",
      productRating: 4.5,
      productCategory: "Fast Food",
      isProductFavourite: true,
    ),
    DummyProductModel(
      id: "2",
      productTitle: "Pepperoni Pizza",
      productPrice: 8.99,
      productOriginalPrice: 11.99,
      productImageUrl:
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRHoML_RWrNhS3xbZNeWhpj9jjsyG7Ex-43aw&s",
      productRating: 4.7,
      productCategory: "Pizza",
    ),
    DummyProductModel(
      id: "3",
      productTitle: "Grilled Chicken Sandwich",
      productPrice: 5.49,
      productOriginalPrice: 7.49,
      productImageUrl:
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRfDnZMDTRzMYUGZuC_bgHNaY8xUZRhypK3cw&s",
      productRating: 4.3,
      productCategory: "Sandwiches",
    ),
    DummyProductModel(
      id: "4",
      productTitle: "Caesar Salad",
      productPrice: 3.99,
      productOriginalPrice: 5.99,
      productImageUrl:
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQP9oCufjbqRr8NjbEffdJW7xaYlCw6EOShWg&s",
      productRating: 4.0,
      productCategory: "Salads",
    ),
    DummyProductModel(
      id: "5",
      productTitle: "Chocolate Milkshake",
      productPrice: 2.99,
      productOriginalPrice: 4.49,
      productImageUrl:
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRzBfJl8vW3YMgLXZvhJp_qvSR803w6MHk2Uw&s",
      productRating: 4.6,
      productCategory: "Beverages",
    ),
    DummyProductModel(
      id: "6",
      productTitle: "French Fries",
      productPrice: 1.99,
      productOriginalPrice: 3.49,
      productImageUrl:
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS8N0tUijh_HHnvvTSUA-vNph2IuwTKWUgoYg&s",
      productRating: 4.2,
      productCategory: "Snacks",
      isProductFavourite: true,
    ),
    DummyProductModel(
      id: "7",
      productTitle: "Sushi Platter",
      productPrice: 12.99,
      productOriginalPrice: 15.99,
      productImageUrl:
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcThQ21CGPbsX0XeK4WJXp3BoHy7ZHxuo6IIOg&s",
      productRating: 4.8,
      productCategory: "Japanese",
    ),
    DummyProductModel(
      id: "8",
      productTitle: "Pasta Alfredo",
      productPrice: 7.49,
      productOriginalPrice: 9.99,
      productImageUrl:
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQNb-2E4TRtAxpHsCpXdaxHBSsHEdX_WO-tyQ&s",
      productRating: 4.4,
      productCategory: "Italian",
    ),
    DummyProductModel(
      id: "9",
      productTitle: "Tacos",
      productPrice: 3.49,
      productOriginalPrice: 3.49,
      productImageUrl: "https://picsum.photos/200/300?food=9",
      productRating: 4.1,
      productCategory: "Mexican",
    ),
    DummyProductModel(
      id: "10",
      productTitle: "Ice Cream Sundae",
      productPrice: 2.49,
      productOriginalPrice: 3.99,
      productImageUrl: "https://picsum.photos/200/300?food=10",
      productRating: 4.9,
      productCategory: "Desserts",
      isProductFavourite: true,
    ),
  ];

  String? selectedParent;
  // e.g. "Fajita"
  String? selectedChild;
  final ScrollController _scrollController = ScrollController();

  // e.g. "Medium"
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection == ScrollDirection.reverse) {
        context.read<ProductDetailBloc>().add(HideBottomBar());
      } else if (_scrollController.position.userScrollDirection == ScrollDirection.forward) {
        context.read<ProductDetailBloc>().add(ShowBottomBar());
      }
    });
  }

  Widget build(BuildContext context) {
    final parentNames =
        dummyProduct.variations.map((e) => e.parentName).toList();
    final selectedParentVariation = dummyProduct.variations.firstWhere(
      (v) => v.parentName == selectedParent,
      orElse: () => dummyProduct.variations.first,
    );
    final childOptions =
        selectedParent == null ? [] : selectedParentVariation.children;

    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.9),
                expandedHeight: 300,
                elevation: 0,
                automaticallyImplyLeading: false,
                leading: IconButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.5),
                    ),
                  ),
                  icon: Icon(
                    Icons.arrow_back,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  background: CustomImageView(
                    fit: BoxFit.cover,
                    imagePath: dummyProduct.thumbnail,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Wrap(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Name + Rating
                          SizedBox(height: context.heightPct(.01)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                dummyProduct.shopName,
                                style: TextStyle(
                                  fontFamily: FontFamily.fontsPoppinsRegular,
                                  color:
                                      Theme.of(context).colorScheme.onSecondary,
                                  fontSize: 13,
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    size: context.scaledFont(16),
                                    color:
                                        Theme.of(
                                          context,
                                        ).colorScheme.onSurfaceVariant,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    "4.5",
                                    style: TextStyle(
                                      fontFamily: FontFamily.fontsPoppinsLight,
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.onSecondary,
                                      fontSize: context.scaledFont(12),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: context.heightPct(.01)),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  dummyProduct.name,
                                  style: TextStyle(
                                    fontFamily: FontFamily.fontsPoppinsSemiBold,
                                    color:
                                        Theme.of(
                                          context,
                                        ).colorScheme.onSecondary,
                                    fontSize: context.scaledFont(18),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              if (dummyProduct.productDiscountPercentage > 0)
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10),
                                    ),
                                  ),
                                  child: Text(
                                    '-${dummyProduct.productDiscountPercentage}%',
                                    style: TextStyle(
                                      fontFamily:
                                          FontFamily.fontsPoppinsSemiBold,
                                      fontSize: 13,
                                      color: Colors.white.withValues(
                                        alpha: 0.8,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(height: context.heightPct(.01)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "${CurrencyIcon.currencyIcon}${dummyProduct.price.toStringAsFixed(2)}",
                                    style: TextStyle(
                                      fontFamily:
                                          FontFamily.fontsPoppinsSemiBold,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontSize: 22,
                                    ),
                                  ),
                                  SizedBox(width: context.widthPct(.02)),
                                  if (dummyProduct.originalPrice !=
                                      dummyProduct.price)
                                    Text(
                                      "${CurrencyIcon.currencyIcon}${dummyProduct.originalPrice!.toStringAsFixed(2)}",
                                      style: TextStyle(
                                        fontFamily:
                                            FontFamily.fontsPoppinsLight,
                                        decoration: TextDecoration.lineThrough,
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.onSecondary,
                                        fontSize: context.scaledFont(12),
                                      ),
                                    ),
                                ],
                              ),
                              IsAvailableContainer(
                                isAvailable: true,
                                isDelivering: false,
                              ),
                            ],
                          ),
                          SizedBox(height: context.heightPct(.02)),
                          // if (dummyProduct.variations.isNotEmpty)
                          OptionSelectorWidget(
                            name:
                                dummyProduct
                                    .variations
                                    .first
                                    .parentOptionName, // "Flavor"
                            options: parentNames,
                            selectedOption: selectedParent,
                            onSelect: (value) {
                              setState(() {
                                selectedParent = value;
                                selectedChild =
                                    null; // reset child when parent changes
                              });
                            },
                          ),
                          SizedBox(height: context.heightPct(.01)),
                          if (selectedParent != null)
                            OptionSelectorWidget(
                              name:
                                  selectedParentVariation
                                      .children
                                      .first
                                      .childOptionName, // "Size"
                              options: childOptions.map((e) => e.name).toList(),
                              selectedOption: selectedChild,
                              onSelect: (value) {
                                setState(() {
                                  selectedChild = value;
                                });
                              },
                            ),

                          SizedBox(height: 10),

                          SizedBox(
                            height: 200,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.all(12),
                              itemCount: dummyProduct.images.length,
                              separatorBuilder:
                                  (_, __) => const SizedBox(width: 10),
                              itemBuilder: (context, index) {
                                return CustomImageView(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => ImageGalleryViewer(
                                              imageUrls: dummyProduct.images,
                                              initialIndex: index,
                                            ),
                                      ),
                                    );
                                    print(index);
                                  },
                                  radius: BorderRadius.circular(10),

                                  imagePath: dummyProduct.images[index],
                                  width: context.widthPct(.55),
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            // padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.onPrimary,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Theme.of(
                                  context,
                                ).colorScheme.outline.withValues(alpha: .3),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withValues(alpha: 0.1),
                                  spreadRadius: 1,
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0,
                                  ),
                                  child: Text(
                                    Labels.description,
                                    style: TextStyle(
                                      fontFamily:
                                          FontFamily.fontsPoppinsSemiBold,
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.onSecondary,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Divider(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.outline.withValues(alpha: .3),
                                ),

                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0,
                                  ),
                                  child: Text(
                                    dummyProduct.description,
                                    style: TextStyle(
                                      fontFamily: FontFamily.fontsPoppinsLight,

                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.onSecondary,
                                      fontSize: context.scaledFont(12),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          ShopProductBox(
                            categoryName: dummyProduct.shop.categoryName,
                            shopImageUrl: dummyProduct.shop!.imageUrl,
                            rating: dummyProduct.shop!.rating * 20,
                            shopName: dummyProduct.shop!.name,
                            onViewStoreTap: () {
                              Navigator.pushNamed(
                                context,
                                RouteNames.shopNavBarScreen,
                              );
                              // Navigate to shop page
                            },
                          ),

                          SizedBox(height: 15),

                          Text(
                            Labels.youMightAlsoLike,
                            style: TextStyle(
                              fontFamily: FontFamily.fontsPoppinsSemiBold,
                              color: Theme.of(context).colorScheme.onSecondary,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 15),
                          StaggeredGrid.count(
                            crossAxisCount: 2, // Defines 2 columns
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            children: List.generate(dummyFoodProducts.length, (
                              index,
                            ) {
                              var product = dummyFoodProducts[index];
                              return StaggeredGridTile.fit(
                                crossAxisCellCount:
                                    1, // Each item takes 1 column space
                                child: ProductBox(
                                  marginPadding: const Padding(
                                    padding: EdgeInsets.all(0),
                                  ),
                                  productWidth: 200,
                                  productPrice:
                                      dummyFoodProducts[index].productPrice,
                                  productOriginalPrice:
                                      dummyFoodProducts[index]
                                          .productOriginalPrice,
                                  productCategory:
                                      dummyFoodProducts[index].productCategory,
                                  productRating:
                                      dummyFoodProducts[index].productRating,
                                  isProductFavourite:
                                      dummyFoodProducts[index]
                                          .isProductFavourite,
                                  onFavouriteTap: () {},
                                  onProductTap: () {},
                                  productImageUrl:
                                      dummyFoodProducts[index].productImageUrl,
                                  productTitle:
                                      dummyFoodProducts[index].productTitle,
                                ),
                              );
                            }),
                          ),
                          SizedBox(height: 15),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          BlocBuilder<ProductDetailBloc, ProductDetailState>(builder:  (context, state) => SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedSlide(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
                offset: state.isBottomSheetVisible ? Offset(0, 0) : Offset(0, 1),
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: state.isBottomSheetVisible ? 1 : 0,
                  child: Container(
                    padding:  const EdgeInsets.symmetric(
                      horizontal: 15.0,
                      vertical: 8.0,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onPrimary,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                      border: Border.all(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: .3),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: const Offset(2, 0),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              Labels.quantity,
                              style: TextStyle(
                                fontFamily: FontFamily.fontsPoppinsSemiBold,
                                color:
                                Theme.of(context).colorScheme.onSecondary,
                                fontSize: 16,
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.remove_circle_outline,
                                    color:
                                    Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "1",
                                  style: TextStyle(
                                    fontFamily: FontFamily.fontsPoppinsSemiBold,
                                    color:
                                    Theme.of(
                                      context,
                                    ).colorScheme.onSecondary,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(width: 10),
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.add_circle_outline,
                                    color:
                                    Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  Theme.of(context).colorScheme.primary,
                                ),
                                minimumSize: MaterialStateProperty.all(
                                  Size(60, 50),
                                ),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                ),
                              ),
                              onPressed: () {},
                              icon: Icon(Icons.favorite, color: Colors.white),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                    Theme.of(context).colorScheme.primary,
                                  ),
                                  minimumSize: MaterialStateProperty.all(
                                    Size(250, 50),
                                  ),
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                  ),
                                ),
                                onPressed: () {},
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      Labels.addToCart,
                                      style: TextStyle(
                                        fontFamily:
                                        FontFamily.fontsPoppinsSemiBold,
                                        color: Colors.white,
                                        fontSize: 15,
                                      ),
                                    ),
                                    Text(
                                      '22\$',
                                      style: TextStyle(
                                        fontFamily:
                                        FontFamily.fontsPoppinsSemiBold,
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),),
          Positioned(
            top: 50,
            right: 20,
            child: FloatingActionButton(
              backgroundColor: Theme.of(context).colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              // mini: true,
              // elevation: 5,
              // highlightElevation: 5,
              // hoverElevation: 5,
              // focusElevation: 5,
              // disabledElevation: 5,
              // splashColor: Colors.white,),
              onPressed: () {},
              child: Icon(
                Icons.shopping_cart_rounded,
                color: Colors.white,
                size: 25,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
