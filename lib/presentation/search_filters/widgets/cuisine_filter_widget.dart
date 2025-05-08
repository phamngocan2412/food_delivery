import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';

class CuisineFilterWidget extends StatelessWidget {
  final List<String> cuisines;
  final List<String> activeFilters;
  final Function(String) onFilterSelected;
  final Function(String) onFilterRemoved;

  const CuisineFilterWidget({
    Key? key,
    required this.cuisines,
    required this.activeFilters,
    required this.onFilterSelected,
    required this.onFilterRemoved,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: cuisines.map((cuisine) {
        final isSelected = activeFilters.contains(cuisine);
        return GestureDetector(
          onTap: () {
            if (isSelected) {
              onFilterRemoved(cuisine);
            } else {
              onFilterSelected(cuisine);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppTheme.primary.withAlpha(26)
                  : AppTheme.gray100,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? AppTheme.primary : AppTheme.gray200,
                width: 1,
              ),
            ),
            child: Text(
              cuisine,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: isSelected ? AppTheme.primary : AppTheme.gray700,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
