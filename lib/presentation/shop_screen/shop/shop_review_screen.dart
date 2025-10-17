import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speezu/core/utils/labels.dart';
import 'package:speezu/core/utils/media_querry_extention.dart';
import 'package:speezu/models/store_reviews_model.dart';
import 'package:speezu/presentation/shop_screen/bloc/shop_bloc.dart';
import 'package:speezu/presentation/shop_screen/bloc/shop_event.dart';
import 'package:speezu/presentation/shop_screen/shop/shop_detail_screen.dart';

import '../../../core/assets/font_family.dart';
import '../../../models/store_model.dart';
import '../../../widgets/app_cache_image.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/image_gallery_viewer_widget.dart';
import '../../../widgets/rating_display_widget.dart';
import '../../../widgets/review_graph_widget.dart';
import '../../../widgets/shimmer/shimmer_reviews.dart';
import '../bloc/shop_state.dart';

class ProductReviewsScreen extends StatefulWidget {
  final int storeId; // Pass the product_detail to access its reviews

  const ProductReviewsScreen({super.key, required this.storeId});

  @override
  State<ProductReviewsScreen> createState() => _ProductReviewsScreenState();
}

class _ProductReviewsScreenState extends State<ProductReviewsScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch reviews for the given product_detail
    context.read<ShopBloc>().add(
      FetchShopReviewsEvent(storeId: widget.storeId),
    );
  }

  Widget build(BuildContext context) {
    var height = MediaQuery.sizeOf(context).height;

    // Calculate ReviewData dynamically

    return Scaffold(
    
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: BlocBuilder<ShopBloc, ShopState>(
            builder: (context, state) {
              final reviewData = calculateReviewData(
                state.shopReviewsModel?.reviews,
              );
              if(state.shopReviewsStatus==ShopReviewsStatus.loading){
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(0),
                    child: ShimmerReviews(),
                  ),
                );
              }
              return Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  children: [
                    ReviewGraphWidget(reviewData: reviewData),
                    SizedBox(height: height * 0.015),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                      child:
                          state.shopReviewsModel?.reviews == null ||
                                  state.shopReviewsModel!.reviews!.isEmpty
                              ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.rate_review_outlined,
                                      size: 55,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.outline.withOpacity(0.5),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      Labels.noReviewsYet,
                                      style: TextStyle(
                                        fontSize: context.scaledFont(13),
                                        fontWeight: FontWeight.bold,
                                        fontFamily:
                                            FontFamily.fontsPoppinsRegular,
                                        color:
                                            Theme.of(context).colorScheme.outline,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                              : ListView.separated(
                            separatorBuilder: (context, index) => Divider(
                              color: Theme.of(context).colorScheme.onSecondary.withValues(alpha: .3),
                            ),
                            itemCount: state.shopReviewsModel?.reviews?.length ?? 0,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final review = state.shopReviewsModel!.reviews![index];
        
                              // Parse rating safely
                              final double rating = double.tryParse(review.rating ?? '0') ?? 0.0;
        
                              // Format date safely
                              String formatDate(String? dateString) {
                                if (dateString == null || dateString.isEmpty) return '';
                                try {
                                  final dateTime = DateTime.parse(dateString);
                                  return DateFormat("dd MMM, yyyy").format(dateTime);
                                } catch (e) {
                                  return '';
                                }
                              }
        
                              return ProductReviewWidget(
                                review: review.reviewText ?? 'No review',
                                date: formatDate(review.createdAt),
                                userName: review.userName ?? 'Anonymous',
                                rating: rating.clamp(0, 5), // keeps rating between 0 and 5
                                expandable: false,
                              );
                            },
                          ),
        
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  ReviewData calculateReviewData(List<Reviews>? storeReviewsList) {
    int oneStar = 0;
    int twoStar = 0;
    int threeStar = 0;
    int fourStar = 0;
    int fiveStar = 0;

    // Handle null or empty list
    if (storeReviewsList == null || storeReviewsList.isEmpty) {
      return ReviewData(
        oneStar: 0,
        twoStar: 0,
        threeStar: 0,
        fourStar: 0,
        fiveStar: 0,
      );
    }

    // Loop through each review and parse its rating
    for (var review in storeReviewsList) {
      final ratingString = review.rating?.trim();
      final rating = int.tryParse(ratingString ?? '');

      switch (rating) {
        case 1:
          oneStar++;
          break;
        case 2:
          twoStar++;
          break;
        case 3:
          threeStar++;
          break;
        case 4:
          fourStar++;
          break;
        case 5:
          fiveStar++;
          break;
        default:
          // ignore invalid or null ratings
          break;
      }
    }

    return ReviewData(
      oneStar: oneStar,
      twoStar: twoStar,
      threeStar: threeStar,
      fourStar: fourStar,
      fiveStar: fiveStar,
    );
  }
}

class ProductReviewWidget extends StatelessWidget {
  // final List<String>? imagesUrl;
  final String review;
  final String date;
  final String userName;
  final double rating;
  final bool expandable; // Toggle for expandable review text
  final EdgeInsets? padding; // Custom padding

  const ProductReviewWidget({
    super.key,
    // required this.imagesUrl,
    required this.review,
    required this.date,
    required this.userName,
    required this.rating,
    this.expandable = false,
    this.padding,
  }) : assert(rating >= 0 && rating <= 5, 'Rating must be between 0 and 5');

  @override
  Widget build(BuildContext context) {


    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Semantics(
        label: 'Product review by $userName with rating $rating out of 5',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Rating and Date Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RatingDisplayWidget(rating: rating, starSize: 17),
                Text(
                  date,

                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: FontFamily.fontsPoppinsRegular,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ],
            ),
            SizedBox(height: 3),
            // User Name
            Text(
              userName,
              style: TextStyle(
                fontSize: context.scaledFont(12),
                fontFamily: FontFamily.fontsPoppinsMedium,
                color: Theme.of(context).colorScheme.onSecondary,
              ),
              semanticsLabel: 'Reviewed by $userName',
            ),
            SizedBox(height: 4),
            // Review Text (Expandable or Truncated)
            ExpandableText(
              text: review,
              style: TextStyle(
                fontSize: context.scaledFont(12),
                fontFamily: FontFamily.fontsPoppinsRegular,
                color: Theme.of(context).colorScheme.onSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ExpandableText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final int trimLines;

  const ExpandableText({
    Key? key,
    required this.text,
    this.style,
    this.trimLines = 3,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool hasOverflow = text.length > 150;
    final String firstHalf = hasOverflow ? text.substring(0, 150) : text;
    final String secondHalf = hasOverflow ? text.substring(150) : "";

    return BlocProvider(
      create: (_) => ExpandableTextCubit(),
      child: BlocBuilder<ExpandableTextCubit, bool>(
        builder: (context, isExpanded) {
          return secondHalf.isEmpty
              ? Text(text, style: style, textAlign: TextAlign.justify)
              : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isExpanded ? text : "$firstHalf...",
                    style: style,
                    // textAlign: TextAlign.justify,
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: 10,
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed:
                        () => context.read<ExpandableTextCubit>().toggle(),
                    child: Text(
                      isExpanded ? 'Show less' : 'Read more',
                      style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              );
        },
      ),
    );
  }
}

class ExpandableTextCubit extends Cubit<bool> {
  ExpandableTextCubit() : super(false);

  void toggle() => emit(!state);
}
