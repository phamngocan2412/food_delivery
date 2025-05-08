import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class CheckoutProgressWidget extends StatelessWidget {
  final List<String> steps;
  final int currentStep;

  const CheckoutProgressWidget({
    Key? key,
    required this.steps,
    required this.currentStep,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Progress Indicator
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: List.generate(steps.length * 2 - 1, (index) {
                // For even indices, we show the step circle
                if (index.isEven) {
                  final stepIndex = index ~/ 2;
                  final isCompleted = stepIndex < currentStep;
                  final isCurrent = stepIndex == currentStep;

                  return _buildStepCircle(
                    stepIndex: stepIndex,
                    isCompleted: isCompleted,
                    isCurrent: isCurrent,
                  );
                }
                // For odd indices, we show the connector line
                else {
                  final beforeStepIndex = index ~/ 2;
                  final isCompleted = beforeStepIndex < currentStep;

                  return Expanded(
                    child: Container(
                      height: 2,
                      color: isCompleted ? AppTheme.primary : AppTheme.gray300,
                    ),
                  );
                }
              }),
            ),
          ),

          const SizedBox(height: 8),

          // Step Labels
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: steps.asMap().entries.map((entry) {
                final index = entry.key;
                final step = entry.value;
                final isCompleted = index < currentStep;
                final isCurrent = index == currentStep;

                return Expanded(
                  child: Text(
                    step,
                    textAlign: TextAlign.center,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: isCompleted || isCurrent
                          ? AppTheme.primary
                          : AppTheme.gray500,
                      fontWeight:
                          isCurrent ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepCircle({
    required int stepIndex,
    required bool isCompleted,
    required bool isCurrent,
  }) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: isCompleted
            ? AppTheme.primary
            : (isCurrent ? Colors.white : AppTheme.gray200),
        border: Border.all(
          color: isCompleted
              ? AppTheme.primary
              : (isCurrent ? AppTheme.primary : AppTheme.gray300),
          width: 2,
        ),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: isCompleted
            ? CustomIconWidget(
                iconName: 'check',
                color: Colors.white,
                size: 16,
              )
            : Text(
                '${stepIndex + 1}',
                style: TextStyle(
                  color: isCurrent ? AppTheme.primary : AppTheme.gray500,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}
