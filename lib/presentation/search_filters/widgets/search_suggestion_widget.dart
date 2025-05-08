import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class SearchSuggestionWidget extends StatelessWidget {
  final String suggestion;
  final VoidCallback onTap;

  const SearchSuggestionWidget({
    Key? key,
    required this.suggestion,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            CustomIconWidget(
              iconName: 'search',
              color: AppTheme.gray500,
              size: 20,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                suggestion,
                style: AppTheme.lightTheme.textTheme.bodyMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            CustomIconWidget(
              iconName: 'north_west',
              color: AppTheme.gray500,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
