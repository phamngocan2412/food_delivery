import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';
import '../../../widgets/custom_image_widget.dart';

class DishCardWidget extends StatelessWidget {
  final Map<String, dynamic> dish;
  final VoidCallback onTap;

  const DishCardWidget({
    Key? key,
    required this.dish,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dish Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 80,
                height: 80,
                child: Stack(
                  children: [
                    CustomImageWidget(
                      imageUrl: dish['imageUrl'],
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                    if (dish['isPopular'])
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          color: AppTheme.primary,
                          child: Text(
                            'Popular',
                            textAlign: TextAlign.center,
                            style: AppTheme.lightTheme.textTheme.labelSmall
                                ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(width: 16),

            // Dish Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name and Tags
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          dish['name'],
                          style: AppTheme.lightTheme.textTheme.titleMedium,
                        ),
                      ),
                      if (dish['isVegetarian'])
                        Container(
                          margin: const EdgeInsets.only(left: 4),
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: AppTheme.success.withAlpha(26),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: CustomIconWidget(
                            iconName: 'eco',
                            color: AppTheme.success,
                            size: 16,
                          ),
                        ),
                      if (dish['isSpicy'])
                        Container(
                          margin: const EdgeInsets.only(left: 4),
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: AppTheme.warning.withAlpha(26),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: CustomIconWidget(
                            iconName: 'whatshot',
                            color: AppTheme.warning,
                            size: 16,
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  // Description
                  Text(
                    dish['description'],
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.gray500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 8),

                  // Price and Add Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        dish['price'],
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primary,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: AppTheme.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          constraints: const BoxConstraints(
                            minWidth: 36,
                            minHeight: 36,
                          ),
                          padding: EdgeInsets.zero,
                          icon: CustomIconWidget(
                            iconName: 'add',
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed: onTap,
                        ),
                      ),
                    ],
                  ),

                  // Allergens
                  if (dish['allergens'] != null &&
                      (dish['allergens'] as List).isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'info_outline',
                            color: AppTheme.info,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              'Contains: ${(dish['allergens'] as List).join(', ')}',
                              style: AppTheme.lightTheme.textTheme.labelSmall
                                  ?.copyWith(
                                color: AppTheme.info,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
