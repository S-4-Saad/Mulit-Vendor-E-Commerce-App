import 'package:flutter/material.dart';
import 'package:speezu/presentation/order_details/order_details_screen.dart';
import '../../../widgets/dialog_boxes/orders_dialog_boxes.dart';
import '../../../widgets/order_card.dart';
import '../../qr_scanner/qr_scanner_screen.dart';

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
              onVerify: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const QrScannerScreen()),
                );

                if (result != null) {
                  print("✅ QR Scanned: $result");
                  // Show it in a Snackbar instead of black screen
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Scanned: $result")),
                  );
                }
              },
              onViewDetails: () {
                Navigator.push(context, MaterialPageRoute(builder:  (context) => OrderDetailsScreen(),));
                // Navigate to details
              },
              onCancel: () {
                OrdersDialogBoxes.showDeleteDialog(23, context);
                // Cancel logic
              },
            ),
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
                OrdersDialogBoxes.showDeleteDialog(23, context);
                // Cancel logic
              },
            ),
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
          ],
        ),
      ),
    );
  }
}
