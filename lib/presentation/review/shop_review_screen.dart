import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speezu/core/utils/labels.dart';
import 'package:speezu/core/utils/media_querry_extention.dart';
import 'package:speezu/presentation/shop_screen/shop/shop_detail_screen.dart';

import '../../core/assets/font_family.dart';
import '../../models/store_model.dart';
import '../../widgets/app_cache_image.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/image_gallery_viewer_widget.dart';
import '../../widgets/rating_display_widget.dart';
import '../../widgets/review_graph_widget.dart';

class ProductReviewsScreen extends StatelessWidget {
  final Store store; // Pass the product_detail to access its reviews

  const ProductReviewsScreen({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.sizeOf(context).height;


    // Calculate ReviewData dynamically
    final reviewData = calculateReviewData(store.reviews);

    return Scaffold(
      appBar: CustomAppBar(
        title: Labels.reviews,
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              ReviewGraphWidget(reviewData: reviewData),
              SizedBox(height: height * 0.015),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${store.reviews.length ?? 0} ${Labels.reviews}', // Update review count dynamically
                    style: TextStyle(
                      fontSize: context.scaledFont(13),
                      fontFamily: FontFamily.fontsPoppinsMedium,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                  ),
                  // Row(
                  //   children: [
                  //     SvgPicture.asset(AppIcons.filterIcon),
                  //     SizedBox(width: 5.w),
                  //     Text(
                  //       '${label.filter}: ',
                  //       style: TextStyle(
                  //         fontSize: 14.sp,
                  //         fontFamily: FontFamily.fontsPoppinsMedium,
                  //         color: AppColors.customTextColor,
                  //       ),
                  //     ),
                  //     Text(
                  //       'All Star',
                  //       style: TextStyle(
                  //         fontSize: 14.sp,
                  //         fontFamily: FontFamily.fontsPoppinsRegular,
                  //         color: AppColors.grey,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
              SizedBox(height: height * 0.015),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).colorScheme.onPrimary,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: store.reviews == null || store.reviews!.isEmpty
                    ?Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.rate_review_outlined,
                        size: 55,
                        color:Theme.of(context).colorScheme.outline.withOpacity(0.5),
                      ),
                      SizedBox(height: 5),
                      Text(
                        Labels.noReviewsYet,
                        style: TextStyle(
                          fontSize: context.scaledFont(13),
                          fontWeight: FontWeight.bold,
                          fontFamily: FontFamily.fontsPoppinsRegular,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),

                    ],
                  ),
                )

                    : ListView.builder(
                  itemCount: store.reviews!.length, // Use actual review count
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final review = store.reviews![index];
                    return ProductReviewWidget(
                      backgroundColor: Theme.of(context).colorScheme.onPrimary,
                      imagesUrl: review.images?.isNotEmpty == true
                          ? review.images!
                          : [], // Use actual images from review
                      review: review.reviewText ?? 'No review', // Use actual review text
                      date:
                      review.date.toString() ??
                          DateTime.now().toString(), // Use actual date if available
                      userName: review.username ?? 'Anonymous', // Use actual username
                      rating: review.rating?.toDouble() ?? 0.0, // Use actual rating
                      expandable: false,
                      // onReply: () {},
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  ReviewData calculateReviewData(List<Review>? reviews) {
    int oneStar = 0;
    int twoStar = 0;
    int threeStar = 0;
    int fourStar = 0;
    int fiveStar = 0;

    if (reviews == null || reviews.isEmpty) {
      return ReviewData(
        oneStar: 0,
        twoStar: 0,
        threeStar: 0,
        fourStar: 0,
        fiveStar: 0,
      );
    }

    for (var review in reviews) {
      final rating = review.rating?.toInt();
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
  final List<String>? imagesUrl;
  final String review;
  final String date;
  final String userName;
  final double rating;
  final bool expandable; // Toggle for expandable review text
  final int maxImages; // Maximum number of images to display
  // final VoidCallback? onReply; // Callback for reply action
  final VoidCallback? onReport; // Callback for report action
  final Color? backgroundColor; // Custom background color
  final Color? borderColor; // Custom border color
  final EdgeInsets? padding; // Custom padding

  const ProductReviewWidget({
    super.key,
    required this.imagesUrl,
    required this.review,
    required this.date,
    required this.userName,
    required this.rating,
    this.expandable = false,
    this.maxImages = 3,
    // this.onReply,
    this.onReport,
    this.backgroundColor,
    this.borderColor,
    this.padding,
  }) : assert(rating >= 0 && rating <= 5, 'Rating must be between 0 and 5');

  @override
  Widget build(BuildContext context) {
    // Format date dynamically
    final DateTime parsedDate = DateTime.parse(date);
    final String formattedDate = DateFormat('dd MMM, yyyy').format(parsedDate);

    return Semantics(
      label: 'Product review by $userName with rating $rating out of 5',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Rating and Date Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RatingDisplayWidget(
                rating: rating,
                starSize: 17,
              ),
              Text(
                formattedDate,
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
          ExpandableText(text: review,style: TextStyle(
            fontSize: context.scaledFont(12),
            fontFamily: FontFamily.fontsPoppinsRegular,
            color: Theme.of(context).colorScheme.onSecondary,
          ), ),
          // Text(
          //   review,
          //   textAlign: TextAlign.justify,
          //   style: TextStyle(
          //     fontSize: 13.sp,
          //     fontFamily: FontFamily.fontsPoppinsRegular,
          //     color: AppColors.black,
          //   ),
          // ),
          // Images (if any)
          if (imagesUrl != null && imagesUrl!.isNotEmpty) ...[
            SizedBox(height: 10),
            Wrap(
              spacing: 5,
              runSpacing: 5,
              children: imagesUrl!.asMap().entries.map((entry) {
                final index = entry.key;
                final url = entry.value;
                return GestureDetector(
                  onTap: () {
                    // Open the image viewer with all images, starting at the tapped image
                    final fullImageUrls = imagesUrl!.map((img) => img).toList();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ImageGalleryViewer(
                          imageUrls: fullImageUrls,
                          initialIndex: index,
                        ),
                      ),
                    );
                  },
                  child: AppCacheImage(
                    imageUrl: url,
                    width: context.heightPct(.08),
                    height: context.heightPct(.08),
                    round: 4,
                  ),
                );
              }).toList(),
            ),
          ],
          SizedBox(height: 10),
          // Action Buttons (Optional)
          // if (onReply != null || onReport != null)
          //   Row(
          //     children: [
          //       if (onReply != null)
          //         GestureDetector(
          //           onTap: onReply,
          //           child: Text(
          //             'Reply',
          //             style: TextStyle(
          //               fontSize: 12.sp,
          //               fontFamily: FontFamily.fontsPoppinsSemiBold,
          //               color: AppColors.customThemeColor,
          //             ),
          //           ),
          //         ),
          //       if (onReply != null && onReport != null) const Spacer(),
          //       if (onReport != null)
          //         GestureDetector(
          //           onTap: onReport,
          //           child: Text(
          //             'Report',
          //             style: TextStyle(
          //               fontSize: 12.sp,
          //               fontFamily: FontFamily.fontsPoppinsSemiBold,
          //               color: AppColors.grey,
          //             ),
          //           ),
          //         ),
          //     ],
          //   ),
          Divider(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
            thickness: 1,
          ),
        ],
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
                  padding:
                  EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () =>
                    context.read<ExpandableTextCubit>().toggle(),
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
