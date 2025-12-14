import 'package:flutter/material.dart';

import '../core/assets/font_family.dart';
import '../core/utils/currency_icon.dart';
import '../core/utils/labels.dart';

class OrderSummaryOrderScreenContainer extends StatelessWidget {
  const OrderSummaryOrderScreenContainer({
    super.key,
    required this.itemTotal,
    required this.deliveryFee,
    required this.total,
    required this.itemQty,
    required this.tax,
  });

  final String itemTotal;
  final String deliveryFee;
  final String total;
  final String tax;
  final String itemQty;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 0),
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: .2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            child: Text(
              Labels.summary,
              style: TextStyle(
                fontFamily: FontFamily.fontsPoppinsSemiBold,
                fontSize: 16,
                color: theme.colorScheme.onSecondary,
              ),
            ),
          ),

          Divider(
            color: theme.colorScheme.outline.withValues(alpha: .2),
            height: 1,
            thickness: 1,
          ),

          /// Summary rows
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            child: Column(
              children: [
                _buildSummaryRow(
                  context,
                  '${Labels.itemsTotal} ($itemQty ${Labels.item})',
                  itemTotal,
                ),
                const SizedBox(height: 8),
                _buildSummaryRow(
                  context,
                  Labels.deliveryFee,
                  deliveryFee,
                ),
                const SizedBox(height: 8),
                _buildSummaryRow(
                  context,
                  Labels.tax,
                  tax,
                ),
                const SizedBox(height: 12),

                /// Highlighted Grand Total
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 12,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _buildSummaryRow(
                    context,
                    Labels.grandTotal,
                    total,
                    isBold: true,
                    isLarge: true,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Reusable row widget
  Widget _buildSummaryRow(
      BuildContext context,
      String label,
      String value, {
        bool isBold = false,
        bool isLarge = false,
      }) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: isLarge ? 16 : 14,
            fontFamily: isBold
                ? FontFamily.fontsPoppinsSemiBold
                : FontFamily.fontsPoppinsRegular,
            color: theme.colorScheme.onSecondary,
          ),
        ),
        Text(
          '${CurrencyIcon.currencyIcon}$value',
          style: TextStyle(
            fontSize: isLarge ? 16 : 14,
            fontFamily: isBold
                ? FontFamily.fontsPoppinsSemiBold
                : FontFamily.fontsPoppinsRegular,
            color: theme.colorScheme.onSecondary.withValues(alpha: .8),
          ),
        ),
      ],
    );
  }
}
