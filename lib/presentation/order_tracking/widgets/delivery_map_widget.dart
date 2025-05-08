import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';
import '../../../widgets/custom_image_widget.dart';

class DeliveryMapWidget extends StatefulWidget {
  final String deliveryStatus;
  final Map<String, dynamic> restaurantLocation;
  final Map<String, dynamic> deliveryLocation;
  final Map<String, dynamic> courierLocation;

  const DeliveryMapWidget({
    Key? key,
    required this.deliveryStatus,
    required this.restaurantLocation,
    required this.deliveryLocation,
    required this.courierLocation,
  }) : super(key: key);

  @override
  State<DeliveryMapWidget> createState() => _DeliveryMapWidgetState();
}

class _DeliveryMapWidgetState extends State<DeliveryMapWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Setup animation for courier movement
    _animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.gray200),
        color: Colors.white,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            // Map Image
            CustomImageWidget(
              imageUrl:
                  "https://images.unsplash.com/photo-1569336415962-a4bd9f69c07a?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80",
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
            ),

            // Map Overlay
            Container(
              color: Colors.white.withAlpha(26),
            ),

            // Restaurant Marker
            Positioned(
              left: 30,
              top: 100,
              child: _buildLocationMarker(
                color: AppTheme.primary,
                icon: 'restaurant',
                label: 'Restaurant',
              ),
            ),

            // Destination Marker
            Positioned(
              right: 30,
              top: 100,
              child: _buildLocationMarker(
                color: AppTheme.info,
                icon: 'home',
                label: 'Your Location',
              ),
            ),

            // Delivery Route Line
            CustomPaint(
              size: const Size(double.infinity, 250),
              painter: RoutePainter(
                startPoint: const Offset(50, 110),
                endPoint: const Offset(350, 110),
                progress: widget.deliveryStatus == 'Preparation' ? 0.3 : 0.7,
              ),
            ),

            // Courier Marker (Animated)
            if (widget.deliveryStatus == 'Out for Delivery')
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Positioned(
                    left: 50 + (300 * _animation.value * 0.7),
                    top: 90,
                    child: _buildCourierMarker(),
                  );
                },
              ),

            // Map Controls
            Positioned(
              right: 10,
              bottom: 10,
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(26),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: CustomIconWidget(
                        iconName: 'add',
                        color: AppTheme.gray700,
                        size: 20,
                      ),
                      onPressed: () {
                        // Zoom in
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(26),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: CustomIconWidget(
                        iconName: 'remove',
                        color: AppTheme.gray700,
                        size: 20,
                      ),
                      onPressed: () {
                        // Zoom out
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Map Attribution
            Positioned(
              left: 10,
              bottom: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(204),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Map data ©2023',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.gray700,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationMarker({
    required Color color,
    required String icon,
    required String label,
  }) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withAlpha(51),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: icon,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(26),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            label,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCourierMarker() {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppTheme.delivery.withAlpha(51),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.delivery.withAlpha(77),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Center(
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppTheme.delivery,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'delivery_dining',
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(26),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            'Courier',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.delivery,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class RoutePainter extends CustomPainter {
  final Offset startPoint;
  final Offset endPoint;
  final double progress;

  RoutePainter({
    required this.startPoint,
    required this.endPoint,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw dashed route line
    final paint = Paint()
      ..color = AppTheme.gray300
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

final double dashWidth = 8;
    final double dashSpace = 5;
    final distance = (endPoint - startPoint).distance;
    final dashCount = distance / (dashWidth + dashSpace);

    var currentPoint = startPoint;
    final direction = (endPoint - startPoint) / distance;

    for (var i = 0; i < dashCount; i++) {
      final start = currentPoint;
      final end = start + direction * dashWidth;
      canvas.drawLine(start, end, paint);
      currentPoint = end + direction * dashSpace;
    }

    // Draw progress line
    final progressPaint = Paint()
      ..color = AppTheme.delivery
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final progressEnd = startPoint + (endPoint - startPoint) * progress;
    canvas.drawLine(startPoint, progressEnd, progressPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
