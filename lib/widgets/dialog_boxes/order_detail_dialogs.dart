import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:speezu/core/utils/snackbar_helper.dart';
import 'package:speezu/presentation/order_details/bloc/order_details_bloc.dart';
import 'package:speezu/presentation/order_details/bloc/order_details_state.dart';

import '../../core/assets/font_family.dart';
import '../../core/utils/labels.dart';
import '../../presentation/order_details/bloc/order_details_event.dart';
import '../../presentation/settings/product_give_rating.dart';
import '../auth_loader.dart';
import '../custom_text_form_field.dart';

class OrderDetailDialogBoxes {
  static void showReviewDialog(int productId, BuildContext context) {
    final TextEditingController reasonController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    // Reset review status before showing dialog
    context.read<OrderDetailsBloc>().add(ResetReviewStatusEvent());
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Theme.of(context).colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Labels.shareYourThoughts,
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.onSecondary,
                      fontFamily: FontFamily.fontsPoppinsBold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  GiveProductRating(),
                  const SizedBox(height: 20),
                  Text(
                    '${Labels.giveReview}:',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.onSecondary,
                      fontFamily: FontFamily.fontsPoppinsRegular,
                    ),
                  ),
                  const SizedBox(height: 5),
                  CustomTextFormField(
                    textEditingController: reasonController,
                    maxLineLength: 3,
                    hint: Labels.shareYourExperience,
                    validator: (formValue) {
                      if (formValue == null || formValue.isEmpty) {
                        return Labels.yourVoiceMatters;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  BlocConsumer<OrderDetailsBloc, OrderDetailsState>(
                    builder: (context, state) {
                      if (state.addReviewStatus == AddReviewStatus.loading) {
                        return Center(child: AuthLoader());
                      }
                      return Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => Navigator.pop(dialogContext),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey.shade300,
                                foregroundColor: Colors.black87,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                Labels.close,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black87,
                                  fontFamily: FontFamily.fontsPoppinsRegular,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  context.read<OrderDetailsBloc>().add(
                                    SubmitReviewEvent(
                                      review: reasonController.text.trim(),
                                      orderId: productId.toString(),
                                    ),
                                  );
                                }

                                // call delete API
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                Labels.submit,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontFamily: FontFamily.fontsPoppinsRegular,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                    listener: (context, state) {
                      if (state.addReviewStatus == AddReviewStatus.success) {
                        // Close only the dialog — use the dialogContext, not parent context
                        // if (Navigator.of(dialogContext).canPop()) {
                        //   Navigator.of(dialogContext).pop();
                        // }
                        SnackBarHelper.showSuccess(
                          context,
                          state.message ?? 'Review submitted successfully',
                        );
                      } else if (state.addReviewStatus ==
                          AddReviewStatus.error) {
                        SnackBarHelper.showError(
                          context,
                          state.message ?? 'Something went wrong',
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
