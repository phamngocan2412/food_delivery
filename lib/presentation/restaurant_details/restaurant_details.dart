import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/gallery_image_widget.dart';
import './widgets/menu_category_widget.dart';
import './widgets/restaurant_info_widget.dart';
import './widgets/review_card_widget.dart';

class RestaurantDetailsScreen extends StatefulWidget {
  const RestaurantDetailsScreen({Key? key}) : super(key: key);

  @override
  State<RestaurantDetailsScreen> createState() =>
      _RestaurantDetailsScreenState();
}

class _RestaurantDetailsScreenState extends State<RestaurantDetailsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _scrollController;
  bool _showCategoryBar = false;
  int _selectedCategoryIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    // Show category bar after scrolling past restaurant info
    if (_scrollController.offset > 300 && !_showCategoryBar) {
      setState(() {
        _showCategoryBar = true;
      });
    } else if (_scrollController.offset <= 300 && _showCategoryBar) {
      setState(() {
        _showCategoryBar = false;
      });
    }

    // Update selected category based on scroll position
    for (int i = 0; i < menuCategories.length; i++) {
      final categoryKey = GlobalKey();
      final renderBox =
          categoryKey.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        final position = renderBox.localToGlobal(Offset.zero);
        if (position.dy >= 0 && position.dy <= 100) {
          if (_selectedCategoryIndex != i) {
            setState(() {
              _selectedCategoryIndex = i;
            });
            break;
          }
        }
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main content
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              // App Bar with Gallery
              SliverAppBar(
                expandedHeight: 250,
                pinned: true,
                leading: IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(26),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: CustomIconWidget(
                      iconName: 'arrow_back',
                      color: AppTheme.gray900,
                      size: 20,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                actions: [
                  IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(26),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: CustomIconWidget(
                        iconName: 'share',
                        color: AppTheme.gray900,
                        size: 20,
                      ),
                    ),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(26),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: CustomIconWidget(
                        iconName: 'favorite_border',
                        color: AppTheme.gray900,
                        size: 20,
                      ),
                    ),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 16),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    children: [
                      // Gallery Images
                      PageView.builder(
                        itemCount: restaurantGallery.length,
                        itemBuilder: (context, index) {
                          return GalleryImageWidget(
                            imageUrl: restaurantGallery[index],
                          );
                        },
                      ),

                      // Pagination Indicators
                      Positioned(
                        bottom: 16,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            restaurantGallery.length,
                            (index) => Container(
                              width: 8,
                              height: 8,
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: index == 0
                                    ? AppTheme.primary
                                    : Colors.white.withAlpha(128),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Restaurant Info
              SliverToBoxAdapter(
                child: RestaurantInfoWidget(
                  restaurant: restaurantDetails,
                ),
              ),

              // Tab Bar
              SliverPersistentHeader(
                delegate: _SliverAppBarDelegate(
                  TabBar(
                    controller: _tabController,
                    labelColor: AppTheme.primary,
                    unselectedLabelColor: AppTheme.gray500,
                    indicatorColor: AppTheme.primary,
                    tabs: const [
                      Tab(text: 'Menu'),
                      Tab(text: 'Reviews'),
                    ],
                  ),
                ),
                pinned: true,
              ),

              // Tab Content
              SliverFillRemaining(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Menu Tab
                    ListView.builder(
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: menuCategories.length,
                      itemBuilder: (context, index) {
                        return MenuCategoryWidget(
                          category: menuCategories[index],
                          dishes: menuItems
                              .where((dish) =>
                                  dish['categoryId'] ==
                                  menuCategories[index]['id'])
                              .toList(),
                          onDishTap: (dish) {
                            Navigator.pushNamed(context, '/dish-customization');
                          },
                        );
                      },
                    ),

                    // Reviews Tab
                    ListView.builder(
                      padding: const EdgeInsets.all(16),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: reviews.length,
                      itemBuilder: (context, index) {
                        return ReviewCardWidget(
                          review: reviews[index],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Sticky Category Navigation Bar
          if (_showCategoryBar)
            Positioned(
              top: kToolbarHeight,
              left: 0,
              right: 0,
              child: Container(
                height: 50,
                color: Colors.white,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: menuCategories.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Center(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _selectedCategoryIndex = index;
                            });
                            // Scroll to category
                            // Implementation would require GlobalKeys for each category
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: _selectedCategoryIndex == index
                                  ? AppTheme.primary.withAlpha(26)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: _selectedCategoryIndex == index
                                    ? AppTheme.primary
                                    : Colors.transparent,
                              ),
                            ),
                            child: Text(
                              menuCategories[index]['name'],
                              style: TextStyle(
                                color: _selectedCategoryIndex == index
                                    ? AppTheme.primary
                                    : AppTheme.gray700,
                                fontWeight: _selectedCategoryIndex == index
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

          // Sticky Add to Cart Button
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(26),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/cart-checkout');
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('View Cart'),
                      SizedBox(width: 8),
                      Text('\$24.99',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Mock Data
  final Map<String, dynamic> restaurantDetails = {
    "id": 1,
    "name": "Italiano Authentic",
    "cuisine": "Italian, Pizza, Pasta",
    "rating": 4.8,
    "reviewCount": 243,
    "deliveryTime": "25-35 min",
    "deliveryFee": "\$2.99",
    "minOrder": "\$15.00",
    "distance": "1.2 mi",
    "address": "123 Main Street, New York, NY 10001",
    "openingHours": "10:00 AM - 10:00 PM",
    "isOpen": true,
    "description":
        "Authentic Italian cuisine with fresh ingredients imported directly from Italy. Our chefs have over 20 years of experience crafting the perfect pizza and pasta dishes.",
  };

  final List<String> restaurantGallery = [
    "https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80",
    "https://images.unsplash.com/photo-1555396273-367ea4eb4db5?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2074&q=80",
    "https://images.unsplash.com/photo-1414235077428-338989a2e8c0?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80",
  ];

  final List<Map<String, dynamic>> menuCategories = [
    {
      "id": 1,
      "name": "Appetizers",
      "description": "Start your meal with our delicious appetizers",
    },
    {
      "id": 2,
      "name": "Pizza",
      "description": "Authentic Italian pizzas made in wood-fired oven",
    },
    {
      "id": 3,
      "name": "Pasta",
      "description": "Homemade pasta with fresh ingredients",
    },
    {
      "id": 4,
      "name": "Main Courses",
      "description": "Hearty Italian main dishes",
    },
    {
      "id": 5,
      "name": "Desserts",
      "description": "Sweet treats to finish your meal",
    },
    {
      "id": 6,
      "name": "Drinks",
      "description": "Refreshing beverages and Italian wines",
    },
  ];

  final List<Map<String, dynamic>> menuItems = [
    {
      "id": 101,
      "categoryId": 1,
      "name": "Bruschetta",
      "description":
          "Grilled bread rubbed with garlic and topped with olive oil, salt, tomato, and basil",
      "price": "\$8.99",
      "imageUrl":
          "https://images.unsplash.com/photo-1572695157366-5e585ab2b69f?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1974&q=80",
      "isPopular": true,
      "isVegetarian": true,
      "isSpicy": false,
      "allergens": ["Gluten"],
    },
    {
      "id": 102,
      "categoryId": 1,
      "name": "Caprese Salad",
      "description":
          "Fresh mozzarella, tomatoes, and basil drizzled with olive oil and balsamic glaze",
      "price": "\$10.99",
      "imageUrl":
          "https://images.unsplash.com/photo-1608897013039-887f21d8c804?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1992&q=80",
      "isPopular": false,
      "isVegetarian": true,
      "isSpicy": false,
      "allergens": ["Dairy"],
    },
    {
      "id": 103,
      "categoryId": 1,
      "name": "Calamari Fritti",
      "description":
          "Crispy fried calamari served with marinara sauce and lemon wedges",
      "price": "\$12.99",
      "imageUrl":
          "https://images.unsplash.com/photo-1599487488170-d11ec9c172f0?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2080&q=80",
      "isPopular": true,
      "isVegetarian": false,
      "isSpicy": false,
      "allergens": ["Seafood", "Gluten"],
    },
    {
      "id": 201,
      "categoryId": 2,
      "name": "Margherita Pizza",
      "description":
          "Classic pizza with tomato sauce, mozzarella, and fresh basil",
      "price": "\$14.99",
      "imageUrl":
          "https://images.unsplash.com/photo-1574071318508-1cdbab80d002?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2069&q=80",
      "isPopular": true,
      "isVegetarian": true,
      "isSpicy": false,
      "allergens": ["Gluten", "Dairy"],
    },
    {
      "id": 202,
      "categoryId": 2,
      "name": "Pepperoni Pizza",
      "description": "Tomato sauce, mozzarella, and spicy pepperoni slices",
      "price": "\$16.99",
      "imageUrl":
          "https://images.unsplash.com/photo-1628840042765-356cda07504e?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1780&q=80",
      "isPopular": true,
      "isVegetarian": false,
      "isSpicy": true,
      "allergens": ["Gluten", "Dairy"],
    },
    {
      "id": 203,
      "categoryId": 2,
      "name": "Quattro Formaggi",
      "description":
          "Four cheese pizza with mozzarella, gorgonzola, fontina, and parmesan",
      "price": "\$18.99",
      "imageUrl":
          "https://images.unsplash.com/photo-1513104890138-7c749659a591?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80",
      "isPopular": false,
      "isVegetarian": true,
      "isSpicy": false,
      "allergens": ["Gluten", "Dairy"],
    },
    {
      "id": 301,
      "categoryId": 3,
      "name": "Spaghetti Carbonara",
      "description":
          "Spaghetti with crispy pancetta, egg, pecorino cheese, and black pepper",
      "price": "\$15.99",
      "imageUrl":
          "https://images.unsplash.com/photo-1612874742237-6526221588e3?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1771&q=80",
      "isPopular": true,
      "isVegetarian": false,
      "isSpicy": false,
      "allergens": ["Gluten", "Dairy", "Eggs"],
    },
    {
      "id": 302,
      "categoryId": 3,
      "name": "Fettuccine Alfredo",
      "description": "Fettuccine pasta in a rich and creamy parmesan sauce",
      "price": "\$14.99",
      "imageUrl":
          "https://images.unsplash.com/photo-1645112411341-6c4fd023882c?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1974&q=80",
      "isPopular": false,
      "isVegetarian": true,
      "isSpicy": false,
      "allergens": ["Gluten", "Dairy"],
    },
    {
      "id": 401,
      "categoryId": 4,
      "name": "Chicken Parmesan",
      "description":
          "Breaded chicken breast topped with marinara sauce and melted mozzarella, served with spaghetti",
      "price": "\$18.99",
      "imageUrl":
          "https://images.unsplash.com/photo-1632778149955-e80f8ceca2e8?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1770&q=80",
      "isPopular": true,
      "isVegetarian": false,
      "isSpicy": false,
      "allergens": ["Gluten", "Dairy"],
    },
    {
      "id": 501,
      "categoryId": 5,
      "name": "Tiramisu",
      "description":
          "Classic Italian dessert with layers of coffee-soaked ladyfingers and mascarpone cream",
      "price": "\$8.99",
      "imageUrl":
          "https://images.unsplash.com/photo-1571877227200-a0d98ea607e9?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1974&q=80",
      "isPopular": true,
      "isVegetarian": true,
      "isSpicy": false,
      "allergens": ["Dairy", "Eggs", "Gluten"],
    },
    {
      "id": 601,
      "categoryId": 6,
      "name": "Italian Soda",
      "description":
          "Refreshing carbonated beverage with your choice of fruit syrup",
      "price": "\$4.99",
      "imageUrl":
          "https://images.unsplash.com/photo-1556881286-fc6915169721?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1974&q=80",
      "isPopular": false,
      "isVegetarian": true,
      "isSpicy": false,
      "allergens": [],
    },
  ];

  final List<Map<String, dynamic>> reviews = [
    {
      "id": 1,
      "userName": "Sarah Johnson",
      "userImage": "https://randomuser.me/api/portraits/women/12.jpg",
      "rating": 5,
      "date": "2 days ago",
      "comment":
          "Absolutely amazing food! The Margherita pizza was authentic and delicious. Service was quick and friendly. Will definitely order again!",
      "images": [
        "https://images.unsplash.com/photo-1574071318508-1cdbab80d002?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2069&q=80",
      ],
      "likes": 24,
    },
    {
      "id": 2,
      "userName": "Michael Rodriguez",
      "userImage": "https://randomuser.me/api/portraits/men/32.jpg",
      "rating": 4,
      "date": "1 week ago",
      "comment":
          "Great pasta dishes and the tiramisu was exceptional. Delivery was a bit slow but the food quality made up for it.",
      "images": [],
      "likes": 12,
    },
    {
      "id": 3,
      "userName": "Emily Chen",
      "userImage": "https://randomuser.me/api/portraits/women/33.jpg",
      "rating": 5,
      "date": "2 weeks ago",
      "comment":
          "The Quattro Formaggi pizza is to die for! Perfect cheese blend and crispy crust. Highly recommend!",
      "images": [
        "https://images.unsplash.com/photo-1513104890138-7c749659a591?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80",
      ],
      "likes": 18,
    },
  ];
}

// SliverAppBarDelegate for TabBar
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
