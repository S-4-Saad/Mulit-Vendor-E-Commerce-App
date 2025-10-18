import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speezu/core/utils/snackbar_helper.dart';
import 'package:speezu/presentation/orders/bloc/order_state.dart';
import 'package:speezu/presentation/orders/bloc/orders_bloc.dart';
import 'package:speezu/widgets/auth_loader.dart';

import '../../core/assets/font_family.dart';
import '../../core/utils/labels.dart';
import '../../presentation/orders/bloc/orders_event.dart';
import '../custom_text_form_field.dart';

class OrdersDialogBoxes {
  static void showDeleteDialog(int orderId, BuildContext context) {
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
                    Labels.cancelOrder,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.red,
                      fontFamily: FontFamily.fontsPoppinsBold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: Text(
                      "${Labels.areYouSureYouWantToCancelThisOrder}\n #$orderId?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(context).colorScheme.onSecondary,
                        fontFamily: FontFamily.fontsPoppinsRegular,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '${Labels.reason}:',
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
                    hint: Labels.reasonForCancellingTheOrder,
                    validator: (formValue) {
                      if (formValue == null || formValue.isEmpty) {
                        return 'Please provide a reason.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  BlocBuilder<OrdersBloc, OrderState>(
                    builder: (context, state) {
                      if (state.cancelOrderStatus ==
                          CancelOrderStatus.loading) {
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
                                  context.read<OrdersBloc>().add(
                                    CancelOrderEvent(
context: context,
                                      orderId: orderId.toString(),
                                      reason: reasonController.text,
                                    ),
                                  );
                                }

                                // call delete API
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
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
