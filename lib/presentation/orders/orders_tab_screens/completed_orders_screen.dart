import 'package:flutter/material.dart';
import '../../../widgets/dialog_boxes/orders_dialog_boxes.dart';
import '../../../widgets/order_card.dart';

class CompletedOrdersScreen extends StatelessWidget {
  const CompletedOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            OrderCard(
              status: "Completed",
              orderId: "32",
              customerName: "Arham Khan",
              paymentMethod: "Paid Via Card",
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
              customerName: "Tamim Sajid",
              paymentMethod: "Cash on Delivery",
              amount: "43327.00",
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
