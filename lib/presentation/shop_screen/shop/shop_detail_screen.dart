import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:speezu/core/assets/font_family.dart';
import 'package:speezu/core/utils/media_querry_extention.dart';
import 'package:speezu/widgets/image_gallery_viewer_widget.dart';

import '../../../core/utils/labels.dart';
import '../../../models/store_model.dart';
import '../../../widgets/app_cache_image.dart';
import '../../../widgets/business_hours_widget.dart';
import '../../../widgets/custom_action_container.dart';
import '../../../widgets/image_type_extention.dart';
import '../../../widgets/open_status_container.dart';
import '../../../widgets/product_review_box.dart';
import '../../../widgets/rating_display_widget.dart';
import '../../review/shop_review_screen.dart';

class ShopDetailScreen extends StatelessWidget {
  const ShopDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dummyStore = Store(
      ratting: 2.3,

      isDelivering: true,
      isOpen: true,
      openingTime: '10 Am',
      closingTime: "11 Pm",
      id: "1",
      name: "Blue Lagoon Cafe",
      image: "https://images.unsplash.com/photo-1555396273-367ea4eb4db5",
      moreImages: [
        "https://images.unsplash.com/photo-1551218808-94e220e084d2",
        "https://images.unsplash.com/photo-1546069901-ba9599a7e63c",
        "https://images.unsplash.com/photo-1504674900247-0877df9cc836",
      ],
      latitude: 31.5204,
      longitude: 74.3587,
      description:
          "A cozy cafe with a modern touch, our space blends warmth and style to create the perfect spot for relaxation, work, or socializing. With inviting interiors, soft lighting, and comfortable seating, the ambiance strikes a balance between homely comfort and contemporary elegance. We serve a variety of freshly prepared dishes made from high-quality ingredients, along with a wide selection of beverages ranging from aromatic coffees and soothing teas to refreshing juices and specialty drinks. Whether you’re dropping by for a quick coffee, enjoying a hearty meal, or spending time with friends, our cafe offers a welcoming atmosphere, delicious food, and friendly service that makes every visit memorable.",
      information:
          "A modern yet cozy cafe designed to cater to diverse customer needs. The cafe serves a wide range of fresh food and beverages, including breakfast, lunch, snacks, coffee, and specialty drinks, in a comfortable and aesthetically pleasing environment. With a focus on quality ingredients, customer satisfaction, and contemporary ambiance, it appeals to students, professionals, and families alike.",
      whatsappNumber: "+923001234567",
      primaryNumber: "+924211234567",
      secondaryNumber: "+923451234567",
      address: "123 Main Street, Lahore, Pakistan",
      reviews: [
        Review(
          username: "ali_khan",
          images: [
            "https://images.unsplash.com/photo-1551218808-94e220e084d2",
            "https://images.unsplash.com/photo-1546069901-ba9599a7e63c",
            "https://images.unsplash.com/photo-1504674900247-0877df9cc836",
          ],
          id: "r1",
          reviewerName: "Ali Khan",
          reviewerImage: "https://randomuser.me/api/portraits/men/1.jpg",
          reviewText: "Amazing ambiance and great coffee! Highly recommend.",
          rating: 4.5,
          date: DateTime.now().subtract(const Duration(days: 1)),
        ),
        Review(
          username: "sara_ahmed",
          images: [
            "https://images.unsplash.com/photo-1551218808-94e220e084d2",
            "https://images.unsplash.com/photo-1546069901-ba9599a7e63c",
            "https://images.unsplash.com/photo-1504674900247-0877df9cc836",
          ],
          id: "r2",
          reviewerName: "Sara Ahmed",
          reviewerImage: "https://randomuser.me/api/portraits/women/2.jpg",
          reviewText: "Food was delicious but the service was a bit slow.",
          rating: 3.8,
          date: DateTime.now().subtract(const Duration(days: 3)),
        ),
        Review(
          username: "sara_ahmed",
          images: [
            "https://images.unsplash.com/photo-1551218808-94e220e084d2",
            "https://images.unsplash.com/photo-1546069901-ba9599a7e63c",
            "https://images.unsplash.com/photo-1504674900247-0877df9cc836",
          ],
          id: "r2",
          reviewerName: "Sara Ahmed",
          reviewerImage: "https://randomuser.me/api/portraits/women/2.jpg",
          reviewText: "Food was delicious but the service was a bit slow.",
          rating: 3.8,
          date: DateTime.now().subtract(const Duration(days: 3)),
        ),
        Review(
          username: "ali_khan",
          images: [
            "https://images.unsplash.com/photo-1551218808-94e220e084d2",
            "https://images.unsplash.com/photo-1546069901-ba9599a7e63c",
            "https://images.unsplash.com/photo-1504674900247-0877df9cc836",
          ],
          id: "r1",
          reviewerName: "Ali Khan",
          reviewerImage: "https://randomuser.me/api/portraits/men/1.jpg",
          reviewText: "Amazing ambiance and great coffee! Highly recommend.",
          rating: 4.5,
          date: DateTime.now().subtract(const Duration(days: 1)),
        ),
        Review(
          username: "sara_ahmed",
          images: [
            "https://images.unsplash.com/photo-1551218808-94e220e084d2",
            "https://images.unsplash.com/photo-1546069901-ba9599a7e63c",
            "https://images.unsplash.com/photo-1504674900247-0877df9cc836",
          ],
          id: "r2",
          reviewerName: "Sara Ahmed",
          reviewerImage: "https://randomuser.me/api/portraits/women/2.jpg",
          reviewText: "Food was delicious but the service was a bit slow.",
          rating: 3.8,
          date: DateTime.now().subtract(const Duration(days: 3)),
        ),
        Review(
          username: "ali_khan",
          images: [
            "https://images.unsplash.com/photo-1551218808-94e220e084d2",
            "https://images.unsplash.com/photo-1546069901-ba9599a7e63c",
            "https://images.unsplash.com/photo-1504674900247-0877df9cc836",
          ],
          id: "r1",
          reviewerName: "Ali Khan",
          reviewerImage: "https://randomuser.me/api/portraits/men/1.jpg",
          reviewText: "Amazing ambiance and great coffee! Highly recommend.",
          rating: 4.5,
          date: DateTime.now().subtract(const Duration(days: 1)),
        ),
        Review(
          username: "sara_ahmed",
          images: [
            "https://images.unsplash.com/photo-1551218808-94e220e084d2",
            "https://images.unsplash.com/photo-1546069901-ba9599a7e63c",
            "https://images.unsplash.com/photo-1504674900247-0877df9cc836",
          ],
          id: "r2",
          reviewerName: "Sara Ahmed",
          reviewerImage: "https://randomuser.me/api/portraits/women/2.jpg",
          reviewText: "Food was delicious but the service was a bit slow.",
          rating: 3.8,
          date: DateTime.now().subtract(const Duration(days: 3)),
        ),
      ],
    );

    // 🔹 Dummy Data

    final List<Map<String, String>> featuredFoods = [
      {
        "name": "Cheese Burger",
        "image": "https://images.unsplash.com/photo-1550547660-d9450f859349",
      },
      {
        "name": "Pepperoni Pizza",
        "image": "https://images.unsplash.com/photo-1594007654729-407eedc4be3d",
      },
    ];
    final List<String> reviews = [
      "Amazing food, will order again!",
      "Loved the pizza 🍕",
      "Fast delivery and great taste 😋",
    ];

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
                imagePath: dummyStore.image,
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
                              dummyStore.name,
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
                                "4.5",
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
                          OpenStatusContainer(isOpened: true,isDelivering: true,),
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
                            child: Text(
                              '0,00 KM',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontFamily: FontFamily.fontsPoppinsSemiBold,
                                fontSize: context.scaledFont(10),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: context.heightPct(.02)),
                      Text(
                        dummyStore.description,
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
                          itemCount: dummyStore.moreImages.length,
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
                                          imageUrls: dummyStore.moreImages,
                                          initialIndex: index,
                                        ),
                                  ),
                                );
                                print(index);
                              },
                              radius: BorderRadius.circular(10),

                              imagePath: dummyStore.moreImages[index],
                              width: context.widthPct(.55),
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                      ),
                      SizedBox(height: context.heightPct(.01)),
                      BusinessHoursWidget(
                        openingTime: dummyStore.openingTime,
                        closingTime: dummyStore.closingTime,
                      ),

                      SizedBox(height: context.heightPct(.01)),
                      CustomActionContainer(
                        text:
                            Labels
                                .forMoreDetailsPleaseContactWithOurManagerOnWhatsApp,
                        icon: Icons.chat,
                        onTap: () {},
                      ),
                      SizedBox(height: context.heightPct(.01)),
                      CustomActionContainer(
                        text: dummyStore.address,
                        icon: Icons.directions,
                        onTap: () {},
                      ),
                      SizedBox(height: context.heightPct(.01)),
                      CustomActionContainer(
                        text:
                            '${dummyStore.primaryNumber}\n${dummyStore.secondaryNumber}',
                        icon: Icons.phone,
                        onTap: () {},
                      ),
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
                        dummyStore.information,
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
                                  '(${dummyStore.reviews.length ?? 0})',
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
                                      dummyStore.reviews?.isNotEmpty == true
                                          ? (dummyStore.reviews!
                                                      .map((r) => r.rating!)
                                                      .reduce((a, b) => a + b) /
                                                  dummyStore.reviews!.length)
                                              .toStringAsFixed(1)
                                          : '0.0',
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
                                          dummyStore.reviews?.isNotEmpty == true
                                              ? dummyStore.reviews!
                                                      .map((r) => r.rating!)
                                                      .reduce((a, b) => a + b) /
                                                  dummyStore.reviews!.length
                                              : 0,
                                      starSize: context.scaledFont(16),
                                    ),
                                    // Icon(Icons.arrow_forward_ios_rounded, size: 15.w),
                                  ],
                                ),
                                IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => ProductReviewsScreen(
                                              store: dummyStore,
                                            ),
                                      ),
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
                            if (dummyStore.reviews != null &&
                                dummyStore.reviews!.isNotEmpty)
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
                                    dummyStore.reviews!.length > 3
                                        ? 3
                                        : dummyStore
                                            .reviews!
                                            .length, // Limit to 4 reviews
                                itemBuilder: (context, index) {
                                  final review = dummyStore.reviews![index];
                                  return ProductReviewBox(
                                    userName: review.username ?? 'Anonymous',
                                    review:
                                        dummyStore.reviews[index].reviewText ??
                                        'No review',
                                    rating: review.rating?.toDouble() ?? 0.0,
                                    imgUrl:
                                        review.images?.isNotEmpty == true
                                            ? review.images!.first
                                            : 'https://via.placeholder.com/55',
                                  );
                                },
                              ),
                            // Show "See All Reviews" if there are more than 4 reviews
                            if (dummyStore.reviews != null &&
                                dummyStore.reviews!.length > 4)
                              Center(
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => ProductReviewsScreen(
                                              store: dummyStore,
                                            ),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    '${Labels.seeAllReviews} (${dummyStore.reviews.length ?? 0})',
                                    style: TextStyle(
                                      fontSize: context.scaledFont(12),
                                      fontFamily:
                                          FontFamily.fontsPoppinsSemiBold,
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

