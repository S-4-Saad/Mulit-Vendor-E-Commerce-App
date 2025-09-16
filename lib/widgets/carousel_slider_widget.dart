import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:speezu/widgets/widget_bloc/banner_slider_bloc/banner_slider_bloc.dart';
import 'package:speezu/widgets/widget_bloc/banner_slider_bloc/banner_slider_event.dart';
import 'image_gallery_viewer_widget.dart';
import 'widget_bloc/banner_slider_bloc/banner_slider_state.dart';
class EcommerceBanner extends StatefulWidget {
  const EcommerceBanner({
    super.key,
    required this.imageUrls,
    this.height = 200.0, // Default height
    this.autoPlay =
    true, // Auto-scroll through images (ignored if only one image)
    this.autoPlayInterval = const Duration(seconds: 3),
    this.dotSize = 8.0, // Size of pagination dots
    this.activeDotColor = Colors.blue, // Color of active dot
    this.inactiveDotColor = Colors.grey, // Color of inactive dots
    this.borderRadius = 10.0, // Corner radius of the banner
    this.titleText, // Optional title text for the banner
    this.isImageTap = false, // Callback when an image is tapped
  });

  final List<String> imageUrls; // List of image URLs to display
  final double height; // Height of the banner
  final bool autoPlay; // Whether to auto-scroll (overridden if only one image)
  final Duration autoPlayInterval; // Interval for auto-scrolling
  final double dotSize; // Size of pagination dots
  final Color activeDotColor; // Color for the active dot
  final Color inactiveDotColor; // Color for inactive dots
  final double borderRadius; // Corner radius of the banner
  final List<String>? titleText;
  final bool? isImageTap; // Callback when an image is tapped

  @override
  State<EcommerceBanner> createState() => _EcommerceBannerState();
}

class _EcommerceBannerState extends State<EcommerceBanner> {
  @override
  Widget build(BuildContext context) {
    // Disable autoPlay if there's only one image
    final bool effectiveAutoPlay =
        widget.imageUrls.length > 1 && widget.autoPlay;

    return BlocBuilder<BannerSliderBloc,BannerSliderState>(
      builder: (context, state) {
        return Column(
          children: [
            // Carousel Slider for images
            widget.imageUrls.length > 1
                ? CarouselSlider(
              options: CarouselOptions(
                height: widget.height,
                viewportFraction: 1.0, // Full width of the screen
                enlargeCenterPage: false, // No scaling effect
                autoPlay:
                effectiveAutoPlay, // Auto-play only if more than one image
                autoPlayInterval: widget.autoPlayInterval,
                onPageChanged: (index, reason) {
                  context
                      .read<BannerSliderBloc>()
                      .add(UpdateBannerIndexEvent(index));
                },
              ),
              items: widget.imageUrls.asMap().entries.map((entry) {
                int index = entry.key;
                String imageUrl = entry.value;
                String? title = widget.titleText != null &&
                    index < widget.titleText!.length
                    ? widget.titleText![index]
                    : null;

                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.circular(widget.borderRadius),
                      ),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(
                                widget.borderRadius),
                            child: GestureDetector(
                              onTap: () {
                                widget.isImageTap == true
                                    ? Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ImageGalleryViewer(
                                            imageUrls:
                                            widget.imageUrls,
                                            initialIndex: index,
                                          ),
                                    ))
                                    : print(
                                    'object'); // Callback when an image is tapped
                              },
                              child: CachedNetworkImage(
                                imageUrl: imageUrl,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: widget.height,
                                color: Colors.black.withValues(
                                    alpha: 0.9), // Overlay for contrast
                                colorBlendMode: BlendMode.dstATop,
                                placeholder: (context, url) => Center(
                                  child: SpinKitThreeInOut(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary,
                                    size: 25,
                                  ),
                                ), // Loading indicator
                                errorWidget: (context, url, error) =>
                                    Center(
                                      child: Icon(
                                        Icons.error_outline,
                                        color: Colors.red,
                                        size: 40,
                                      ),
                                    ), // Error icon
                              ),
                            ),
                          ),

                          // Show title for this image
                          // if (title != null && title.isNotEmpty)
                          //   Positioned(
                          //     bottom: 10.h,
                          //     left: 10.w,
                          //     child: Text(
                          //       title,
                          //       style: TextStyle(
                          //         color: Colors.white,
                          //         fontSize: 15.sp,
                          //         fontFamily: FontFamily.fontsPoppinsBold,
                          //         shadows: [
                          //           Shadow(
                          //             offset: const Offset(
                          //                 1.5, 1.5), // X and Y offset
                          //             blurRadius:
                          //                 4.0, // Softness of the shadow
                          //             color: Colors.black.withValues(
                          //                 alpha: 0.7), // Shadow color
                          //           ),
                          //         ],
                          //       ),
                          //     ),
                          //   ),
                        ],
                      ),
                    );
                  },
                );
              }).toList(),
            )
                : Container(
              height: widget.height,
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                borderRadius:
                BorderRadius.circular(widget.borderRadius),
              ),
              child: GestureDetector(
                onTap: () {
                  widget.isImageTap == true
                      ? Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ImageGalleryViewer(
                            imageUrls: widget.imageUrls),
                      ))
                      : print(
                      'object'); // Callback when an image is tapped
                },
                child: ClipRRect(
                  borderRadius:
                  BorderRadius.circular(widget.borderRadius),
                  child: CachedNetworkImage(
                    imageUrl: widget.imageUrls[0],
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: widget.height,
                    color: Colors.black.withValues(alpha: 0.9),
                    colorBlendMode: BlendMode.dstATop,
                    placeholder: (context, url) => Center(
                      child: SpinKitThreeInOut(
                        color: Theme.of(context).colorScheme.primary,
                        size: 25,
                      ),
                    ),
                    errorWidget: (context, url, error) => Center(
                      child: Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 40,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Pagination dots (only show if there’s more than one image)
            if (widget.imageUrls.length > 1)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: widget.imageUrls.asMap().entries.map((entry) {
                  return Container(
                    width: widget.dotSize,
                    height: widget.dotSize,
                    margin:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: state.currentBannerIndex == entry.key
                          ? widget.activeDotColor
                          : widget.inactiveDotColor,
                    ),
                  );
                }).toList(),
              ),
          ],
        );
      },
    );
  }
}
