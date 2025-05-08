import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/category_card_widget.dart';
import './widgets/featured_promotion_widget.dart';
import './widgets/recent_order_card_widget.dart';
import './widgets/restaurant_card_widget.dart';
import './widgets/search_bar_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Simulate loading data
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate refreshing data
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'location_on',
              color: AppTheme.primary,
              size: 24,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Deliver to',
                    style: AppTheme.lightTheme.textTheme.bodySmall,
                  ),
                  Text(
                    '123 Main Street, New York',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: CustomIconWidget(
              iconName: 'person',
              color: AppTheme.gray700,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/user-profile-settings');
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refreshData,
        color: AppTheme.primary,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SearchBarWidget(
                    onTap: () {
                      Navigator.pushNamed(context, '/search-filters');
                    },
                  ),
                ),

                const SizedBox(height: 24),

                // Food Categories
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 8),
                  child: Text(
                    'Categories',
                    style: AppTheme.lightTheme.textTheme.titleMedium,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 100,
                  child: _isLoading
                      ? _buildCategorySkeletonLoader()
                      : _buildCategoryList(),
                ),

                const SizedBox(height: 24),

                // Featured Promotions
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Featured Promotions',
                        style: AppTheme.lightTheme.textTheme.titleMedium,
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'See All',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 180,
                  child: _isLoading
                      ? _buildPromotionSkeletonLoader()
                      : _buildFeaturedPromotions(),
                ),

                const SizedBox(height: 24),

                // Recommended Restaurants
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recommended for You',
                        style: AppTheme.lightTheme.textTheme.titleMedium,
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'See All',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                _isLoading
                    ? _buildRestaurantSkeletonLoader()
                    : _buildRecommendedRestaurants(),

                const SizedBox(height: 24),

                // Recent Orders
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recent Orders',
                        style: AppTheme.lightTheme.textTheme.titleMedium,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(
                              context, '/order-history-reordering');
                        },
                        child: Text(
                          'View All',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                _isLoading
                    ? _buildRecentOrderSkeletonLoader()
                    : _buildRecentOrders(),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          // Handle navigation to other main screens
          if (index == 3) {
            Navigator.pushNamed(context, '/order-history-reordering');
          } else if (index == 4) {
            Navigator.pushNamed(context, '/user-profile-settings');
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'home',
              color: AppTheme.primary,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'search',
              color: AppTheme.gray500,
            ),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'shopping_cart',
              color: AppTheme.gray500,
            ),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'receipt_long',
              color: AppTheme.gray500,
            ),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'person',
              color: AppTheme.gray500,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  // Category List
  Widget _buildCategoryList() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: foodCategories.length,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(right: 16),
          child: CategoryCardWidget(
            category: foodCategories[index],
          ),
        );
      },
    );
  }

  // Featured Promotions
  Widget _buildFeaturedPromotions() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: promotions.length,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(right: 16),
          child: FeaturedPromotionWidget(
            promotion: promotions[index],
          ),
        );
      },
    );
  }

  // Recommended Restaurants
  Widget _buildRecommendedRestaurants() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: restaurants.length,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: RestaurantCardWidget(
            restaurant: restaurants[index],
            onTap: () {
              Navigator.pushNamed(context, '/restaurant-details');
            },
          ),
        );
      },
    );
  }

  // Recent Orders
  Widget _buildRecentOrders() {
    return SizedBox(
      height: 130,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recentOrders.length,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 16),
            child: RecentOrderCardWidget(
              order: recentOrders[index],
              onTap: () {
                // Navigate to reorder flow
              },
            ),
          );
        },
      ),
    );
  }

  // Skeleton Loaders
  Widget _buildCategorySkeletonLoader() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 5,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Column(
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: AppTheme.gray200,
                  borderRadius: BorderRadius.circular(35),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: 60,
                height: 12,
                decoration: BoxDecoration(
                  color: AppTheme.gray200,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPromotionSkeletonLoader() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 2,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Container(
            width: 280,
            height: 180,
            decoration: BoxDecoration(
              color: AppTheme.gray200,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRestaurantSkeletonLoader() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Container(
            height: 100,
            decoration: BoxDecoration(
              color: AppTheme.gray200,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRecentOrderSkeletonLoader() {
    return SizedBox(
      height: 130,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Container(
              width: 140,
              decoration: BoxDecoration(
                color: AppTheme.gray200,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        },
      ),
    );
  }

  // Mock Data
  final List<Map<String, dynamic>> foodCategories = [
    {
      "id": 1,
      "name": "Pizza",
      "icon": "local_pizza",
      "color": Color(0xFFF97316),
    },
    {
      "id": 2,
      "name": "Burgers",
      "icon": "lunch_dining",
      "color": Color(0xFFEF4444),
    },
    {
      "id": 3,
      "name": "Sushi",
      "icon": "set_meal",
      "color": Color(0xFF3B82F6),
    },
    {
      "id": 4,
      "name": "Salads",
      "icon": "eco",
      "color": Color(0xFF22C55E),
    },
    {
      "id": 5,
      "name": "Desserts",
      "icon": "cake",
      "color": Color(0xFFA855F7),
    },
    {
      "id": 6,
      "name": "Drinks",
      "icon": "local_bar",
      "color": Color(0xFF06B6D4),
    },
  ];

  final List<Map<String, dynamic>> promotions = [
    {
      "id": 1,
      "title": "50% OFF Your First Order",
      "description": "Use code WELCOME50 at checkout",
      "imageUrl":
          "https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80",
      "expiryDate": "2023-12-31",
      "backgroundColor": Color(0xFFFEF3C7),
      "textColor": Color(0xFFD97706),
    },
    {
      "id": 2,
      "title": "Free Delivery on Orders \$20+",
      "description": "Limited time offer",
      "imageUrl":
          "https://images.unsplash.com/photo-1513104890138-7c749659a591?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80",
      "expiryDate": "2023-11-30",
      "backgroundColor": Color(0xFFDCFCE7),
      "textColor": Color(0xFF15803D),
    },
  ];

  final List<Map<String, dynamic>> restaurants = [
    {
      "id": 1,
      "name": "Pizza Paradise",
      "cuisine": "Italian, Pizza",
      "rating": 4.8,
      "deliveryTime": "15-25 min",
      "deliveryFee": "\$1.99",
      "distance": "0.8 mi",
      "imageUrl":
          "https://images.unsplash.com/photo-1513104890138-7c749659a591?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80",
      "isPromoted": true,
    },
    {
      "id": 2,
      "name": "Burger Bliss",
      "cuisine": "American, Burgers",
      "rating": 4.5,
      "deliveryTime": "20-30 min",
      "deliveryFee": "\$2.49",
      "distance": "1.2 mi",
      "imageUrl":
          "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80",
      "isPromoted": false,
    },
    {
      "id": 3,
      "name": "Sushi Sensation",
      "cuisine": "Japanese, Sushi",
      "rating": 4.7,
      "deliveryTime": "25-35 min",
      "deliveryFee": "\$3.99",
      "distance": "1.5 mi",
      "imageUrl":
          "https://images.unsplash.com/photo-1579871494447-9811cf80d66c?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80",
      "isPromoted": true,
    },
  ];

  final List<Map<String, dynamic>> recentOrders = [
    {
      "id": 1,
      "restaurantName": "Pizza Paradise",
      "items": ["Pepperoni Pizza", "Garlic Bread"],
      "date": "Yesterday",
      "imageUrl":
          "https://images.unsplash.com/photo-1513104890138-7c749659a591?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80",
    },
    {
      "id": 2,
      "restaurantName": "Burger Bliss",
      "items": ["Cheeseburger", "Fries"],
      "date": "2 days ago",
      "imageUrl":
          "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80",
    },
    {
      "id": 3,
      "restaurantName": "Sushi Sensation",
      "items": ["California Roll", "Miso Soup"],
      "date": "Last week",
      "imageUrl":
          "https://images.unsplash.com/photo-1579871494447-9811cf80d66c?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80",
    },
  ];
}
