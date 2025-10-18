import 'package:flutter/material.dart';
import 'package:speezu/models/shop_model.dart';
import 'package:speezu/widgets/shop_box_widget.dart';
class ShopList extends StatelessWidget {
  final List<ShopModel> shops;
  final Function(ShopModel)? onShopTap;
  final VoidCallback? onOpenTap;
  final VoidCallback? onPickupTap;
  final Function(ShopModel)? onLocationTap;
  final double? height;
  final EdgeInsetsGeometry? padding;

  const ShopList({
    super.key,
    required this.shops,
    this.onShopTap,
    this.onOpenTap,
    this.onPickupTap,
    this.onLocationTap,
    this.height,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    if (shops.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      height: height ?? 300,
      padding: padding ?? const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: shops.length,
        itemBuilder: (context, index) {
          final shop = shops[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ShopBox(
              onShopBoxTap: () => onShopTap?.call(shop),

              imageUrl: shop.imageUrl.toString(),
              isDelivering: true,
              isOpen: true,
             onDirectionTap: () => onLocationTap?.call(shop),

              shopName: shop.shopName,
              shopDescription: shop.shopDescription,
              shopRating: shop.shopRating,
            ),
          );
        },
      ),
    );
  }
}
