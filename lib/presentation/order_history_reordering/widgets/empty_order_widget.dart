import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class EmptyOrderWidget extends StatelessWidget {
  final VoidCallback onExplore;

  const EmptyOrderWidget({
    Key? key,
    required this.onExplore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'receipt_long',
              color: AppTheme.gray300,
              size: 80,
            ),
            const SizedBox(height: 24),
            Text(
              'No Orders Yet',
              style: AppTheme.lightTheme.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Looks like you haven\'t placed any orders yet. Start exploring restaurants and discover delicious meals!',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.gray500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: 200,
              child: ElevatedButton.icon(
                onPressed: onExplore,
                icon: CustomIconWidget(
                  iconName: 'restaurant_menu',
                  color: Colors.white,
                  size: 20,
                ),
                label: const Text('Explore Restaurants'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
