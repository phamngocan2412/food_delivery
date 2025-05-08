import 'dart:async';

import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/delivery_map_widget.dart';
import './widgets/delivery_person_card_widget.dart';
import './widgets/delivery_progress_widget.dart';
import './widgets/order_details_widget.dart';

class OrderTrackingScreen extends StatefulWidget {
  const OrderTrackingScreen({Key? key}) : super(key: key);

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  bool _isLoading = true;
  String _currentStatus = 'Preparation';
  DateTime _estimatedDeliveryTime =
      DateTime.now().add(const Duration(minutes: 35));
  Timer? _countdownTimer;
  String _remainingTime = '';
  bool _isOrderDetailsExpanded = false;

  @override
  void initState() {
    super.initState();
    _loadOrderData();
    _startCountdownTimer();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadOrderData() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call to fetch order tracking data
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _startCountdownTimer() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        final now = DateTime.now();
        final difference = _estimatedDeliveryTime.difference(now);

        if (difference.isNegative) {
          setState(() {
            _remainingTime = 'Arriving now';
            _currentStatus = 'Delivered';
          });
          timer.cancel();
        } else {
          final minutes = difference.inMinutes;
          final seconds = difference.inSeconds % 60;
          setState(() {
            _remainingTime = '$minutes min $seconds sec';
          });
        }
      }
    });
  }

  Future<void> _refreshOrderData() async {
    await _loadOrderData();
    // Simulate status update after refresh
    if (_currentStatus == 'Preparation' && mounted) {
      setState(() {
        _currentStatus = 'Out for Delivery';
        // Update estimated time
        _estimatedDeliveryTime =
            DateTime.now().add(const Duration(minutes: 20));
      });
    }
  }

  void _shareETA() {
    // Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Delivery ETA shared successfully!',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: Colors.white,
          ),
        ),
        backgroundColor: AppTheme.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Tracking'),
        leading: IconButton(
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.gray700,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: CustomIconWidget(
              iconName: 'help_outline',
              color: AppTheme.gray700,
            ),
            onPressed: () {
              // Show help dialog
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refreshOrderData,
        color: AppTheme.primary,
        child: _isLoading ? _buildLoadingState() : _buildTrackingContent(),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/order-history-reordering');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.gray100,
                    foregroundColor: AppTheme.gray700,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomIconWidget(
                        iconName: 'receipt_long',
                        color: AppTheme.gray700,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      const Text('View Orders'),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _shareETA,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomIconWidget(
                        iconName: 'share',
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      const Text('Share ETA'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppTheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            'Loading order details...',
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildTrackingContent() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order ID and Time
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order #FD7834',
                  style: AppTheme.lightTheme.textTheme.titleMedium,
                ),
                Text(
                  'Today, 2:30 PM',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.gray500,
                  ),
                ),
              ],
            ),
          ),

          // Delivery Progress Tracker
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: DeliveryProgressWidget(currentStatus: _currentStatus),
          ),

          // Estimated Delivery Time
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primary.withAlpha(26),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'access_time',
                  color: AppTheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Estimated Delivery',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.gray700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _remainingTime,
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          color: AppTheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Live Map
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Live Tracking',
              style: AppTheme.lightTheme.textTheme.titleMedium,
            ),
          ),
          const SizedBox(height: 8),
          DeliveryMapWidget(
            deliveryStatus: _currentStatus,
            restaurantLocation: deliveryData['restaurantLocation'],
            deliveryLocation: deliveryData['deliveryLocation'],
            courierLocation: deliveryData['courierLocation'],
          ),

          // Delivery Person Details
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: DeliveryPersonCardWidget(
              deliveryPerson: deliveryData['deliveryPerson'],
            ),
          ),

          // Order Details (Collapsible)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: InkWell(
              onTap: () {
                setState(() {
                  _isOrderDetailsExpanded = !_isOrderDetailsExpanded;
                });
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
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
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Order Details',
                          style: AppTheme.lightTheme.textTheme.titleMedium,
                        ),
                        CustomIconWidget(
                          iconName: _isOrderDetailsExpanded
                              ? 'keyboard_arrow_up'
                              : 'keyboard_arrow_down',
                          color: AppTheme.gray700,
                        ),
                      ],
                    ),
                    if (_isOrderDetailsExpanded) ...[
                      const SizedBox(height: 16),
                      OrderDetailsWidget(
                        orderItems: deliveryData['orderItems'],
                        specialInstructions:
                            deliveryData['specialInstructions'],
                        subtotal: deliveryData['subtotal'],
                        deliveryFee: deliveryData['deliveryFee'],
                        total: deliveryData['total'],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),

          // Support Section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.gray100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'support_agent',
                    color: AppTheme.info,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Need help with your order?',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Our support team is here to help',
                          style: AppTheme.lightTheme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Contact support
                    },
                    child: Text(
                      'Contact',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.info,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Back to Home Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: OutlinedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/home-screen');
              },
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: Text(
                'Back to Home',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // Mock Data
  final Map<String, dynamic> deliveryData = {
    "orderId": "FD7834",
    "orderTime": "2023-11-15T14:30:00Z",
    "estimatedDeliveryTime": "2023-11-15T15:05:00Z",
    "currentStatus": "Out for Delivery",
    "restaurantName": "Burger Bliss",
    "restaurantLocation": {
      "latitude": 37.7749,
      "longitude": -122.4194,
      "address": "123 Market St, San Francisco, CA"
    },
    "deliveryLocation": {
      "latitude": 37.7849,
      "longitude": -122.4294,
      "address": "456 Pine St, San Francisco, CA"
    },
    "courierLocation": {
      "latitude": 37.7799,
      "longitude": -122.4244,
      "isMoving": true
    },
    "deliveryPerson": {
      "name": "Michael Rodriguez",
      "phone": "+1 (555) 123-4567",
      "photo": "https://randomuser.me/api/portraits/men/32.jpg",
      "rating": 4.8,
      "totalDeliveries": 342
    },
    "orderItems": [
      {
        "name": "Double Cheeseburger",
        "quantity": 2,
        "price": "\$12.99",
        "modifications": ["No onions", "Extra cheese"]
      },
      {
        "name": "Sweet Potato Fries",
        "quantity": 1,
        "price": "\$4.99",
        "modifications": ["Extra dip"]
      },
      {
        "name": "Chocolate Milkshake",
        "quantity": 1,
        "price": "\$5.99",
        "modifications": []
      }
    ],
    "specialInstructions":
        "Please leave at the door. Ring doorbell when delivered.",
    "subtotal": "\$36.96",
    "deliveryFee": "\$3.99",
    "total": "\$40.95"
  };
}
