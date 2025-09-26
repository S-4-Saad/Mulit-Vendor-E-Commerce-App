import 'package:flutter/material.dart';

import '../core/utils/currency_icon.dart';
import '../core/utils/labels.dart';
import '../presentation/orders/orders_tab_screens/active_orders_screen.dart';
import 'custom_mini_elevated_button.dart';

class OrderCard extends StatelessWidget {
  final String status; // Active, Completed, Canceled
  final String orderId;
  final String customerName;
  final String paymentMethod;
  final String amount;
  final String dateTime;
  final VoidCallback onViewDetails;
  final VoidCallback? onCancel;
  final VoidCallback? onVerify;

  const OrderCard({
    super.key,
    required this.status,
    required this.orderId,
    required this.customerName,
    required this.paymentMethod,
    required this.amount,
    required this.dateTime,
    this.onVerify,
    required this.onViewDetails,
     this.onCancel,
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
                        Expanded(
                          child: Column(
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
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                "${Labels.customer}: $customerName",
                                style: TextStyle(
                                  color:
                                  Theme.of(context).colorScheme.onSecondary,
                                  fontSize: 16,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                "${Labels.payment}: $paymentMethod",
                                style: TextStyle(
                                  color:
                                  Theme.of(context).colorScheme.onSecondary,
                                  fontSize: 16,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
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
        // Action Buttons
        if (status.toLowerCase() == "active") ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // ✅ Verify Button
              CustomMiniElevatedButton(
                title: Labels.verify,
                onPressed: onVerify ?? () {},
                backgroundColor: Colors.green,
                textColor: Colors.white,
              ),
              const SizedBox(width: 8),

              //   CustomMiniElevatedButton(
              //     title: Labels.cancel, // changed from delete -> cancel
              //     onPressed: onCancel ?? () {},
              //     backgroundColor: Colors.red,
              //     textColor: Colors.white,
              //   ),

              // const SizedBox(width: 8),

              // 👁 View Details (always visible)
              CustomMiniElevatedButton(
                title: Labels.viewDetails,
                onPressed: onViewDetails,
                backgroundColor: Colors.blue,
                textColor: Colors.white,
              ),
            ],
          ),
        ] else ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // For completed/canceled orders -> Only view details
              CustomMiniElevatedButton(
                title: Labels.viewDetails,
                onPressed: onViewDetails,
                backgroundColor: Colors.blue,
                textColor: Colors.white,
              ),
            ],
          ),
        ],

      ],
    );
  }
}