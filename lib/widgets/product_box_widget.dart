// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:speezu/presentation/favourites/bloc/favourite_bloc.dart';
// import '../core/assets/font_family.dart';
// import '../core/utils/currency_icon.dart';
// import '../presentation/favourites/bloc/favourite_event.dart';
// import 'app_cache_image.dart';
//
// class ProductBox extends StatelessWidget {
//   const ProductBox({
//     super.key,
//     required this.onProductTap,
//     required this.productTitle,
//     required this.productPrice,
//     required this.productImageUrl,
//     required this.productOriginalPrice,
//     this.productRating = 0.0,
//     this.productWidth = 165.0,
//     this.marginPadding = const Padding(padding: EdgeInsets.only(right: 5, left: 5)),
//     // this.isProductDiscounted = false,
//     this.currencySymbol = CurrencyIcon.currencyIcon,
//     this.productCategory,
//     // this.isProductFavourite = false,
//    required this.productId,
//   });
//
//   final VoidCallback onProductTap;
//   final String productId;
//   final double productWidth;
//   final String productImageUrl;
//   final String productTitle;
//   final double productPrice;
//   final double productOriginalPrice;
//   final Padding marginPadding;
//   final double productRating;
//   final String currencySymbol;
//   final String? productCategory;
//   // final bool isProductFavourite;
//   // final VoidCallback onFavouriteTap;
//
//   @override
//   Widget build(BuildContext context) {
//     bool hasDiscount = productPrice < productOriginalPrice;
//     double discount = 0.0;
//     if (hasDiscount) {
//       discount =
//           ((productOriginalPrice - productPrice) / productOriginalPrice) * 100;
//     }
//
//     return GestureDetector(
//       onTap: onProductTap,
//       child: Stack(
//         alignment: Alignment.topRight,
//         children: [
//           Container(
//             width: productWidth,
//             margin: marginPadding.padding,
//             padding: EdgeInsets.all(10),
//             decoration: BoxDecoration(
//               color: Theme.of(context).colorScheme.onPrimary,
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(
//                 color: Theme.of(
//                   context,
//                 ).colorScheme.outline.withValues(alpha: .3),
//               ),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withValues(alpha: 0.1),
//                   spreadRadius: 1,
//                   blurRadius: 4,
//                   offset: const Offset(0, 2),
//                 ),
//               ],
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 // Product Image with error handling
//                 Stack(
//                   alignment: Alignment.topLeft,
//                   children: [
//                     ClipRRect(
//                       borderRadius: BorderRadius.circular(7),
//                       child: SizedBox(
//                         // height:  heightRequire?155.h:null,
//                         child: AppCacheImage(
//                           height: 155,
//                           width: double.infinity,
//                           round: 7,
//                           imageUrl:
//                               productImageUrl.isEmpty
//                                   ? 'https://codup.co/wp-content/uploads/2021/06/How-To-Fix-Failed-to-load-resource-net-ERR_BLOCKED_BY_CLIENT-Error.png-1.webp'
//                                   : productImageUrl,
//                         ),
//                       ),
//                     ),
//                     if (hasDiscount)
//                       Container(
//                         height: 17,
//                         width: 33,
//                         decoration: BoxDecoration(
//                           color: Theme.of(context).colorScheme.onSecondary,
//                           borderRadius: BorderRadius.only(
//                             topLeft: Radius.circular(7),
//                             bottomRight: Radius.circular(7),
//                           ),
//                         ),
//                         child: Center(
//                           child: Text(
//                             '${discount.toStringAsFixed(0)}%',
//                             style: TextStyle(
//                               fontFamily: FontFamily.fontsPoppinsSemiBold,
//                               color: Theme.of(context).colorScheme.onPrimary,
//                               fontSize: 8,
//                               fontWeight: FontWeight.w700,
//                             ),
//                           ),
//                         ),
//                       ),
//                   ],
//                 ),
//                 SizedBox(height: 5),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     if (productCategory != null && productCategory!.isNotEmpty)
//                       Flexible(
//                         child: Text(
//                           productCategory!,
//                           style: TextStyle(
//                             fontFamily: FontFamily.fontsPoppinsLight,
//                             color: Theme.of(
//                               context,
//                             ).colorScheme.onSecondary.withValues(alpha: .5),
//                             fontSize: 8,
//                           ),
//                         ),
//                       ),
//                     if (productRating > 0)
//                       Row(
//                         children: [
//                           Icon(
//                             Icons.star,
//                             color:
//                                 Theme.of(context).colorScheme.onSurfaceVariant,
//                             size: 13,
//                           ),
//                           SizedBox(width: 3),
//                           Text(
//                             '(${productRating.toStringAsFixed(1)})',
//                             style: TextStyle(
//                               fontFamily: FontFamily.fontsPoppinsLight,
//                               color: Theme.of(
//                                 context,
//                               ).colorScheme.onSecondary.withValues(alpha: .5),
//                               fontSize: 8,
//                             ),
//                           ),
//                         ],
//                       ),
//                   ],
//                 ),
//
//                 Text(
//                   productTitle.isEmpty ? 'Unnamed Product' : productTitle,
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                   style: TextStyle(
//                     fontFamily: FontFamily.fontsPoppinsSemiBold,
//                     color: Theme.of(context).colorScheme.onSecondary,
//                     fontSize: 9,
//                     fontWeight: FontWeight.w700,
//                   ),
//                 ),
//                 SizedBox(height: 5),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Flexible(
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             '$currencySymbol${productPrice.toStringAsFixed(1)}',
//                             style: TextStyle(
//                               fontFamily: FontFamily.fontsPoppinsSemiBold,
//                               color: Theme.of(context).colorScheme.primary,
//                               fontSize: 10,
//                               fontWeight: FontWeight.w700,
//                             ),
//                           ),
//                           if (hasDiscount)
//                             Padding(
//                               padding: EdgeInsets.only(left: 5),
//                               child: Text(
//                                 '$currencySymbol${productOriginalPrice.toStringAsFixed(1)}',
//                                 style: TextStyle(
//                                   fontFamily: FontFamily.fontsPoppinsSemiBold,
//                                   color: Theme.of(context)
//                                       .colorScheme
//                                       .onSecondary
//                                       .withValues(alpha: 0.6),
//                                   fontSize: 8,
//                                   decoration: TextDecoration.lineThrough,
//                                 ),
//                               ),
//                             ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//
//
//               ],
//             ),
//           ),
//           // Positioned(
//           //   top: 8,
//           //   right: 8,
//           //   child: FloatingActionButton(
//           //     heroTag: 'favourite_$productTitle',
//           //     onPressed: (){
//           //       context.read<FavouriteBloc>().add(ToggleFavouriteEvent(productId: int.parse(productId)));
//           //     },
//           //
//           //     shape: RoundedRectangleBorder(
//           //       borderRadius: BorderRadius.circular(200),
//           //     ),
//           //     splashColor: Theme.of(
//           //       context,
//           //     ).colorScheme.primary.withValues(alpha: .2),
//           //     mini: true,
//           //     backgroundColor: Theme.of(
//           //       context,
//           //     ).colorScheme.onPrimary.withValues(alpha: .9),
//           //     child: Icon(
//           //       isProductFavourite
//           //           ? Icons.favorite
//           //           : Icons.favorite_border,
//           //       color:
//           //           isProductFavourite
//           //               ? Theme.of(context).colorScheme.onTertiary
//           //               : Theme.of(
//           //                 context,
//           //               ).colorScheme.onSecondary.withValues(alpha: .7),
//           //       size: 20,
//           //     ),
//           //   ),
//           // ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import '../core/assets/font_family.dart';
import '../core/utils/currency_icon.dart';
import '../core/utils/labels.dart';
import 'app_cache_image.dart';

class ProductBox extends StatefulWidget {
  const ProductBox({
    super.key,
    required this.onProductTap,
    required this.productTitle,
    required this.productPrice,
    required this.productImageUrl,
    required this.productOriginalPrice,
    this.productRating = 0.0,
    this.productWidth = 190.0,
    this.marginPadding = const Padding(
      padding: EdgeInsets.only(right: 5, left: 5),
    ),
    this.currencySymbol = CurrencyIcon.currencyIcon,
    this.productCategory,
    required this.productId,
    this.isProductFavourite = false,  this.categoryName, required this.isDeliverable,
  });

  final VoidCallback onProductTap;
  final String productId;
  final double productWidth;
  final String productImageUrl;
  final String productTitle;
  final double productPrice;
  final double productOriginalPrice;
  final Padding marginPadding;
  final double productRating;
  final String currencySymbol;
  final String? productCategory;
  final bool isProductFavourite;
  final String? categoryName;
  final bool isDeliverable;

  @override
  State<ProductBox> createState() => _ProductBoxState();
}

class _ProductBoxState extends State<ProductBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.97,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool hasDiscount = widget.productPrice < widget.productOriginalPrice;
    double discount = 0.0;
    if (hasDiscount) {
      discount =
          ((widget.productOriginalPrice - widget.productPrice) /
              widget.productOriginalPrice) *
          100;
    }

    return GestureDetector(
      onTapDown: (_) {
        setState(() => _isPressed = true);
        _controller.forward();
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
        _controller.reverse();
      },
      onTapCancel: () {
        setState(() => _isPressed = false);
        _controller.reverse();
      },
      onTap: widget.onProductTap,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: widget.productWidth,
          margin: widget.marginPadding.padding,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onPrimary,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color:
                  _isPressed
                      ? Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.3)
                      : Theme.of(
                        context,
                      ).colorScheme.onSecondary.withValues(alpha: 0.08),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color:
                    _isPressed
                        ? Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.15)
                        : Colors.black.withValues(alpha: 0.04),
                spreadRadius: _isPressed ? 2 : 0,
                blurRadius: _isPressed ? 12 : 8,
                offset: Offset(0, _isPressed ? 4 : 2),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Main Content
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Image
                    Stack(
                      children: [
                        // Image Container with Gradient Overlay
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Stack(
                            children: [
                              AppCacheImage(
                                height: 155,
                                width: double.infinity,
                                round: 12,
                                imageUrl:
                                    widget.productImageUrl.isEmpty
                                        ? 'https://codup.co/wp-content/uploads/2021/06/How-To-Fix-Failed-to-load-resource-net-ERR_BLOCKED_BY_CLIENT-Error.png-1.webp'
                                        : widget.productImageUrl,
                              ),
                              // Subtle gradient overlay
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      colors: [
                                        Colors.black.withValues(alpha: 0.15),
                                        Colors.transparent,
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Discount Badge
                        if (hasDiscount)
                          Positioned(
                            top: 8,
                            left: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.red.shade400,
                                    Colors.red.shade600,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.red.withValues(alpha: 0.3),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.local_offer,
                                    size: 10,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 3),
                                  Text(
                                    '${discount.toStringAsFixed(0)}% OFF',
                                    style: const TextStyle(
                                      fontFamily: FontFamily.fontsPoppinsBold,
                                      color: Colors.white,
                                      fontSize: 9,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        if (widget.isDeliverable)
                          Positioned(
                            bottom: 8,
                            right: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                  Colors.blue.shade400,
                                  Colors.blue.shade600,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.blue.withValues(alpha: 0.3),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.delivery_dining,
                                    size: 10,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 3),
                                  Text(
                                    Labels.deliverable,
                                    style: const TextStyle(
                                      fontFamily: FontFamily.fontsPoppinsBold,
                                      color: Colors.white,
                                      fontSize: 9,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // Category & Rating Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Category Badge
                        if (widget.productCategory != null &&
                            widget.productCategory!.isNotEmpty)
                          Flexible(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).colorScheme.primary.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                widget.productCategory!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: FontFamily.fontsPoppinsMedium,
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: 9,
                                ),
                              ),
                            ),
                          ),
                        if (widget.categoryName != null &&
                            widget.categoryName!.isNotEmpty)
                          Flexible(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).colorScheme.primary.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                widget.categoryName!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: FontFamily.fontsPoppinsMedium,
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: 9,
                                ),
                              ),
                            ),
                          ),

                        // Rating
                        // if (widget.productRating > 0)
                        //   Container(
                        //     padding: const EdgeInsets.symmetric(
                        //       horizontal: 6,
                        //       vertical: 3,
                        //     ),
                        //     decoration: BoxDecoration(
                        //       color: Colors.amber.withValues(alpha: 0.15),
                        //       borderRadius: BorderRadius.circular(6),
                        //     ),
                        //     child: Row(
                        //       mainAxisSize: MainAxisSize.min,
                        //       children: [
                        //         Icon(
                        //           Icons.star_rounded,
                        //           color: Colors.amber.shade700,
                        //           size: 12,
                        //         ),
                        //         const SizedBox(width: 2),
                        //         Text(
                        //           widget.productRating.toStringAsFixed(1),
                        //           style: TextStyle(
                        //             fontFamily: FontFamily.fontsPoppinsSemiBold,
                        //             color: Colors.amber.shade900,
                        //             fontSize: 9,
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Product Title
                    Text(
                      widget.productTitle.isEmpty
                          ? 'Unnamed Product'
                          : widget.productTitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: FontFamily.fontsPoppinsSemiBold,
                        color: Theme.of(context).colorScheme.onSecondary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Price Row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Current Price
                        Text(
                          '${widget.currencySymbol}${widget.productPrice.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontFamily: FontFamily.fontsPoppinsBold,
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        // Original Price (if discounted)
                        if (hasDiscount) ...[
                          const SizedBox(width: 6),
                          Text(
                            '${widget.currencySymbol}${widget.productOriginalPrice.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontFamily: FontFamily.fontsPoppinsRegular,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSecondary.withValues(alpha: 0.5),
                              fontSize: 10,
                              decoration: TextDecoration.lineThrough,
                              decorationColor: Theme.of(
                                context,
                              ).colorScheme.onSecondary.withValues(alpha: 0.5),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),

              // Favorite Button
              // Positioned(
              //   top: 8,
              //   right: 8,
              //   child: _FavoriteButton(
              //     isFavorite: widget.isProductFavourite,
              //     onPressed: () {
              //       context.read<FavouriteBloc>().add(
              //         ToggleFavouriteEvent(
              //           productId: int.parse(widget.productId),
              //         ),
              //       );
              //     },
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FavoriteButton extends StatefulWidget {
  final bool isFavorite;
  final VoidCallback onPressed;

  const _FavoriteButton({required this.isFavorite, required this.onPressed});

  @override
  State<_FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<_FavoriteButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    _controller.forward().then((_) => _controller.reverse());
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Theme.of(
            context,
          ).colorScheme.onPrimary.withValues(alpha: 0.95),
          shape: BoxShape.circle,
          border: Border.all(
            color:
                widget.isFavorite
                    ? Colors.red.shade300
                    : Theme.of(
                      context,
                    ).colorScheme.onSecondary.withValues(alpha: 0.15),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color:
                  widget.isFavorite
                      ? Colors.red.withValues(alpha: 0.2)
                      : Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _handleTap,
            customBorder: const CircleBorder(),
            child: Center(
              child: Icon(
                widget.isFavorite ? Icons.favorite : Icons.favorite_border,
                color:
                    widget.isFavorite
                        ? Colors.red.shade500
                        : Theme.of(
                          context,
                        ).colorScheme.onSecondary.withValues(alpha: 0.6),
                size: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
