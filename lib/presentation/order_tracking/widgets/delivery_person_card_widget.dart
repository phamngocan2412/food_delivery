import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';
import '../../../widgets/custom_image_widget.dart';

class DeliveryPersonCardWidget extends StatelessWidget {
  final Map<String, dynamic> deliveryPerson;

  const DeliveryPersonCardWidget({
    Key? key,
    required this.deliveryPerson,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
          Text(
            'Your Delivery Person',
            style: AppTheme.lightTheme.textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              // Profile Photo
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: SizedBox(
                  width: 60,
                  height: 60,
                  child: CustomImageWidget(
                    imageUrl: deliveryPerson['photo'],
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // Delivery Person Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      deliveryPerson['name'],
                      style: AppTheme.lightTheme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'star',
                          color: AppTheme.warning,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${deliveryPerson['rating']} • ${deliveryPerson['totalDeliveries']} deliveries',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.gray700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Contact Buttons
              Row(
                children: [
                  _buildContactButton(
                    icon: 'message',
                    color: AppTheme.info,
                    onPressed: () {
                      // Message delivery person
                    },
                  ),
                  const SizedBox(width: 8),
                  _buildContactButton(
                    icon: 'call',
                    color: AppTheme.success,
                    onPressed: () {
                      // Call delivery person
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContactButton({
    required String icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: CustomIconWidget(
          iconName: icon,
          color: color,
          size: 20,
        ),
        onPressed: onPressed,
      ),
    );
  }
}
