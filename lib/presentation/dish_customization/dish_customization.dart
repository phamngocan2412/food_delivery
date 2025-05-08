import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../../widgets/custom_icon_widget.dart';
import '../../widgets/custom_image_widget.dart';
import './widgets/add_on_item_widget.dart';
import './widgets/quantity_selector_widget.dart';
import './widgets/size_option_widget.dart';
import './widgets/spice_level_widget.dart';

class DishCustomizationScreen extends StatefulWidget {
  const DishCustomizationScreen({Key? key}) : super(key: key);

  @override
  State<DishCustomizationScreen> createState() =>
      _DishCustomizationScreenState();
}

class _DishCustomizationScreenState extends State<DishCustomizationScreen> {
  // Selected options
  String _selectedSize = 'Medium';
  int _quantity = 1;
  String _selectedSpiceLevel = 'Medium';
  final List<String> _selectedAddOns = [];
  final TextEditingController _specialInstructionsController =
      TextEditingController();

  // Validation
  bool _showValidationErrors = false;

  // Base price and total
  double _basePrice = 12.99;
  double _totalPrice = 12.99;

  @override
  void initState() {
    super.initState();
    _calculateTotalPrice();
  }

  @override
  void dispose() {
    _specialInstructionsController.dispose();
    super.dispose();
  }

  void _calculateTotalPrice() {
    double total = _basePrice;

    // Add size price
    if (_selectedSize == 'Small') {
      total -= 2.00;
    } else if (_selectedSize == 'Large') {
      total += 3.00;
    }

    // Add add-ons price
    for (String addOn in _selectedAddOns) {
      final addOnItem = addOns.firstWhere((item) => item['name'] == addOn);
      total += addOnItem['price'] as double;
    }

    // Multiply by quantity
    total *= _quantity;

    setState(() {
      _totalPrice = total;
    });
  }

  bool _validateSelections() {
    // Check if required selections are made
    bool isValid = _selectedSize.isNotEmpty && _selectedSpiceLevel.isNotEmpty;

    setState(() {
      _showValidationErrors = !isValid;
    });

    return isValid;
  }

  void _addToCart() {
    if (_validateSelections()) {
      // Show confirmation
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$_quantity ${dishDetails['name']} added to cart'),
          backgroundColor: AppTheme.success,
          behavior: SnackBarBehavior.floating,
        ),
      );

      // Navigate to cart or back to restaurant
      Future.delayed(const Duration(milliseconds: 1500), () {
        Navigator.pushNamed(context, '/cart-checkout');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with Hero Image
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(230),
                  shape: BoxShape.circle,
                ),
                child: CustomIconWidget(
                  iconName: 'arrow_back',
                  color: AppTheme.gray900,
                  size: 24,
                ),
              ),
              onPressed: () =>
                  Navigator.pushNamed(context, '/restaurant-details'),
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(230),
                    shape: BoxShape.circle,
                  ),
                  child: CustomIconWidget(
                    iconName: 'favorite_border',
                    color: AppTheme.gray900,
                    size: 24,
                  ),
                ),
                onPressed: () {},
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  CustomImageWidget(
                    imageUrl: dishDetails['imageUrl'],
                    fit: BoxFit.cover,
                  ),
                  // Gradient overlay for better text visibility
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: 80,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withAlpha(179),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Dish Name and Price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              dishDetails['name'],
                              style: AppTheme.lightTheme.textTheme.displaySmall,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              dishDetails['category'],
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                color: AppTheme.gray500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '\$${_basePrice.toStringAsFixed(2)}',
                        style:
                            AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                          color: AppTheme.primary,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Description
                  Text(
                    dishDetails['description'],
                    style: AppTheme.lightTheme.textTheme.bodyMedium,
                  ),

                  const SizedBox(height: 24),

                  // Divider
                  const Divider(height: 1),

                  const SizedBox(height: 24),

                  // Size Selection (Required)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Size',
                            style: AppTheme.lightTheme.textTheme.titleMedium,
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppTheme.primary.withAlpha(26),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'Required',
                              style: AppTheme.lightTheme.textTheme.labelSmall
                                  ?.copyWith(
                                color: AppTheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (_showValidationErrors && _selectedSize.isEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            'Please select a size',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.error,
                            ),
                          ),
                        ),
                      const SizedBox(height: 16),
                      SizeOptionWidget(
                        sizes: sizes,
                        selectedSize: _selectedSize,
                        onSizeSelected: (size) {
                          setState(() {
                            _selectedSize = size;
                          });
                          _calculateTotalPrice();
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Spice Level Selection (Required)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Spice Level',
                            style: AppTheme.lightTheme.textTheme.titleMedium,
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppTheme.primary.withAlpha(26),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'Required',
                              style: AppTheme.lightTheme.textTheme.labelSmall
                                  ?.copyWith(
                                color: AppTheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (_showValidationErrors && _selectedSpiceLevel.isEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            'Please select a spice level',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.error,
                            ),
                          ),
                        ),
                      const SizedBox(height: 16),
                      SpiceLevelWidget(
                        spiceLevels: spiceLevels,
                        selectedLevel: _selectedSpiceLevel,
                        onLevelSelected: (level) {
                          setState(() {
                            _selectedSpiceLevel = level;
                          });
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Add-ons (Optional)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Add-ons',
                            style: AppTheme.lightTheme.textTheme.titleMedium,
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppTheme.gray200,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'Optional',
                              style: AppTheme.lightTheme.textTheme.labelSmall
                                  ?.copyWith(
                                color: AppTheme.gray700,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: addOns.length,
                        itemBuilder: (context, index) {
                          final addOn = addOns[index];
                          return AddOnItemWidget(
                            name: addOn['name'],
                            price: addOn['price'],
                            isSelected: _selectedAddOns.contains(addOn['name']),
                            onToggle: (isSelected) {
                              setState(() {
                                if (isSelected) {
                                  _selectedAddOns.add(addOn['name']);
                                } else {
                                  _selectedAddOns.remove(addOn['name']);
                                }
                              });
                              _calculateTotalPrice();
                            },
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Special Instructions
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Special Instructions',
                        style: AppTheme.lightTheme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _specialInstructionsController,
                        maxLines: 3,
                        maxLength: 200,
                        decoration: InputDecoration(
                          hintText:
                              'Any special requests? (e.g., allergies, preferences)',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: AppTheme.gray300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                BorderSide(color: AppTheme.primary, width: 2),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 100), // Space for bottom bar
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(13),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              // Quantity Selector
              QuantitySelectorWidget(
                quantity: _quantity,
                onChanged: (quantity) {
                  setState(() {
                    _quantity = quantity;
                  });
                  _calculateTotalPrice();
                },
              ),
              const SizedBox(width: 16),

              // Add to Cart Button
              Expanded(
                child: ElevatedButton(
                  onPressed: _addToCart,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    'Add to Cart - \$${_totalPrice.toStringAsFixed(2)}',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Mock Data
  final Map<String, dynamic> dishDetails = {
    "id": 1,
    "name": "Margherita Pizza",
    "category": "Italian • Pizza",
    "description":
        "Classic Margherita pizza with fresh mozzarella, tomatoes, and basil on a thin, crispy crust. Made with our signature tomato sauce and topped with extra virgin olive oil.",
    "imageUrl":
        "https://images.unsplash.com/photo-1604382354936-07c5d9983bd3?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2000&q=80",
    "basePrice": 12.99,
  };

  final List<Map<String, dynamic>> sizes = [
    {
      "name": "Small",
      "description": "8 inch (Serves 1)",
      "priceAdjustment": -2.00,
    },
    {
      "name": "Medium",
      "description": "12 inch (Serves 2)",
      "priceAdjustment": 0.00,
    },
    {
      "name": "Large",
      "description": "16 inch (Serves 3-4)",
      "priceAdjustment": 3.00,
    },
  ];

  final List<Map<String, dynamic>> spiceLevels = [
    {
      "name": "Mild",
      "icon": "local_fire_department",
      "color": Color(0xFFFEF3C7),
      "textColor": Color(0xFFD97706),
    },
    {
      "name": "Medium",
      "icon": "local_fire_department",
      "color": Color(0xFFFED7AA),
      "textColor": Color(0xFFC2410C),
    },
    {
      "name": "Hot",
      "icon": "local_fire_department",
      "color": Color(0xFFFEE2E2),
      "textColor": Color(0xFFB91C1C),
    },
    {
      "name": "Extra Hot",
      "icon": "whatshot",
      "color": Color(0xFFFECACA),
      "textColor": Color(0xFF7F1D1D),
    },
  ];

  final List<Map<String, dynamic>> addOns = [
    {
      "name": "Extra Cheese",
      "price": 1.50,
    },
    {
      "name": "Mushrooms",
      "price": 1.00,
    },
    {
      "name": "Pepperoni",
      "price": 1.50,
    },
    {
      "name": "Olives",
      "price": 1.00,
    },
    {
      "name": "Bell Peppers",
      "price": 1.00,
    },
    {
      "name": "Onions",
      "price": 0.75,
    },
    {
      "name": "Garlic Dip",
      "price": 0.50,
    },
  ];
}
