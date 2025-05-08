import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';
import '../../../widgets/custom_image_widget.dart';

class RestaurantListItemWidget extends StatelessWidget {
  final Map<String, dynamic> restaurant;
  final VoidCallback onTap;

  const RestaurantListItemWidget({
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
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                  child: CustomImageWidget(
                    imageUrl: restaurant['imageUrl'],
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
                if (restaurant['isPromoted'])
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.primary,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Promoted',
                        style:
                            AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            // Restaurant Details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name
                    Text(
                      restaurant['name'],
                      style: AppTheme.lightTheme.textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 4),

                    // Cuisine
                    Text(
                      restaurant['cuisine'],
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.gray500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 8),

                    // Rating, Delivery Time, Price
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

                        // Price Range
                        Text(
                          restaurant['priceRange'],
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Distance and Delivery Fee
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
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
                              restaurant['deliveryFee'] == '\$0.00'
                                  ? 'Free Delivery'
                                  : 'Delivery: ${restaurant['deliveryFee']}',
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: restaurant['deliveryFee'] == '\$0.00'
                                    ? AppTheme.success
                                    : AppTheme.delivery,
                                fontWeight:
                                    restaurant['deliveryFee'] == '\$0.00'
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // Dietary Options
                    if (restaurant['dietaryOptions'] != null &&
                        (restaurant['dietaryOptions'] as List).isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          children: (restaurant['dietaryOptions'] as List)
                              .map<Widget>((option) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppTheme.gray100,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                option,
                                style: AppTheme.lightTheme.textTheme.labelSmall
                                    ?.copyWith(
                                  color: AppTheme.gray700,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
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
