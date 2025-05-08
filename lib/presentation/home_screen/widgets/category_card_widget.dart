import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class CategoryCardWidget extends StatelessWidget {
  final Map<String, dynamic> category;

  const CategoryCardWidget({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: category['color'].withAlpha(26),
            borderRadius: BorderRadius.circular(35),
          ),
          child: Center(
            child: CustomIconWidget(
              iconName: category['icon'],
              color: category['color'],
              size: 32,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          category['name'],
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
