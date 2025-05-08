import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';

class OrderSummaryWidget extends StatelessWidget {
  final double subtotal;
  final double deliveryFee;
  final double tax;
  final double discount;
  final double total;

  const OrderSummaryWidget({
    Key? key,
    required this.subtotal,
    required this.deliveryFee,
    required this.tax,
    required this.discount,
    required this.total,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Summary',
            style: AppTheme.lightTheme.textTheme.titleMedium,
          ),

          const SizedBox(height: 16),

          // Subtotal
          _buildSummaryRow(
            label: 'Subtotal',
            value: subtotal,
          ),

          const SizedBox(height: 8),

          // Delivery Fee
          _buildSummaryRow(
            label: 'Delivery Fee',
            value: deliveryFee,
          ),

          const SizedBox(height: 8),

          // Tax
          _buildSummaryRow(
            label: 'Tax',
            value: tax,
          ),

          // Discount (if applicable)
          if (discount > 0) ...[
            const SizedBox(height: 8),
            _buildSummaryRow(
              label: 'Discount',
              value: -discount,
              valueColor: AppTheme.success,
            ),
          ],

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(),
          ),

          // Total
          _buildSummaryRow(
            label: 'Total',
            value: total,
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow({
    required String label,
    required double value,
    Color? valueColor,
    bool isTotal = false,
  }) {
    final valueText = value < 0
        ? '-\$${(-value).toStringAsFixed(2)}'
        : '\$${value.toStringAsFixed(2)}';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isTotal
              ? AppTheme.lightTheme.textTheme.titleMedium
              : AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        Text(
          valueText,
          style: isTotal
              ? AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  color: AppTheme.primary,
                  fontWeight: FontWeight.bold,
                )
              : AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: valueColor,
                  fontWeight: value < 0 ? FontWeight.w600 : null,
                ),
        ),
      ],
    );
  }
}
