import 'package:flutter/material.dart';
import '../../../widgets/dialog_boxes/orders_dialog_boxes.dart';
import '../../../widgets/order_card.dart';

class CancelledOrdersScreen extends StatelessWidget {
  const CancelledOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [

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
                OrdersDialogBoxes.showDeleteDialog(23, context);
              },
            ),
            OrderCard(
              status: "Canceled",
              orderId: "388",
              customerName: "Ahmad Ejaz",
              paymentMethod: "Cash on Delivery",
              amount: "200.00",
              dateTime: "29th Dec, 2023 | 02:30 PM",
              onViewDetails: () {
                // Navigate to details
              },
              onCancel: () {
                OrdersDialogBoxes.showDeleteDialog(23, context);
                // Cancel logic
              },
            ),

          ],
        ),
      ),
    );
  }
}
