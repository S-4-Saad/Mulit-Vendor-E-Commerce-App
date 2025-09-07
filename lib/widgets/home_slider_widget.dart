import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:speezu/core/utils/media_querry_extention.dart';
import '../models/slide.dart';

class HomeSliderWidget extends StatefulWidget {
  final List<Slides>? slides;

  @override
  State<HomeSliderWidget> createState() => _HomeSliderWidgetState();

  const HomeSliderWidget({super.key, this.slides});
}

class _HomeSliderWidgetState extends State<HomeSliderWidget> {
  int _current = 0;
  
  Widget _buildImageWidget(String imageUrl) {
    return Image.network(
      imageUrl,
      height: 140,
      width: double.infinity,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          width: double.infinity,
          height: 140,
          color: Colors.grey[300],
          child: Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) => Container(
        width: double.infinity,
        height: 140,
        color: Colors.grey[300],
        child: const Center(
          child: Icon(Icons.error),
        ),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    if (widget.slides == null || widget.slides!.isEmpty) {
      return Container(
        height: 180,
        margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text('No slides available'),
        ),
      );
    }

    return Stack(
      // alignment: _alignmentDirectional ??
      //     Helper.getAlignmentDirectional(
      //         widget.slides.elementAt(0).textPosition),
      fit: StackFit.passthrough,
      children: <Widget>[
        CarouselSlider(
          options: CarouselOptions(
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 5),
            height: 180,
            viewportFraction: 1.0,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
                // _alignmentDirectional = Helper.getAlignmentDirectional(
                //     widget.slides.elementAt(index).textPosition);
              });
            },
          ),
          items: widget.slides!.map((Slides slide) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  margin: const EdgeInsets.symmetric(
                      vertical: 20, horizontal: 20),
                  height: 140,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Theme.of(context)
                              .focusColor
                              .withValues(alpha: 0.15),
                          blurRadius: 15,
                          offset: const Offset(0, 2)),
                    ],
                  ),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius:
                        const BorderRadius.all(Radius.circular(10)),
                        child: slide.media?.isNotEmpty == true 
                          ? _buildImageWidget(slide.media![0].url ?? '')
                          : Container(
                          height: 140,
                          width: double.infinity,
                              color: Colors.grey[300],
                              child: const Center(
                                child: Icon(Icons.image_not_supported),
                              ),
                        ),
                      ),
                      // Container(
                      //   // alignment: Helper.getAlignmentDirectional(
                      //   //     slide.textPosition),
                      //   width: double.infinity,
                      //   padding:
                      //   const EdgeInsets.symmetric(horizontal: 20),
                      //   child: SizedBox(
                      //     width: context.widthPct(.5),
                      //     child: Column(
                      //       crossAxisAlignment:
                      //       CrossAxisAlignment.stretch,
                      //       mainAxisSize: MainAxisSize.max,
                      //       mainAxisAlignment: MainAxisAlignment.center,
                      //       children: <Widget>[
                      //         if (slide.text != null && slide.text != '')
                      //           Text(
                      //             slide.text??'',
                      //             // style: Theme.of(context)
                      //             //     .textTheme
                      //             //     .headline6
                      //             //     .merge(
                      //             //   TextStyle(
                      //             //     fontSize: 14,
                      //             //     height: 1,
                      //             //     // color: Helper.of(context)
                      //             //     //     .getColorFromHex(
                      //             //     //     slide.textColor),
                      //             //   ),
                      //             // ),
                      //             textAlign: TextAlign.center,
                      //             overflow: TextOverflow.fade,
                      //             maxLines: 3,
                      //           ),
                      //         if (slide.button != null &&
                      //             slide.button != '')
                      //           MaterialButton(
                      //             elevation: 0,
                      //             focusElevation: 0,
                      //             highlightElevation: 0,
                      //             onPressed: () {
                      //               // if (slide.restaurant != null) {
                      //               //   Navigator.of(context).pushNamed(
                      //               //       '/Details',
                      //               //       arguments: RouteArgument(
                      //               //           id: '0',
                      //               //           param: slide.restaurant.id,
                      //               //           heroTag: 'home_slide'));
                      //               // } else if (slide.food != null) {
                      //               //   Navigator.of(context).pushNamed(
                      //               //       '/Food',
                      //               //       arguments: RouteArgument(
                      //               //           id: slide.food.id,
                      //               //           heroTag: 'home_slide'));
                      //               // }
                      //             },
                      //             padding:
                      //             const EdgeInsets.symmetric(vertical: 5),
                      //             // color: Helper.of(context)
                      //             //     .getColorFromHex(slide.buttonColor),
                      //             shape: const StadiumBorder(),
                      //             child: Text(
                      //               slide.button??'',
                      //               textAlign: TextAlign.start,
                      //               style: TextStyle(
                      //                   color: Theme.of(context)
                      //                       .primaryColor),
                      //             ),
                      //           ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                );
              },
            );
          }).toList(),
        ),
        // Positioned(
        //   bottom: 0,
        //   left: 0,
        //   right: 0,
        //   child: Container(
        //     margin: const EdgeInsets.symmetric(vertical: 22, horizontal: 42),
        //   child: Row(
        //     mainAxisSize: MainAxisSize.min,
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: widget.slides!.asMap().entries.map((entry) {
        //         int index = entry.key;
        //       return Container(
        //         width: 20.0,
        //         height: 3.0,
        //           margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
        //         decoration: BoxDecoration(
        //             borderRadius: BorderRadius.all(Radius.circular(8)),
        //             color: _current == index
        //                 ? Theme.of(context).primaryColor
        //                 : Theme.of(context).primaryColor.withOpacity(0.3),
        //         ),
        //       );
        //     }).toList(),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
