import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';
import '../../../widgets/custom_image_widget.dart';

class FeaturedPromotionWidget extends StatelessWidget {
  final Map<String, dynamic> promotion;

  const FeaturedPromotionWidget({
    Key? key,
    required this.promotion,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      height: 180,
      decoration: BoxDecoration(
        color: promotion['backgroundColor'],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          // Background Image with Gradient Overlay
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: ShaderMask(
              shaderCallback: (Rect bounds) {
                return LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    promotion['backgroundColor'],
                    promotion['backgroundColor'].withAlpha(128),
                    Colors.transparent,
                  ],
                ).createShader(bounds);
              },
              blendMode: BlendMode.srcOver,
              child: CustomImageWidget(
                imageUrl: promotion['imageUrl'],
                width: 280,
                height: 180,
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Title and Description
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: promotion['textColor'].withAlpha(51),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'LIMITED OFFER',
                        style:
                            AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color: promotion['textColor'],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      promotion['title'],
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        color: promotion['textColor'],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      promotion['description'],
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: promotion['textColor'],
                      ),
                    ),
                  ],
                ),

                // CTA Button
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: promotion['textColor'],
                    foregroundColor: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    minimumSize: const Size(120, 36),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Order Now'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
