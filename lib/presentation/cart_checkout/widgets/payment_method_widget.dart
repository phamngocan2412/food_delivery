import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class PaymentMethodWidget extends StatelessWidget {
  final List<Map<String, dynamic>> paymentMethods;
  final String selectedMethod;
  final Function(String) onMethodSelected;

  const PaymentMethodWidget({
    Key? key,
    required this.paymentMethods,
    required this.selectedMethod,
    required this.onMethodSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Payment Method',
                style: AppTheme.lightTheme.textTheme.titleMedium,
              ),
              TextButton(
                onPressed: () {
                  // Navigate to add new payment method
                },
                child: Text(
                  'Add New',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Payment Methods List
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: paymentMethods.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final method = paymentMethods[index];
              final isSelected = method['type'] == selectedMethod;

              return InkWell(
                onTap: () => onMethodSelected(method['type']),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.primary.withAlpha(26)
                        : AppTheme.gray50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? AppTheme.primary : AppTheme.gray200,
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      // Method Icon
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppTheme.primary.withAlpha(51)
                              : AppTheme.gray100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: CustomIconWidget(
                            iconName: method['icon'],
                            color: isSelected
                                ? AppTheme.primary
                                : AppTheme.gray700,
                            size: 24,
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      // Method Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              method['type'],
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? AppTheme.primary
                                    : AppTheme.gray900,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              method['details'],
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: isSelected
                                    ? AppTheme.primary.withAlpha(204)
                                    : AppTheme.gray500,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Selection Indicator
                      Radio(
                        value: method['type'],
                        groupValue: selectedMethod,
                        onChanged: (value) =>
                            onMethodSelected(value.toString()),
                        activeColor: AppTheme.primary,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
