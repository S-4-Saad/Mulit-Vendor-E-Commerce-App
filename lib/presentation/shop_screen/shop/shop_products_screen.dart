import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:speezu/core/assets/app_images.dart';
import 'package:speezu/core/assets/font_family.dart';
import 'package:speezu/core/utils/media_querry_extention.dart';
import 'package:speezu/presentation/shop_screen/bloc/shop_bloc.dart';
import 'package:speezu/presentation/shop_screen/bloc/shop_event.dart';
import 'package:speezu/widgets/search_animated_container.dart';

import '../../../core/utils/labels.dart';
import '../../../models/product_model.dart';
import '../../../models/store_model.dart';
import '../../../paractise.dart';
import '../../../widgets/product_box_widget.dart';
import '../../../widgets/sub_category_widget.dart';
import '../bloc/shop_state.dart';

class ShopProductsScreen extends StatelessWidget {
  ShopProductsScreen({super.key});
  final store = Store(
    ratting: 2.9,
    isDelivering: true,
    isOpen: true,
    openingTime: '10 Am',
    closingTime: "11 Pm",
    id: "s1",
    name: "Blue Lagoon Cafe",
    image: "https://images.unsplash.com/photo-1555396273-367ea4eb4db5",
    moreImages: [
      "https://images.unsplash.com/photo-1504674900247-0877df9cc836",
      "https://images.unsplash.com/photo-1504674900247-0877df9cc836",
    ],
    latitude: 24.8607,
    longitude: 67.0011,
    description: "A cozy cafe with categories and products.",
    information: "We serve coffee, snacks, and desserts.",
    whatsappNumber: "+923001112233",
    primaryNumber: "+923004445555",
    secondaryNumber: "+923009998888",
    address: "Karachi, Pakistan",
    reviews: [
      Review(
        username: "john_doe",
        id: "r1",
        reviewerName: "John Doe",
        reviewerImage: "https://randomuser.me/api/portraits/men/1.jpg",
        reviewText: "Amazing place, great coffee!",
        rating: 4.5,
        date: DateTime.now(),
        images: [],
      ),
    ],
    categories: [
      Category(
        id: "c1",
        name: "Coffee",
        imageUrl:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTO5j83gXer5-ih1NHeOxNkVpcbyN5t3leDpg&s",
        products: [
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
        ],
      ),
      Category(
        imageUrl:
            "https://cablevey.com/wp-content/uploads/2020/11/The-Complete-Guide-on-Snack-Foods.jpg",
        id: "c2",
        name: "Snacks",
        products: [
          DummyProductModel(
            id: "p3",
            productTitle: "French Fries",
            productPrice: 250,
            productOriginalPrice: 300,
            productImageUrl:
                "https://images.unsplash.com/photo-1586190848861-99aa4a171e90",
            productRating: 4.5,
            productCategory: "Snacks",
          ),
        ],
      ),
      Category(
        imageUrl:
            "https://cablevey.com/wp-content/uploads/2020/11/The-Complete-Guide-on-Snack-Foods.jpg",
        id: "c2",
        name: "Snacks",
        products: [
          DummyProductModel(
            id: "p3",
            productTitle: "French Fries",
            productPrice: 250,
            productOriginalPrice: 300,
            productImageUrl:
                "https://images.unsplash.com/photo-1586190848861-99aa4a171e90",
            productRating: 4.5,
            productCategory: "Snacks",
          ),
        ],
      ),
      Category(
        imageUrl:
            "https://cablevey.com/wp-content/uploads/2020/11/The-Complete-Guide-on-Snack-Foods.jpg",
        id: "c2",
        name: "Snacks",
        products: [
          DummyProductModel(
            id: "p3",
            productTitle: "French Fries",
            productPrice: 250,
            productOriginalPrice: 300,
            productImageUrl:
                "https://images.unsplash.com/photo-1586190848861-99aa4a171e90",
            productRating: 4.5,
            productCategory: "Snacks",
          ),
        ],
      ),
      Category(
        imageUrl:
            "https://cablevey.com/wp-content/uploads/2020/11/The-Complete-Guide-on-Snack-Foods.jpg",
        id: "c2",
        name: "Snacks",
        products: [
          DummyProductModel(
            id: "p3",
            productTitle: "French Fries",
            productPrice: 250,
            productOriginalPrice: 300,
            productImageUrl:
                "https://images.unsplash.com/photo-1586190848861-99aa4a171e90",
            productRating: 4.5,
            productCategory: "Snacks",
          ),
        ],
      ),
      Category(
        imageUrl:
            "https://cablevey.com/wp-content/uploads/2020/11/The-Complete-Guide-on-Snack-Foods.jpg",
        id: "c2",
        name: "Snacks",
        products: [
          DummyProductModel(
            id: "p3",
            productTitle: "French Fries",
            productPrice: 250,
            productOriginalPrice: 300,
            productImageUrl:
                "https://images.unsplash.com/photo-1586190848861-99aa4a171e90",
            productRating: 4.5,
            productCategory: "Snacks",
          ),
        ],
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    // Combine all products for "All Products" tab
    final allProducts = store.categories.expand((cat) => cat.products).toList();

    // Add "All" as a virtual category at index 0
    final categoriesWithAll = [
      Category(
        id: "all",
        name: Labels.allProducts,
        products: allProducts,
        imageUrl: AppImages.allProducts,
      ),
      ...store.categories,
    ];
    context.read<ShopBloc>().add(ChangeTabEvent(0));
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: context.heightPct(0.01)),

              // Horizontal scrollable category tabs using SubCategoryBox
              BlocBuilder<ShopBloc, ShopState>(
                builder: (context, state) {
                  return SizedBox(
                    height: 130,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: categoriesWithAll.length,
                      separatorBuilder: (_, __) => SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        final subCategory = categoriesWithAll[index];
                        final isSelected = state.tabCurrentIndex == index;

                        return SubCategoryBox(
                          marginPadding: EdgeInsets.zero,
                          title: subCategory.name,
                          imageUrl: subCategory.imageUrl ?? "",
                          isSelected: isSelected,
                          onTap: () {
                            context.read<ShopBloc>().add(ChangeTabEvent(index));
                          },
                        );
                      },
                    ),
                  );
                },
              ),

              SizedBox(height: context.heightPct(0.02)),

              // Products for selected category
              SingleChildScrollView(
                child: Expanded(
                  child: BlocBuilder<ShopBloc, ShopState>(
                    builder: (context, state) {
                      final selectedCategory =
                          categoriesWithAll[state.tabCurrentIndex];
                      final products = selectedCategory.products;

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: StaggeredGrid.count(
                          crossAxisCount: 2,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          children: List.generate(products.length, (index) {
                            var product = products[index];
                            return StaggeredGridTile.fit(
                              crossAxisCellCount: 1,
                              child: ProductBox(
                                marginPadding: const Padding(
                                  padding: EdgeInsets.all(0),
                                ),
                                productWidth: 200,
                                productPrice: product.productPrice,
                                productOriginalPrice:
                                    product.productOriginalPrice,
                                productCategory: product.productCategory,
                                productRating: product.productRating,
                                isProductFavourite: product.isProductFavourite,
                                onFavouriteTap: () {},
                                onProductTap: () {},
                                productImageUrl: product.productImageUrl,
                                productTitle: product.productTitle,
                              ),
                            );
                          }),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
