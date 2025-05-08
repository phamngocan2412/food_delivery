import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class DeliveryProgressWidget extends StatelessWidget {
  final String currentStatus;

  const DeliveryProgressWidget({
    Key? key,
    required this.currentStatus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> stages = [
      'Order Confirmed',
      'Preparation',
      'Out for Delivery',
      'Delivered'
    ];

    final currentIndex = stages.indexOf(currentStatus);

    return Column(
      children: [
        Row(
          children: List.generate(stages.length, (index) {
            final isCompleted = index <= currentIndex;
            final isActive = index == currentIndex;

            return Expanded(
              child: Row(
                children: [
                  // Circle indicator
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: isCompleted ? AppTheme.primary : AppTheme.gray200,
                      shape: BoxShape.circle,
                      border: isActive
                          ? Border.all(color: AppTheme.primary, width: 2)
                          : null,
                    ),
                    child: isCompleted
                        ? Center(
                            child: CustomIconWidget(
                              iconName: 'check',
                              color: Colors.white,
                              size: 16,
                            ),
                          )
                        : null,
                  ),

                  // Line connector (except for the last item)
                  if (index < stages.length - 1)
                    Expanded(
                      child: Container(
                        height: 3,
                        color: index < currentIndex
                            ? AppTheme.primary
                            : AppTheme.gray200,
                      ),
                    ),
                ],
              ),
            );
          }),
        ),

        const SizedBox(height: 8),

        // Status labels
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: stages.map((stage) {
            final isCompleted = stages.indexOf(stage) <= currentIndex;
            final isActive = stage == currentStatus;

            return Flexible(
              child: Text(
                stage,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: isCompleted ? AppTheme.primary : AppTheme.gray500,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
