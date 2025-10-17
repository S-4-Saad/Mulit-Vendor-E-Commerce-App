import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:speezu/core/utils/media_querry_extention.dart';

class ShimmerReviews extends StatelessWidget {
  const ShimmerReviews({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          // Rating graph shimmer
          Container(
            width: double.infinity,
            height: 200,
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).colorScheme.onPrimary,
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Shimmer.fromColors(
              baseColor: Theme.of(context).colorScheme.outline.withOpacity(0.05),
              highlightColor: Theme.of(context).colorScheme.outline.withOpacity(0.1),
              child: Column(
                children: List.generate(5, (index) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      Container(
                        width: 15,
                        height: 15,
                        color: Colors.white,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          height: 10,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                )),
              ),
            ),
          ),
          SizedBox(height: 15),
          // Reviews list shimmer
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).colorScheme.onPrimary,
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Shimmer.fromColors(
              baseColor: Theme.of(context).colorScheme.outline.withOpacity(0.05),
              highlightColor: Theme.of(context).colorScheme.outline.withOpacity(0.1),
              child: Column(
                children: List.generate(
                  4,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Rating stars
                        Row(
                          children: List.generate(
                            5,
                            (starIndex) => Padding(
                              padding: const EdgeInsets.only(right: 4.0),
                              child: Container(
                                width: 15,
                                height: 15,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        // Username
                        Container(
                          width: context.widthPct(.3) ,
                          height: 10,
                          color: Colors.white,
                        ),
                        SizedBox(height: 8),
                        // Review text lines
                        Column(
                          children: List.generate(
                            2,
                            (lineIndex) => Padding(
                              padding: const EdgeInsets.only(bottom: 4.0),
                              child: Container(
                                width: double.infinity,
                                height: 10,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        if (index != 3) Divider(color: Colors.white, height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
