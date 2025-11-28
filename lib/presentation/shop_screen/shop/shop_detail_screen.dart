import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speezu/core/assets/font_family.dart';
import 'package:speezu/core/utils/media_querry_extention.dart';
import 'package:speezu/models/store_detail_model.dart';
import 'package:speezu/presentation/nav_bar_screen/bloc/nav_bar_event.dart';
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
    // Clear previous data and load fresh
    if (widget.storeId != null) {
      context.read<ShopBloc>().add(
        LoadShopDetailEvent(storeId: widget.storeId!),
      );

      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          context.read<ShopBloc>().add(CalculateShopDistanceEvent());
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShopBloc, ShopState>(
      builder: (context, state) {
        // Always show loading shimmer when loading
        if (state.shopDetailStatus == ShopDetailStatus.loading) {
          return const ShopDetailShimmerWidget();
        }

        // Show error screen
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

        // Show content when success
        if (state.shopDetailStatus == ShopDetailStatus.success &&
            state.storeDetail != null) {
          return _buildStoreDetail(context, state.storeDetail!, state);
        }

        // Fallback
        return const ShopDetailShimmerWidget();
      },
    );
  }

  Widget _buildStoreDetail(
    BuildContext context,
    StoreDetailModel storeModel,
    ShopState state,
  ) {
    final theme = Theme.of(context);

    return  WillPopScope(
        onWillPop: () async {
          // 👇 Do whatever you want before leaving
          context.read<ShopBloc>().add(ClearStoreDetail());
          return true;},
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: CustomScrollView(
          slivers: [
            // App Bar with Image
            SliverAppBar(
              backgroundColor: theme.colorScheme.primary,
              expandedHeight: 300,
              elevation: 0,
              pinned: true,
              automaticallyImplyLeading: false,
              leading: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                    context.read<ShopBloc>().add(ClearStoreDetail());
                  },
                ),
              ),

              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    CustomImageView(
                      fit: BoxFit.cover,
                      imagePath: storeModel.store?.image ?? '',
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.1),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Store Name & Rating
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            storeModel.store?.name ?? '',
                            style: TextStyle(
                              fontFamily: FontFamily.fontsPoppinsSemiBold,
                              color: theme.colorScheme.onSecondary,
                              fontSize: context.scaledFont(20),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFFffbf00).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.star,
                                size: 16,
                                color: Color(0xFFffbf00),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                (storeModel.store?.rating ?? 0).toString(),
                                style: TextStyle(
                                  fontFamily: FontFamily.fontsPoppinsSemiBold,
                                  color: theme.colorScheme.onSecondary,
                                  fontSize: context.scaledFont(13),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Status & Distance
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        OpenStatusContainer(
                          isOpened: storeModel.store?.isOpen ?? false,
                          isDelivering: storeModel.store?.isDelivery ?? false,
                        ),
                        // Container(
                        //   padding: const EdgeInsets.symmetric(
                        //     horizontal: 12,
                        //     vertical: 4,
                        //   ),
                        //   decoration: BoxDecoration(
                        //     color: theme.colorScheme.onSecondary.withValues(
                        //       alpha: .4,
                        //     ),
                        //     borderRadius: BorderRadius.circular(8),
                        //   ),
                        //   child: Text(
                        //     '${state.shopDistance} ${Labels.km}',
                        //     style: TextStyle(
                        //       color: theme.colorScheme.onPrimary,
                        //       fontFamily: FontFamily.fontsPoppinsSemiBold,
                        //       fontSize: context.scaledFont(12),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Description
                    if (storeModel.store?.description?.isNotEmpty ?? false)
                      Text(
                        storeModel.store!.description!,
                        style: TextStyle(
                          fontFamily: FontFamily.fontsPoppinsRegular,
                          color: theme.colorScheme.onSecondary.withOpacity(0.7),
                          fontSize: context.scaledFont(13),
                          height: 1.5,
                        ),
                      ),

                    const SizedBox(height: 16),

                    // Image Gallery
                    if ((storeModel.store?.moreImages?.length ?? 0) > 0) ...[
                      Text(
                        Labels.gallery ?? 'Photos',
                        style: TextStyle(
                          fontFamily: FontFamily.fontsPoppinsSemiBold,
                          color: theme.colorScheme.onSecondary,
                          fontSize: context.scaledFont(16),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 160,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: storeModel.store?.moreImages?.length ?? 0,
                          separatorBuilder: (_, __) => const SizedBox(width: 10),
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => ImageGalleryViewer(
                                          imageUrls:
                                              storeModel.store?.moreImages ?? [],
                                          initialIndex: index,
                                        ),
                                  ),
                                );
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: CustomImageView(
                                  imagePath: storeModel.store!.moreImages![index],
                                  width: context.widthPct(.55),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Business Hours
                    BusinessHoursWidget(
                      openingTime: storeModel.store?.openingTime ?? '',
                      closingTime: storeModel.store?.closingTime ?? '',
                    ),

                    const SizedBox(height: 20),

                    // Reviews Section
                    if ((storeModel.store?.reviews.length ?? 0) > 0) ...[
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.onPrimary,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: theme.colorScheme.outline.withOpacity(0.2),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                context.read<NavBarBloc>().add(ShopSelectTab(1));
                              },
                              child: Row(
                                children: [
                                  Text(
                                    Labels.rattingAndReviews,
                                    style: TextStyle(
                                      fontSize: context.scaledFont(15),
                                      fontFamily: FontFamily.fontsPoppinsSemiBold,
                                      color: theme.colorScheme.onSecondary,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    '(${storeModel.store!.reviews!.length})',
                                    style: TextStyle(
                                      fontSize: context.scaledFont(13),
                                      color: theme.colorScheme.outline,
                                    ),
                                  ),
                                  const Spacer(),
                                  RatingDisplayWidget(
                                    rating:
                                        (storeModel.store?.rating ?? 0)
                                            .toDouble(),
                                    starSize: context.scaledFont(17),
                                  ),
                                  SizedBox(width: 5),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondary
                                        .withValues(alpha: .5),
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              color: theme.colorScheme.outline.withOpacity(0.2),
                              height: 24,
                            ),
                            ListView.separated(
                              padding: EdgeInsets.zero,
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount:
                                  storeModel.store!.reviews!.length > 3
                                      ? 3
                                      : storeModel.store!.reviews!.length,
                              separatorBuilder:
                                  (context, index) => Divider(
                                    color: theme.colorScheme.outline.withOpacity(
                                      0.1,
                                    ),
                                    height: 20,
                                  ),
                              itemBuilder: (context, index) {
                                final review = storeModel.store!.reviews![index];
                                return ProductReviewBox(
                                  userName: review.userName ?? '',
                                  review: review.review ?? '',
                                  rating: double.parse(review.rating.toString()),
                                );
                              },
                            ),
                            if (storeModel.store!.reviews!.length > 3)
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
                                      fontSize: context.scaledFont(13),
                                      fontFamily: FontFamily.fontsPoppinsSemiBold,
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
