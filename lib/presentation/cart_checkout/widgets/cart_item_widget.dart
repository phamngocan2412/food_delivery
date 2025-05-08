import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';
import '../../../widgets/custom_image_widget.dart';

class CartItemWidget extends StatelessWidget {
  final Map<String, dynamic> item;
  final Function(int) onQuantityChanged;
  final VoidCallback onRemove;

  const CartItemWidget({
    Key? key,
    required this.item,
    required this.onQuantityChanged,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Item Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 70,
              height: 70,
              child: CustomImageWidget(
                imageUrl: item['image'],
                fit: BoxFit.cover,
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
                  style: AppTheme.lightTheme.textTheme.titleMedium,
                ),

                const SizedBox(height: 4),

                // Customizations
                if (item['customizations'] != null &&
                    (item['customizations'] as List).isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      (item['customizations'] as List).join(', '),
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.gray500,
                      ),
                    ),
                  ),

                // Restaurant Name
                Text(
                  item['restaurantName'],
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.gray500,
                  ),
                ),

                const SizedBox(height: 8),

                // Price and Quantity Controls
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${(item['price'] * item['quantity']).toStringAsFixed(2)}',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        color: AppTheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    // Quantity Controls
                    Row(
                      children: [
                        // Remove Item Button
                        if (item['quantity'] == 1)
                          IconButton(
                            icon: CustomIconWidget(
                              iconName: 'delete_outline',
                              color: AppTheme.error,
                              size: 20,
                            ),
                            onPressed: onRemove,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          )
                        else
                          _buildQuantityButton(
                            icon: 'remove',
                            onPressed: () {
                              if (item['quantity'] > 1) {
                                onQuantityChanged(item['quantity'] - 1);
                              }
                            },
                          ),

                        // Quantity Display
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            item['quantity'].toString(),
                            style: AppTheme.lightTheme.textTheme.bodyLarge
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                        // Add Button
                        _buildQuantityButton(
                          icon: 'add',
                          onPressed: () {
                            onQuantityChanged(item['quantity'] + 1);
                          },
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
    );
  }

  Widget _buildQuantityButton(
      {required String icon, required VoidCallback onPressed}) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppTheme.gray100,
          borderRadius: BorderRadius.circular(4),
        ),
        child: CustomIconWidget(
          iconName: icon,
          color: AppTheme.gray700,
          size: 16,
        ),
      ),
    );
  }
}
