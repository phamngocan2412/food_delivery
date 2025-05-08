import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class RestaurantInfoWidget extends StatelessWidget {
  final Map<String, dynamic> restaurant;

  const RestaurantInfoWidget({
    Key? key,
    required this.restaurant,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Restaurant Name
          Text(
            restaurant['name'],
            style: AppTheme.lightTheme.textTheme.displaySmall,
          ),

          const SizedBox(height: 8),

          // Cuisine Type
          Text(
            restaurant['cuisine'],
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.gray500,
            ),
          ),

          const SizedBox(height: 16),

          // Rating, Delivery Time, Min Order
          Row(
            children: [
              // Rating
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.success.withAlpha(26),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'star',
                      color: AppTheme.success,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${restaurant['rating']} (${restaurant['reviewCount']})',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.success,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              // Delivery Time
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'access_time',
                    color: AppTheme.gray500,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    restaurant['deliveryTime'],
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.gray700,
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 12),

              // Min Order
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'shopping_bag',
                    color: AppTheme.gray500,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Min: ${restaurant['minOrder']}',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.gray700,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Delivery Fee and Distance
          Row(
            children: [
              // Delivery Fee
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.delivery.withAlpha(26),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'delivery_dining',
                      color: AppTheme.delivery,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Delivery: ${restaurant['deliveryFee']}',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.delivery,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              // Distance
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'place',
                    color: AppTheme.gray500,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    restaurant['distance'],
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.gray700,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Opening Hours
          Row(
            children: [
              CustomIconWidget(
                iconName: 'schedule',
                color: restaurant['isOpen'] ? AppTheme.success : AppTheme.error,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                restaurant['openingHours'],
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color:
                      restaurant['isOpen'] ? AppTheme.success : AppTheme.error,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: restaurant['isOpen']
                      ? AppTheme.success.withAlpha(26)
                      : AppTheme.error.withAlpha(26),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  restaurant['isOpen'] ? 'Open Now' : 'Closed',
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: restaurant['isOpen']
                        ? AppTheme.success
                        : AppTheme.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Description
          Text(
            restaurant['description'],
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.gray700,
            ),
          ),

          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
