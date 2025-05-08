import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';

class OrderDetailsWidget extends StatelessWidget {
  final List<dynamic> orderItems;
  final String specialInstructions;
  final String subtotal;
  final String deliveryFee;
  final String total;

  const OrderDetailsWidget({
    Key? key,
    required this.orderItems,
    required this.specialInstructions,
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Order Items
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: orderItems.length,
          separatorBuilder: (context, index) => const Divider(height: 24),
          itemBuilder: (context, index) {
            final item = orderItems[index];
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Quantity
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withAlpha(26),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                    child: Text(
                      '${item['quantity']}x',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Item Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['name'],
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (item['modifications'].isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          item['modifications'].join(', '),
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.gray500,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // Price
                Text(
                  item['price'],
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            );
          },
        ),

        const Divider(height: 32),

        // Special Instructions
        if (specialInstructions.isNotEmpty) ...[
          Text(
            'Special Instructions',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.gray100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              specialInstructions,
              style: AppTheme.lightTheme.textTheme.bodySmall,
            ),
          ),
          const Divider(height: 32),
        ],

        // Order Summary
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Subtotal',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            Text(
              subtotal,
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Delivery Fee',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            Text(
              deliveryFee,
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Divider(height: 1),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total',
              style: AppTheme.lightTheme.textTheme.titleMedium,
            ),
            Text(
              total,
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.primary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
