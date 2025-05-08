import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';
import '../../../widgets/custom_image_widget.dart';

class RestaurantCardWidget extends StatelessWidget {
  final Map<String, dynamic> restaurant;
  final VoidCallback onTap;

  const RestaurantCardWidget({
    Key? key,
    required this.restaurant,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
        child: Row(
          children: [
            // Restaurant Image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              child: SizedBox(
                width: 100,
                height: 100,
                child: CustomImageWidget(
                  imageUrl: restaurant['imageUrl'],
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Restaurant Details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Restaurant Name and Promoted Tag
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            restaurant['name'],
                            style: AppTheme.lightTheme.textTheme.titleMedium,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (restaurant['isPromoted'])
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppTheme.primary.withAlpha(26),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'Promoted',
                              style: AppTheme.lightTheme.textTheme.labelSmall
                                  ?.copyWith(
                                color: AppTheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    // Cuisine Type
                    Text(
                      restaurant['cuisine'],
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.gray500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 8),

                    // Rating, Delivery Time, Distance
                    Row(
                      children: [
                        // Rating
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppTheme.success.withAlpha(26),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'star',
                                color: AppTheme.success,
                                size: 14,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                restaurant['rating'].toString(),
                                style: AppTheme.lightTheme.textTheme.labelSmall
                                    ?.copyWith(
                                  color: AppTheme.success,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 8),

                        // Delivery Time
                        Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'access_time',
                              color: AppTheme.gray500,
                              size: 14,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              restaurant['deliveryTime'],
                              style: AppTheme.lightTheme.textTheme.labelSmall
                                  ?.copyWith(
                                color: AppTheme.gray700,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(width: 8),

                        // Distance
                        Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'place',
                              color: AppTheme.gray500,
                              size: 14,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              restaurant['distance'],
                              style: AppTheme.lightTheme.textTheme.labelSmall
                                  ?.copyWith(
                                color: AppTheme.gray700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Delivery Fee
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'delivery_dining',
                          color: AppTheme.delivery,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Delivery: ${restaurant['deliveryFee']}',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.delivery,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
