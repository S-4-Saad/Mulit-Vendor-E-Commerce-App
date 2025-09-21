import 'package:flutter/material.dart';

import '../../core/assets/font_family.dart';
import '../../core/utils/labels.dart';
import '../../presentation/settings/product_give_rating.dart';
import '../custom_text_form_field.dart';

class OrderDetailDialogBoxes {
  static void showReviewDialog(int productId, BuildContext context) {
    final TextEditingController reasonController = TextEditingController();
    final formKey = GlobalKey<FormState>();
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
                  Row(
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
                          child:  Text(
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
                              print('object');
                            }

                            // call delete API
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child:  Text(
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