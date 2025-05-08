import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';
import '../../../widgets/custom_image_widget.dart';

class OrderCardWidget extends StatefulWidget {
  final Map<String, dynamic> order;
  final VoidCallback onTap;
  final VoidCallback onReorder;
  final VoidCallback onViewRestaurant;

  const OrderCardWidget({
    Key? key,
    required this.order,
    required this.onTap,
    required this.onReorder,
    required this.onViewRestaurant,
  }) : super(key: key);

  @override
  State<OrderCardWidget> createState() => _OrderCardWidgetState();
}

class _OrderCardWidgetState extends State<OrderCardWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final bool isOngoing = widget.order['status'] == 'In Progress' ||
        widget.order['status'] == 'On the way';
    final bool isDelivered = widget.order['status'] == 'Delivered';
    final bool isCancelled = widget.order['status'] == 'Cancelled';

    return GestureDetector(
      onTap: widget.onTap,
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Order Header
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: SizedBox(
                          width: 60,
                          height: 60,
                          child: CustomImageWidget(
                            imageUrl: widget.order['imageUrl'],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    widget.order['restaurantName'],
                                    style: AppTheme
                                        .lightTheme.textTheme.titleMedium,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                _buildStatusBadge(widget.order['status']),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.order['date'],
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme.gray500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  '\$${widget.order['total']}',
                                  style: AppTheme
                                      .lightTheme.textTheme.bodyMedium
                                      ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '•',
                                  style: AppTheme
                                      .lightTheme.textTheme.bodyMedium
                                      ?.copyWith(
                                    color: AppTheme.gray500,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    isOngoing
                                        ? widget.order['deliveryTime']
                                        : '${widget.order['items'].length} items',
                                    style: AppTheme
                                        .lightTheme.textTheme.bodyMedium
                                        ?.copyWith(
                                      color: isOngoing
                                          ? AppTheme.delivery
                                          : AppTheme.gray700,
                                      fontWeight: isOngoing
                                          ? FontWeight.w600
                                          : FontWeight.normal,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Order Items
                  if (_isExpanded) ...[
                    const SizedBox(height: 16),
                    const Divider(height: 1),
                    const SizedBox(height: 16),
                    Text(
                      'Order Items',
                      style: AppTheme.lightTheme.textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    ...List.generate(
                      widget.order['items'].length,
                      (index) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomIconWidget(
                              iconName: 'circle',
                              color: AppTheme.gray500,
                              size: 8,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                widget.order['items'][index],
                                style: AppTheme.lightTheme.textTheme.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (isOngoing) ...[
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'access_time',
                            color: AppTheme.delivery,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            widget.order['deliveryTime'],
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: AppTheme.delivery,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: widget.onViewRestaurant,
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: const Text('View Restaurant'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: isCancelled ? null : widget.onReorder,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              backgroundColor:
                                  isOngoing ? AppTheme.gray300 : null,
                              disabledBackgroundColor: AppTheme.gray300,
                            ),
                            child: Text(isOngoing ? 'Track Order' : 'Reorder'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            // Expand/Collapse Button
            InkWell(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.gray100,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _isExpanded ? 'Show Less' : 'Show Details',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.gray700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    CustomIconWidget(
                      iconName: _isExpanded
                          ? 'keyboard_arrow_up'
                          : 'keyboard_arrow_down',
                      color: AppTheme.gray700,
                      size: 16,
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

  Widget _buildStatusBadge(String status) {
    Color backgroundColor;
    Color textColor;

    switch (status) {
      case 'Delivered':
        backgroundColor = AppTheme.success.withAlpha(26);
        textColor = AppTheme.success;
        break;
      case 'In Progress':
        backgroundColor = AppTheme.info.withAlpha(26);
        textColor = AppTheme.info;
        break;
      case 'On the way':
        backgroundColor = AppTheme.delivery.withAlpha(26);
        textColor = AppTheme.delivery;
        break;
      case 'Cancelled':
        backgroundColor = AppTheme.error.withAlpha(26);
        textColor = AppTheme.error;
        break;
      default:
        backgroundColor = AppTheme.gray200;
        textColor = AppTheme.gray700;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
