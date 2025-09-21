import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:speezu/core/utils/labels.dart';
import 'package:speezu/presentation/order_details/bloc/order_details_event.dart';
import 'package:speezu/presentation/order_details/bloc/order_details_state.dart';
import '../../core/assets/font_family.dart';
import '../order_details/bloc/order_details_bloc.dart';

class GiveProductRating extends StatelessWidget {
  final ValueChanged<int>? onRatingChanged;

  const GiveProductRating({super.key, this.onRatingChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary,
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.4),
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Text(
            Labels.giveRating,
            style: TextStyle(
              fontFamily: FontFamily.fontsPoppinsMedium,
              fontSize: 14,
              color: Theme.of(context).colorScheme.onSecondary,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: BlocBuilder<OrderDetailsBloc, OrderDetailsState>(
              builder: (context, state) {
                return RatingBar.builder(
                  initialRating:
                      state.rating.toDouble(), // Convert int to double
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 5,
                  itemSize: 25,
                  itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                  itemBuilder:
                      (context, _) =>
                          Icon(Icons.star, color: Color(0xffFFCE31)),
                  unratedColor: Colors.grey.withValues(alpha: 0.5),
                  onRatingUpdate: (rating) {
                    final int intRating = rating.round();
                    context.read<OrderDetailsBloc>().add(
                      UpdateRating(intRating),
                    );
                    onRatingChanged?.call(intRating);
                  },
                );
              },
            ),
          ),
          // IconButton(onPressed: (){
          //   print("Rating :${context.read<ReviewBloc>().state.rating}");
          // }, icon: Icon(Icons.add))
        ],
      ),
    );
  }
}
