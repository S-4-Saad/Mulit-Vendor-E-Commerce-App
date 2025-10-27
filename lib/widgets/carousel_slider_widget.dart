import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:speezu/widgets/widget_bloc/banner_slider_bloc/banner_slider_bloc.dart';
import 'package:speezu/widgets/widget_bloc/banner_slider_bloc/banner_slider_event.dart';
import '../core/assets/font_family.dart';
import 'image_gallery_viewer_widget.dart';
import 'widget_bloc/banner_slider_bloc/banner_slider_state.dart';

class EcommerceBanner extends StatefulWidget {
  const EcommerceBanner({
    super.key,
    required this.imageUrls,
    this.height = 200.0,
    this.autoPlay = true,
    this.autoPlayInterval = const Duration(seconds: 3),
    this.dotSize = 8.0,
    this.activeDotColor = Colors.blue,
    this.inactiveDotColor = Colors.grey,
    this.borderRadius = 12.0,
    this.titleText,
    this.isImageTap = false,
  });

  final List<String> imageUrls;
  final double height;
  final bool autoPlay;
  final Duration autoPlayInterval;
  final double dotSize;
  final Color activeDotColor;
  final Color inactiveDotColor;
  final double borderRadius;
  final List<String>? titleText;
  final bool? isImageTap;

  @override
  State<EcommerceBanner> createState() => _EcommerceBannerState();
}

class _EcommerceBannerState extends State<EcommerceBanner> {
  @override
  Widget build(BuildContext context) {
    final bool effectiveAutoPlay =
        widget.imageUrls.length > 1 && widget.autoPlay;

    return BlocBuilder<BannerSliderBloc, BannerSliderState>(
      builder: (context, state) {
        return Container(
          height: widget.height,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 16,
                offset: const Offset(0, 4),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Stack(
            children: [
              // Carousel Slider
              widget.imageUrls.length > 1
                  ? CarouselSlider(
                    options: CarouselOptions(
                      height: widget.height,
                      viewportFraction: 1.0,
                      enlargeCenterPage: true,

                      autoPlay: effectiveAutoPlay,
                      autoPlayInterval: widget.autoPlayInterval,
                      autoPlayCurve: Curves.easeInOutCubic,
                      onPageChanged: (index, reason) {
                        context.read<BannerSliderBloc>().add(
                          UpdateBannerIndexEvent(index),
                        );
                      },
                    ),
                    items:
                        widget.imageUrls.asMap().entries.map((entry) {
                          int index = entry.key;
                          String imageUrl = entry.value;
                          String? title =
                              widget.titleText != null &&
                                      index < widget.titleText!.length
                                  ? widget.titleText![index]
                                  : null;

                          return _buildBannerItem(
                            context: context,
                            imageUrl: imageUrl,
                            title: title,
                            index: index,
                          );
                        }).toList(),
                  )
                  : _buildBannerItem(
                    context: context,
                    imageUrl: widget.imageUrls[0],
                    title:
                        widget.titleText?.isNotEmpty == true
                            ? widget.titleText![0]
                            : null,
                    index: 0,
                  ),

              // Elegant dots positioned at bottom of image
              if (widget.imageUrls.length > 1)
                Positioned(
                  bottom: 10,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:
                        widget.imageUrls.asMap().entries.map((entry) {
                          bool isActive = state.currentBannerIndex == entry.key;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            width:
                                isActive ? widget.dotSize * 3 : widget.dotSize,
                            height: widget.dotSize,
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                widget.dotSize / 2,
                              ),
                              color:
                                  isActive
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context).colorScheme.primary
                                          .withValues(alpha: 0.3),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBannerItem({
    required BuildContext context,
    required String imageUrl,
    String? title,
    required int index,
  }) {
    return GestureDetector(
      onTap: () {
        if (widget.isImageTap == true) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => ImageGalleryViewer(
                    imageUrls: widget.imageUrls,
                    initialIndex: index,
                  ),
            ),
          );
        }
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Image with elegant loading state
            CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              placeholder:
                  (context, url) => Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.grey[200]!,
                          Colors.grey[100]!,
                          Colors.grey[200]!,
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                    ),
                    child: Center(
                      child: SpinKitThreeInOut(
                        color: Theme.of(context).colorScheme.primary,
                        size: 28,
                      ),
                    ),
                  ),
              errorWidget:
                  (context, url, error) => Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.grey[300]!, Colors.grey[200]!],
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.broken_image_rounded,
                        color: Colors.grey,
                        size: 44,
                      ),
                    ),
                  ),
            ),

            // Subtle gradient overlay for elegance
            if (title != null && title.isNotEmpty)
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.65),
                      ],
                      stops: const [0.6, 1.0],
                    ),
                  ),
                ),
              ),

            // Elegant title with refined styling
            if (title != null && title.isNotEmpty)
              Positioned(
                bottom: 40,
                left: 20,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.15),
                      width: 0.5,
                    ),
                  ),
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontFamily: FontFamily.fontsPoppinsBold,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
