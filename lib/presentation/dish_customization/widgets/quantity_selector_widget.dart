import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class QuantitySelectorWidget extends StatelessWidget {
  final int quantity;
  final Function(int) onChanged;
  final int minQuantity;
  final int maxQuantity;

  const QuantitySelectorWidget({
    Key? key,
    required this.quantity,
    required this.onChanged,
    this.minQuantity = 1,
    this.maxQuantity = 10,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.gray200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Decrease button
          InkWell(
            onTap:
                quantity > minQuantity ? () => onChanged(quantity - 1) : null,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: quantity > minQuantity
                    ? AppTheme.gray100
                    : AppTheme.gray100.withAlpha(128),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(11),
                  bottomLeft: Radius.circular(11),
                ),
              ),
              child: CustomIconWidget(
                iconName: 'remove',
                color: quantity > minQuantity
                    ? AppTheme.gray700
                    : AppTheme.gray500,
                size: 20,
              ),
            ),
          ),

          // Quantity display
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              quantity.toString(),
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // Increase button
          InkWell(
            onTap:
                quantity < maxQuantity ? () => onChanged(quantity + 1) : null,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: quantity < maxQuantity
                    ? AppTheme.gray100
                    : AppTheme.gray100.withAlpha(128),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(11),
                  bottomRight: Radius.circular(11),
                ),
              ),
              child: CustomIconWidget(
                iconName: 'add',
                color: quantity < maxQuantity
                    ? AppTheme.gray700
                    : AppTheme.gray500,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
