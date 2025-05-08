import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';
import '../../../widgets/custom_image_widget.dart';

class DeliveryDetailsWidget extends StatelessWidget {
  final Map<String, dynamic> deliveryAddress;
  final String estimatedTime;
  final VoidCallback onChangeAddress;
  final VoidCallback onSwitchToPickup;

  const DeliveryDetailsWidget({
    Key? key,
    required this.deliveryAddress,
    required this.estimatedTime,
    required this.onChangeAddress,
    required this.onSwitchToPickup,
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
                'Delivery Details',
                style: AppTheme.lightTheme.textTheme.titleMedium,
              ),
              TextButton(
                onPressed: onSwitchToPickup,
                child: Text(
                  'Switch to Pickup',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Address and Map Preview
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Map Preview
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 80,
                  height: 80,
                  color: AppTheme.gray200,
                  child: Stack(
                    children: [
                      // This would be a real map in production
                      CustomImageWidget(
                        imageUrl:
                            'https://maps.googleapis.com/maps/api/staticmap?center=${deliveryAddress['coordinates']['latitude']},${deliveryAddress['coordinates']['longitude']}&zoom=15&size=80x80&key=YOUR_API_KEY',
                        fit: BoxFit.cover,
                        width: 80,
                        height: 80,
                      ),
                      Center(
                        child: CustomIconWidget(
                          iconName: 'location_on',
                          color: AppTheme.primary,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // Address Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Deliver to:',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.gray500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${deliveryAddress['address']}, ${deliveryAddress['city']}, ${deliveryAddress['state']} ${deliveryAddress['zipCode']}',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (deliveryAddress['instructions'] != null &&
                        deliveryAddress['instructions'].isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Instructions: ${deliveryAddress['instructions']}',
                        style: AppTheme.lightTheme.textTheme.bodySmall,
                      ),
                    ],
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'access_time',
                          color: AppTheme.delivery,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Estimated delivery: $estimatedTime',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.delivery,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Change Address Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onChangeAddress,
              icon: CustomIconWidget(
                iconName: 'edit_location',
                color: AppTheme.primary,
                size: 18,
              ),
              label: const Text('Change Address'),
            ),
          ),
        ],
      ),
    );
  }
}
