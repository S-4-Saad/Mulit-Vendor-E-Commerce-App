import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

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
      case "approved":
        return Colors.blue.shade900;
      case "pending":
        return Colors.yellow.shade900;
      case "pickedup":
        return Colors.yellow.shade900;
      case "rejected":
        return Colors.red.shade900;
      case "completed":
        return Colors.green.shade700;
      case "delivered":
        return Colors.green.shade700;
      case "cancelled":
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
                      "$status Order".toUpperCase(),
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
        if (status.toLowerCase() == "approved" ||
            status.toLowerCase() == "pending") ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const SizedBox(width: 8),

              CustomMiniElevatedButton(
                title: Labels.cancel, // changed from delete -> cancel
                onPressed: onCancel ?? () {},
                backgroundColor: Colors.red,
                textColor: Colors.white,
              ),
              CustomMiniElevatedButton(
                title: Labels.received,
                onPressed: () {
                  showQrDialog(context, orderId, customerName);
                },
                backgroundColor: Colors.green,
                textColor: Colors.white,
              ),

              const SizedBox(width: 8),

              // 👁 View Details (always visible)
              CustomMiniElevatedButton(
                title: Labels.viewDetails,
                onPressed: onViewDetails,
                backgroundColor: Colors.blue,
                textColor: Colors.white,
              ),
            ],
          ),
        ] else if (status.toLowerCase() == "pickedup") ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // ✅ Verify Button
              // For completed/canceled orders -> Only view details
              CustomMiniElevatedButton(
                title: Labels.viewDetails,
                onPressed: onViewDetails,
                backgroundColor: Colors.blue,
                textColor: Colors.white,
              ),
              CustomMiniElevatedButton(
                title: Labels.received,
                onPressed: () {
                  showQrDialog(context, orderId, customerName);
                },
                backgroundColor: Colors.green,
                textColor: Colors.white,
              ),

            ],
          ),
        ] else ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // ✅ Verify Button

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

  void showQrDialog(BuildContext context, String orderId, String customerName) {
    final qrData = "$orderId${customerName.toLowerCase()}";

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: ScaleTransition(
              scale: CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              ),
              child: FadeTransition(
                opacity: animation,
                child: _PremiumQrDialog(
                  qrData: qrData,
                  orderId: orderId,
                  customerName: customerName,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

}

class _PremiumQrDialog extends StatelessWidget {
  final String qrData;
  final String orderId;
  final String customerName;

  const _PremiumQrDialog({
    required this.qrData,
    required this.orderId,
    required this.customerName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
       color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header with gradient


          // Content
          Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                // QR Code Container with premium styling
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onPrimary,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.grey.shade200,
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: qrData.isNotEmpty
                      ? QrImageView(
                    data: qrData,
                    version: QrVersions.auto,
                    size: 200,
                    backgroundColor: Theme.of(context).colorScheme.onPrimary,
                    eyeStyle:  QrEyeStyle(
                      eyeShape: QrEyeShape.square,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    dataModuleStyle:  QrDataModuleStyle(
                      dataModuleShape: QrDataModuleShape.square,
                      color:Theme.of(context).colorScheme.onSecondary,
                    ),
                  )
                      : const SizedBox(
                    width: 200,
                    height: 200,
                    child: Center(
                      child: Icon(
                        Icons.error_outline,
                        size: 48,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Order Details
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onPrimary,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.grey.shade200,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      _InfoRow(
                        icon: Icons.receipt_long_rounded,
                        label: Labels.orderIdNumber,
                        value: orderId,
                      ),
                      const SizedBox(height: 12),
                      _InfoRow(
                        icon: Icons.person_rounded,
                        label:"${Labels.customer}:",
                        value: customerName,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Info text
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.info_outline_rounded,
                        color: Theme.of(context).colorScheme.primary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Rider must scan this code to verify and complete the delivery",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSecondary,
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Action Button
          Padding(
            padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor:Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child:  Text(
                  Labels.close,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
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

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color:Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 12),
        Text(
          "$label",
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSecondary,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style:  TextStyle(
              color: Theme.of(context).colorScheme.onSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
