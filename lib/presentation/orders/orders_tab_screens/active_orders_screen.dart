import 'package:flutter/material.dart';
import 'package:speezu/core/assets/font_family.dart';
import 'package:speezu/core/utils/currency_icon.dart';
import 'package:speezu/widgets/custom_text_form_field.dart';

import '../../../core/utils/labels.dart';

class ActiveOrdersScreen extends StatelessWidget {
  const ActiveOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            OrderCard(
              status: "Active",
              orderId: "32",
              customerName: "John Doe",
              paymentMethod: "Cash on Delivery",
              amount: "437.00",
              dateTime: "25th Dec, 2023 | 02:30 PM",
              onViewDetails: () {
                // Navigate to details
              },
              onCancel: () {
                // Cancel logic
              },
            ),
            OrderCard(
              status: "Canceled",
              orderId: "32",
              customerName: "John Doe",
              paymentMethod: "Cash on Delivery",
              amount: "437.00",
              dateTime: "25th Dec, 2023 | 02:30 PM",
              onViewDetails: () {
                // Navigate to details
              },
              onCancel: () {
                // Cancel logic
              },
            ),
            OrderCard(
              status: "Completed",
              orderId: "32",
              customerName: "John Doe",
              paymentMethod: "Cash on Delivery",
              amount: "437.00",
              dateTime: "25th Dec, 2023 | 02:30 PM",
              onViewDetails: () {
                // Navigate to details
              },
              onCancel: () {
                // Cancel logic
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CustomMiniElevatedButton extends StatelessWidget {
  const CustomMiniElevatedButton({
    super.key,
    required this.title,
    required this.onPressed,
    required this.backgroundColor,
    required this.textColor,
  });
  final String title;
  final VoidCallback onPressed;
  final Color backgroundColor;

  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: Size(0, 30),
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),

          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        ),

        onPressed: onPressed,
        child: Text(
          title,
          style: TextStyle(
            color: textColor,
            fontFamily: FontFamily.fontsPoppinsRegular,
          ),
        ),
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final String status; // Active, Completed, Canceled
  final String orderId;
  final String customerName;
  final String paymentMethod;
  final String amount;
  final String dateTime;
  final VoidCallback onViewDetails;
  final VoidCallback onCancel;

  const OrderCard({
    super.key,
    required this.status,
    required this.orderId,
    required this.customerName,
    required this.paymentMethod,
    required this.amount,
    required this.dateTime,
    required this.onViewDetails,
    required this.onCancel,
  });

  Color _getStatusColor() {
    switch (status.toLowerCase()) {
      case "active":
        return Colors.blue.shade900;
      case "completed":
        return Colors.green.shade700;
      case "canceled":
        return Colors.red.shade700;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          clipBehavior: Clip.hardEdge,
          margin: const EdgeInsets.symmetric(horizontal: 10.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onPrimary,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(
                context,
              ).colorScheme.outline.withValues(alpha: .3),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.1),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(12),
                      ),
                      color: _getStatusColor(),
                    ),
                    child: Text(
                      "$status Order",
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Text(
                      dateTime,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSecondary,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),

              // Order Details
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Left Info
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${Labels.orderIdNumber} $orderId",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              "${Labels.customer}: $customerName",
                              style: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              "${Labels.payment}: $paymentMethod",
                              style: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),

                        // Right Info
                        Column(
                          children: [
                            Text(
                              '${CurrencyIcon.currencyIcon} $amount',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Action Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CustomMiniElevatedButton(
              title: "View Details",
              onPressed: onViewDetails,
              backgroundColor: Colors.blue,
              textColor: Colors.white,
            ),
            CustomMiniElevatedButton(
              title: "Cancel",
              onPressed: onCancel,
              backgroundColor: Colors.red,
              textColor: Colors.white,
            ),
          ],
        ),
      ],
    );
  }
}
// class OrdersDialogBoxes{
//   static void showDeleteDialog(int orderId, BuildContext context) {
//     final TextEditingController reasonController = TextEditingController();
//     final formKey = GlobalKey<FormState>();
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (dialogContext) {
//         return Dialog(
//           backgroundColor: Theme.of(context).colorScheme.onPrimary,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//           ),
//           child: Form(
//             key: formKey,
//             child: Padding(
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Cancel Order?",
//                     style: TextStyle(
//                         fontSize: 18.sp,
//                         color: AppColors.red,
//                         fontFamily: FontFamily.fontsPoppinsBold),
//                   ),
//                   const SizedBox(height: 12),
//                   Center(
//                     child: Text(
//                       "Are you sure you want to cancel order\n #${order.orderId}?",
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                           fontSize: 11.sp,
//                           color: AppColors.black,
//                           fontFamily: FontFamily.fontsPoppinsRegular),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   Text(
//                     'Reason:',
//                     style: TextStyle(
//                         fontSize: 14,
//                         color: AppColors.black,
//                         fontFamily: FontFamily.fontsPoppinsRegular),
//                   ),
//                   const SizedBox(height: 5),
//                   CustomTextFormField(
//                     textEditingController: reasonController,
//                     maxLineLength: 3,
//                     hint: "Reason for Cancel the order",
//                     validator: (formValue) {
//                       if (formValue == null || formValue.isEmpty) {
//                         return 'Please provide a reason.';
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 20),
//                   BlocConsumer<OrderBloc, OrderState>(
//                     listener: (context, state) {
//                       if (state.deleteOrderStatus ==
//                           DeleteOrderStatus.success) {
//                         Navigator.of(parentContext, rootNavigator: true).pop();
//                         parentContext.read<OrderBloc>().add(FetchOrdersEvent());
//
//                         SnackBarHelper.showSuccess(
//                           parentContext,
//                           "Order Cancel successfully",
//                         );
//
//                       } else if (state.deleteOrderStatus ==
//                           DeleteOrderStatus.error) {
//                         SnackBarHelper.showError(parentContext,
//                             state.message ?? "Failed to Cancel order");
//                       }
//                     },
//                     builder: (context, state) {
//                       if (state.deleteOrderStatus ==
//                           DeleteOrderStatus.loading) {
//                         return Center(
//                           child: SpinKitThreeInOut(
//                             color: AppColors.red,
//                             size: 22.sp,
//                           ),
//                         );
//                       }
//                       return Row(
//                         children: [
//                           Expanded(
//                             child: ElevatedButton(
//                               onPressed: () => Navigator.pop(dialogContext),
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.grey.shade300,
//                                 foregroundColor: Colors.black87,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                               ),
//                               child: const Text("Close",
//                                   style: TextStyle(
//                                       fontSize: 12,
//                                       color: Colors.black87,
//                                       fontFamily:
//                                       FontFamily.fontsPoppinsRegular)),
//                             ),
//                           ),
//                           const SizedBox(width: 12),
//                           Expanded(
//                             child: ElevatedButton(
//                               onPressed: () {
//                                 if (formKey.currentState!.validate()) {
//                                   context.read<OrderBloc>().add(
//                                       DeleteOrderEvent(
//                                           orderId: order.orderId!,
//                                           reason: reasonController.text));
//                                 }
//
//                                 // call delete API
//                               },
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.red,
//                                 foregroundColor: Colors.white,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                               ),
//                               child: const Text("Cancel Order",
//                                   style: TextStyle(
//                                       fontSize: 12,
//                                       color: Colors.white,
//                                       fontFamily:
//                                       FontFamily.fontsPoppinsRegular)),
//                             ),
//                           ),
//                         ],
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }