import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../models/product_detail_model.dart';
import '../../../models/product_model.dart';
import '../../../widgets/product_box_widget.dart';

class FoodProductsScreen extends StatefulWidget {
  FoodProductsScreen({super.key});

  @override
  State<FoodProductsScreen> createState() => _FoodProductsScreenState();
}

class _FoodProductsScreenState extends State<FoodProductsScreen> {
  @override
  void initState() {
    super.initState();
    print('object');
  }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: SingleChildScrollView(
          child: StaggeredGrid.count(
            crossAxisCount: 2, // Defines 2 columns
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            children: List.generate(dummyFoodProducts.length, (index) {

              return StaggeredGridTile.fit(
                crossAxisCellCount: 1, // Each item takes 1 column space
                child: ProductBox(
                  marginPadding: const Padding(padding: EdgeInsets.all(0)),
                  productWidth: 200,
                  productPrice: dummyFoodProducts[index].productPrice,
                  productOriginalPrice:
                      dummyFoodProducts[index].productOriginalPrice,
                  productCategory: dummyFoodProducts[index].productCategory,
                  productRating: dummyFoodProducts[index].productRating,
                  isProductFavourite: dummyFoodProducts[index].isProductFavourite,
                  onFavouriteTap: () {},
                  onProductTap: () {},
                  productImageUrl: dummyFoodProducts[index].productImageUrl,
                  productTitle: dummyFoodProducts[index].productTitle,
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
