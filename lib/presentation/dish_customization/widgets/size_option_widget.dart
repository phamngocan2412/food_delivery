import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';

class SizeOptionWidget extends StatelessWidget {
  final List<Map<String, dynamic>> sizes;
  final String selectedSize;
  final Function(String) onSizeSelected;

  const SizeOptionWidget({
    Key? key,
    required this.sizes,
    required this.selectedSize,
    required this.onSizeSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: sizes.map((size) {
        final bool isSelected = selectedSize == size['name'];
        final double priceAdjustment = size['priceAdjustment'] as double;
        final String priceText = priceAdjustment == 0
            ? ''
            : priceAdjustment > 0
                ? ' (+\$${priceAdjustment.toStringAsFixed(2)})'
                : ' (-\$${priceAdjustment.abs().toStringAsFixed(2)})';

        return InkWell(
          onTap: () => onSizeSelected(size['name']),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected ? AppTheme.primary.withAlpha(26) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? AppTheme.primary : AppTheme.gray200,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                // Radio button
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? AppTheme.primary : AppTheme.gray300,
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? Center(
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppTheme.primary,
                            ),
                          ),
                        )
                      : null,
                ),

                const SizedBox(width: 16),

                // Size details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        size['name'],
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        size['description'],
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.gray500,
                        ),
                      ),
                    ],
                  ),
                ),

                // Price adjustment
                if (priceText.isNotEmpty)
                  Text(
                    priceText,
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: priceAdjustment > 0
                          ? AppTheme.error
                          : AppTheme.success,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
