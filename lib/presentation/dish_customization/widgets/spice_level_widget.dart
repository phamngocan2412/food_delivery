import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class SpiceLevelWidget extends StatelessWidget {
  final List<Map<String, dynamic>> spiceLevels;
  final String selectedLevel;
  final Function(String) onLevelSelected;

  const SpiceLevelWidget({
    Key? key,
    required this.spiceLevels,
    required this.selectedLevel,
    required this.onLevelSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: spiceLevels.map((level) {
        final bool isSelected = selectedLevel == level['name'];
        final Color bgColor = level['color'];
        final Color textColor = level['textColor'];

        return InkWell(
          onTap: () => onLevelSelected(level['name']),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? bgColor : bgColor.withAlpha(77),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? textColor : Colors.transparent,
                width: 2,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIconWidget(
                  iconName: level['icon'],
                  color: textColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  level['name'],
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: textColor,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
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
