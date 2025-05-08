import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';

class PriceRangeFilterWidget extends StatelessWidget {
  final List<String> activeFilters;
  final Function(String) onFilterSelected;
  final Function(String) onFilterRemoved;

  const PriceRangeFilterWidget({
    Key? key,
    required this.activeFilters,
    required this.onFilterSelected,
    required this.onFilterRemoved,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildPriceOption('\$', 'Budget', activeFilters.contains('\$')),
        _buildPriceOption('\$\$', 'Average', activeFilters.contains('\$\$')),
        _buildPriceOption(
            '\$\$\$', 'Fine Dining', activeFilters.contains('\$\$\$')),
        _buildPriceOption(
            '\$\$\$\$', 'Luxury', activeFilters.contains('\$\$\$\$')),
      ],
    );
  }

  Widget _buildPriceOption(String price, String label, bool isSelected) {
    return GestureDetector(
      onTap: () {
        if (isSelected) {
          onFilterRemoved(price);
        } else {
          onFilterSelected(price);
        }
      },
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: isSelected
                  ? AppTheme.primary.withAlpha(26)
                  : AppTheme.gray100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? AppTheme.primary : AppTheme.gray200,
                width: 1,
              ),
            ),
            child: Center(
              child: Text(
                price,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? AppTheme.primary : AppTheme.gray700,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: isSelected ? AppTheme.primary : AppTheme.gray500,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
