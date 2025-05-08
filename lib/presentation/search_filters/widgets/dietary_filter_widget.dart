import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class DietaryFilterWidget extends StatelessWidget {
  final List<String> dietaryOptions;
  final List<String> activeFilters;
  final Function(String) onFilterSelected;
  final Function(String) onFilterRemoved;

  const DietaryFilterWidget({
    Key? key,
    required this.dietaryOptions,
    required this.activeFilters,
    required this.onFilterSelected,
    required this.onFilterRemoved,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: dietaryOptions.map((option) {
        final isSelected = activeFilters.contains(option);
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: () {
              if (isSelected) {
                onFilterRemoved(option);
              } else {
                onFilterSelected(option);
              }
            },
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: isSelected ? AppTheme.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: isSelected ? AppTheme.primary : AppTheme.gray300,
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? Center(
                          child: CustomIconWidget(
                            iconName: 'check',
                            color: Colors.white,
                            size: 16,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    option,
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
                if (option == "Vegetarian Options")
                  CustomIconWidget(
                    iconName: 'eco',
                    color: AppTheme.success,
                    size: 20,
                  )
                else if (option == "Vegan Options")
                  CustomIconWidget(
                    iconName: 'spa',
                    color: AppTheme.success,
                    size: 20,
                  )
                else if (option == "Gluten-Free Options")
                  CustomIconWidget(
                    iconName: 'grain',
                    color: AppTheme.warning,
                    size: 20,
                  )
                else
                  CustomIconWidget(
                    iconName: 'restaurant',
                    color: AppTheme.gray500,
                    size: 20,
                  ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
