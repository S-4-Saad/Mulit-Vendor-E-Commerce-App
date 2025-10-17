import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speezu/core/assets/font_family.dart';
import 'package:speezu/core/utils/media_querry_extention.dart';
import 'package:speezu/models/store_detail_model.dart';
import 'package:speezu/presentation/nav_bar_screen/bloc/nav_bar_event.dart';
import 'package:speezu/presentation/shop_screen/shop/shop_review_screen.dart';
import 'package:speezu/widgets/error_widget.dart';
import 'package:speezu/widgets/image_gallery_viewer_widget.dart';
import 'package:speezu/widgets/product_review_box.dart';

import '../../../core/utils/labels.dart';
import '../../../widgets/business_hours_widget.dart';
import '../../../widgets/image_type_extention.dart';
import '../../../widgets/open_status_container.dart';
import '../../../widgets/rating_display_widget.dart';
import '../../../widgets/shop_detail_shimmer_widget.dart';
import '../../nav_bar_screen/bloc/nav_bar_bloc.dart';
import '../bloc/shop_bloc.dart';
import '../bloc/shop_event.dart';
import '../bloc/shop_state.dart';

class ShopDetailScreen extends StatefulWidget {
  final int? storeId;

  const ShopDetailScreen({super.key, this.storeId});

  @override
  State<ShopDetailScreen> createState() => _ShopDetailScreenState();
}

class _ShopDetailScreenState extends State<ShopDetailScreen> {
  @override
  void initState() {
    super.initState();
    // Load shop detail when the screen initializes
    if (widget.storeId != null) {
      context.read<ShopBloc>().add(
        LoadShopDetailEvent(storeId: widget.storeId!),
      );
    }
    Future.delayed(Duration(seconds: 1), () {
      if (widget.storeId != null) {
        context.read<ShopBloc>().add(CalculateShopDistanceEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShopBloc, ShopState>(
      builder: (context, state) {
        if (state.shopDetailStatus == ShopDetailStatus.loading) {
          return const ShopDetailShimmerWidget();
        }

        if (state.shopDetailStatus == ShopDetailStatus.error) {
          return Center(
            child: CustomErrorWidget(
              message: state.message,
              onRetry: () {
                if (widget.storeId != null) {
                  context.read<ShopBloc>().add(
                    LoadShopDetailEvent(storeId: widget.storeId!),
                  );
                }
              },
            ),
          );
        }

        // Check if storeDetail is available and status is success
        if (state.shopDetailStatus == ShopDetailStatus.success &&
            state.storeDetail != null) {
          return _buildStoreDetail(context, state.storeDetail!);
        }

        // If we reach here, something went wrong - show error
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red),
              SizedBox(height: 16),
              Text(
                Labels.storeDetailNotAvailable,
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (widget.storeId != null) {
                    context.read<ShopBloc>().add(
                      LoadShopDetailEvent(storeId: widget.storeId!),
                    );
                  }
                },
                child: Text(Labels.retry,style: TextStyle(color: Colors.white),),
              ),
            ],
          ),
        );
      },
    );
  }

  // Store _getDummyStore() {
  //   return Store(
  //     ratting: 4.5,
  //     isDelivering: true,
  //     isOpen: true,
  //     openingTime: '9 AM',
  //     closingTime: "10 PM",
  //     id: "1",
  //     name: "Sample Store",
  //     image: "https://via.placeholder.com/400x300",
  //     moreImages: [],
  //     latitude: 0.0,
  //     longitude: 0.0,
  //     description: "Sample store description",
  //     information: "Sample store information",
  //     whatsappNumber: "",
  //     primaryNumber: "",
  //     secondaryNumber: "",
  //     address: "Sample Address",
  //     reviews: [],
  //   );
  // }

  Widget _buildStoreDetail(BuildContext context, StoreDetailModel storeModel) {
    return Scaffold(
      body: CustomScrollView(
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
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
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
                imagePath: storeModel.store?.image ?? '',
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Wrap(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      // Name + Rating
                      SizedBox(height: context.heightPct(.01)),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              storeModel.store?.name ?? '',
                              style: TextStyle(
                                fontFamily: FontFamily.fontsPoppinsSemiBold,
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
                                fontSize: context.scaledFont(18),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
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
                                (storeModel.store?.rating ?? 0).toString(),
                                style: TextStyle(
                                  fontFamily: FontFamily.fontsPoppinsLight,
                                  color:
                                      Theme.of(context).colorScheme.onSecondary,
                                  fontSize: context.scaledFont(12),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: context.heightPct(.01)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          OpenStatusContainer(
                            isOpened: storeModel.store?.isOpen ?? false,
                            isDelivering: storeModel.store?.isDelivery ?? false,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSecondary.withValues(alpha: .2),
                              borderRadius: BorderRadius.circular(50),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: BlocBuilder<ShopBloc, ShopState>(
                              builder:
                                  (context, state) => Text(
                                    '${state.shopDistance} ${Labels.km}',
                                    style: TextStyle(
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.onPrimary,
                                      fontFamily:
                                          FontFamily.fontsPoppinsSemiBold,
                                      fontSize: context.scaledFont(10),
                                    ),
                                  ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: context.heightPct(.02)),
                      Text(
                        storeModel.store?.description ?? '',
                        style: TextStyle(
                          fontFamily: FontFamily.fontsPoppinsLight,

                          color: Theme.of(context).colorScheme.onSecondary,
                          fontSize: context.scaledFont(12),
                        ),
                      ),
                      SizedBox(height: context.heightPct(.01)),
                      SizedBox(
                        height: context.heightPct(.2),
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.all(12),
                          itemCount:
                              (storeModel.store?.moreImages ?? []).length,
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
                                          imageUrls:
                                              storeModel.store?.moreImages ??
                                              [],
                                          initialIndex: index,
                                        ),
                                  ),
                                );
                                print(index);
                              },
                              radius: BorderRadius.circular(10),

                              imagePath:
                                  (storeModel.store?.moreImages ?? [])[index],
                              width: context.widthPct(.55),
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                      ),
                      SizedBox(height: context.heightPct(.01)),
                      BusinessHoursWidget(
                        openingTime: storeModel.store?.openingTime ?? '',
                        closingTime: storeModel.store?.closingTime ?? '',
                      ),

                      SizedBox(height: context.heightPct(.01)),
                      // CustomActionContainer(
                      //   text:
                      //       Labels
                      //           .forMoreDetailsPleaseContactWithOurManagerOnWhatsApp,
                      //   icon: Icons.chat,
                      //   onTap: () {},
                      // ),
                      // SizedBox(height: context.heightPct(.01)),
                      // CustomActionContainer(
                      //   text: storeModel.store!.??'',
                      //   icon: Icons.directions,
                      //   onTap: () {},
                      // ),
                      SizedBox(height: context.heightPct(.01)),
                      // CustomActionContainer(
                      //   text:
                      //       '${storeModel.store!.}\n${storeModel.store!.secondaryNumber}',
                      //   icon: Icons.phone,
                      //   onTap: () {},
                      // ),
                      SizedBox(height: context.heightPct(.02)),
                      Row(
                        children: [
                          Icon(
                            Icons.closed_caption_off_outlined,
                            size: context.scaledFont(20),
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          SizedBox(width: 8),
                          Text(
                            Labels.information,
                            style: TextStyle(
                              fontFamily: FontFamily.fontsPoppinsSemiBold,
                              color: Theme.of(context).colorScheme.onSecondary,
                              fontSize: context.scaledFont(18),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        storeModel.store?.description ?? '',
                        style: TextStyle(
                          fontFamily: FontFamily.fontsPoppinsLight,

                          color: Theme.of(context).colorScheme.onSecondary,
                          fontSize: context.scaledFont(12),
                        ),
                      ),

                      SizedBox(height: context.heightPct(.02)),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).colorScheme.onPrimary,
                          border: Border.all(
                            color: Theme.of(
                              context,
                            ).colorScheme.outline.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  Labels.rattingAndReviews,
                                  style: TextStyle(
                                    fontSize: context.scaledFont(13),
                                    fontFamily: FontFamily.fontsPoppinsSemiBold,
                                    color:
                                        Theme.of(
                                          context,
                                        ).colorScheme.onSecondary,
                                  ),
                                ),
                                SizedBox(width: 5),
                                Text(
                                  '(${(storeModel.store?.reviews ?? []).length})',
                                  style: TextStyle(
                                    fontSize: context.scaledFont(12),
                                    fontFamily: FontFamily.fontsPoppinsRegular,
                                    color:
                                        Theme.of(
                                          context,
                                        ).colorScheme.onSecondary,
                                  ),
                                ),
                                const Spacer(),
                                Row(
                                  children: [
                                    Text(
                                      (storeModel.store?.rating ?? 0)
                                          .toString(),
                                      style: TextStyle(
                                        fontSize: context.scaledFont(14),
                                        fontFamily: FontFamily.fontsPoppinsBold,
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.onSecondary,
                                      ),
                                    ),
                                    RatingDisplayWidget(
                                      rating:
                                          (storeModel.store?.rating ?? 0)
                                              .toDouble(),
                                      starSize: context.scaledFont(16),
                                    ),
                                    // Icon(Icons.arrow_forward_ios_rounded, size: 15.w),
                                  ],
                                ),
                                IconButton(
                                  onPressed: () {
                                    context.read<NavBarBloc>().add(
                                      ShopSelectTab(1),
                                    );
                                  },
                                  icon: Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: context.scaledFont(12),
                                    color:
                                        Theme.of(context).colorScheme.outline,
                                  ),
                                ),
                              ],
                            ),
                            Divider(
                              color: Theme.of(
                                context,
                              ).colorScheme.outline.withValues(alpha: 0.3),
                            ),
                            // Display up to 4 reviews
                            if (storeModel.store!.reviews!.isNotEmpty)
                              ListView.separated(
                                padding: const EdgeInsets.only(top: 0),
                                separatorBuilder:
                                    (context, index) => Divider(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .outline
                                          .withValues(alpha: 0.3),
                                    ),
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount:
                                    storeModel.store!.reviews.length > 3
                                        ? 3
                                        : storeModel
                                            .store!
                                            .reviews
                                            .length, // Limit to 4 reviews
                                itemBuilder: (context, index) {
                                  final review =
                                      storeModel.store!.reviews[index];
                                  return ProductReviewBox(
                                    userName: review.userName ?? '',
                                    review: review.review ?? '',
                                    rating: double.parse(
                                      review.rating.toString() ?? '0',
                                    ),
                                    // imgUrl:
                                    //      'https://via.placeholder.com/55',
                                  );
                                },
                              ),
                            // Show "See All Reviews" if there are more than 4 reviews
                            // if (storeModel.store!.lastReviews!.length > 4)
                            Center(
                              child: TextButton(
                                onPressed: () {
                                  context.read<NavBarBloc>().add(
                                    ShopSelectTab(1),
                                  );
                                },
                                child: Text(
                                  '${Labels.seeAllReviews} (${storeModel.store!.reviews!.length})',
                                  style: TextStyle(
                                    fontSize: context.scaledFont(12),
                                    fontFamily: FontFamily.fontsPoppinsSemiBold,
                                    color:
                                        Theme.of(
                                          context,
                                        ).colorScheme.onSecondary,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
