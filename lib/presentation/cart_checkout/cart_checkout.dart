import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/cart_item_widget.dart';
import './widgets/checkout_progress_widget.dart';
import './widgets/delivery_details_widget.dart';
import './widgets/order_summary_widget.dart';
import './widgets/payment_method_widget.dart';
import './widgets/promo_code_widget.dart';

class CartCheckoutScreen extends StatefulWidget {
  const CartCheckoutScreen({Key? key}) : super(key: key);

  @override
  State<CartCheckoutScreen> createState() => _CartCheckoutScreenState();
}

class _CartCheckoutScreenState extends State<CartCheckoutScreen> {
  int _currentStep = 0;
  final List<String> _steps = ['Cart', 'Delivery', 'Payment', 'Review'];
  bool _isLoading = false;
  String _selectedPaymentMethod = 'Credit Card';
  String? _appliedPromoCode;
  bool _termsAccepted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        leading: IconButton(
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.gray700,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? _buildLoadingIndicator()
          : Stack(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 80),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Progress Indicator
                        CheckoutProgressWidget(
                          steps: _steps,
                          currentStep: _currentStep,
                        ),

                        const SizedBox(height: 16),

                        // Order Items Section
                        _buildOrderItemsSection(),

                        const SizedBox(height: 16),

                        // Delivery Details Section
                        DeliveryDetailsWidget(
                          deliveryAddress: deliveryAddress,
                          estimatedTime: '25-35 min',
                          onChangeAddress: () {
                            // Navigate to address selection screen
                          },
                          onSwitchToPickup: () {
                            // Switch to pickup mode
                          },
                        ),

                        const SizedBox(height: 16),

                        // Payment Method Section
                        if (_currentStep >= 2) ...[
                          PaymentMethodWidget(
                            paymentMethods: paymentMethods,
                            selectedMethod: _selectedPaymentMethod,
                            onMethodSelected: (method) {
                              setState(() {
                                _selectedPaymentMethod = method;
                              });
                            },
                          ),
                          const SizedBox(height: 16),
                        ],

                        // Promo Code Section
                        PromoCodeWidget(
                          onApplyPromo: (code) {
                            setState(() {
                              _appliedPromoCode = code;
                            });
                          },
                          appliedCode: _appliedPromoCode,
                        ),

                        const SizedBox(height: 16),

                        // Order Summary Section
                        OrderSummaryWidget(
                          subtotal: 27.98,
                          deliveryFee: 2.99,
                          tax: 2.50,
                          discount: _appliedPromoCode != null ? 5.00 : 0.00,
                          total: _calculateTotal(),
                        ),

                        const SizedBox(height: 16),

                        // Terms and Conditions
                        if (_currentStep >= 3)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                Checkbox(
                                  value: _termsAccepted,
                                  onChanged: (value) {
                                    setState(() {
                                      _termsAccepted = value ?? false;
                                    });
                                  },
                                ),
                                Expanded(
                                  child: Text(
                                    'I agree to the Terms & Conditions and Privacy Policy',
                                    style:
                                        AppTheme.lightTheme.textTheme.bodySmall,
                                  ),
                                ),
                              ],
                            ),
                          ),

                        const SizedBox(height: 80), // Space for bottom button
                      ],
                    ),
                  ),
                ),

                // Fixed Bottom Button
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
                          color: Colors.black.withAlpha(13),
                          blurRadius: 10,
                          offset: const Offset(0, -5),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed:
                          _isLoading || (_currentStep == 3 && !_termsAccepted)
                              ? null
                              : () => _handleContinue(),
                      child: Text(_getButtonText()),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildOrderItemsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Your Order',
                style: AppTheme.lightTheme.textTheme.titleMedium,
              ),
              TextButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/restaurant-details');
                },
                icon: CustomIconWidget(
                  iconName: 'add',
                  color: AppTheme.primary,
                  size: 18,
                ),
                label: Text(
                  'Add More Items',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: cartItems.length,
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) {
            return CartItemWidget(
              item: cartItems[index],
              onQuantityChanged: (quantity) {
                setState(() {
                  cartItems[index]['quantity'] = quantity;
                });
              },
              onRemove: () {
                setState(() {
                  cartItems.removeAt(index);
                });
              },
            );
          },
        ),
        if (cartItems.isEmpty)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Column(
                children: [
                  CustomIconWidget(
                    iconName: 'shopping_cart',
                    color: AppTheme.gray300,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Your cart is empty',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: AppTheme.gray500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/home-screen');
                    },
                    child: const Text('Browse Restaurants'),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  String _getButtonText() {
    switch (_currentStep) {
      case 0:
        return 'Continue to Delivery';
      case 1:
        return 'Continue to Payment';
      case 2:
        return 'Review Order';
      case 3:
        return 'Place Order';
      default:
        return 'Continue';
    }
  }

  void _handleContinue() {
    if (_currentStep < 3) {
      setState(() {
        _currentStep++;
      });
    } else {
      _placeOrder();
    }
  }

  void _placeOrder() {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        // Navigate to order tracking
        Navigator.pushNamed(context, '/order-tracking');
      }
    });
  }

  double _calculateTotal() {
    double subtotal = 27.98;
    double deliveryFee = 2.99;
    double tax = 2.50;
    double discount = _appliedPromoCode != null ? 5.00 : 0.00;

    return subtotal + deliveryFee + tax - discount;
  }

  // Mock Data
  final List<Map<String, dynamic>> cartItems = [
    {
      "id": 1,
      "name": "Margherita Pizza",
      "price": 12.99,
      "quantity": 1,
      "image":
          "https://images.unsplash.com/photo-1513104890138-7c749659a591?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80",
      "customizations": ["Extra Cheese", "Thin Crust"],
      "restaurantName": "Pizza Paradise",
    },
    {
      "id": 2,
      "name": "Garlic Breadsticks",
      "price": 4.99,
      "quantity": 2,
      "image":
          "https://images.pexels.com/photos/1070053/pexels-photo-1070053.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
      "customizations": ["Extra Garlic Dip"],
      "restaurantName": "Pizza Paradise",
    },
    {
      "id": 3,
      "name": "Chocolate Brownie",
      "price": 5.99,
      "quantity": 1,
      "image":
          "https://images.pexels.com/photos/45202/brownie-dessert-cake-sweet-45202.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
      "customizations": ["Add Ice Cream"],
      "restaurantName": "Pizza Paradise",
    },
  ];

  final Map<String, dynamic> deliveryAddress = {
    "address": "123 Main Street, Apt 4B",
    "city": "New York",
    "state": "NY",
    "zipCode": "10001",
    "instructions": "Please leave at the door",
    "coordinates": {
      "latitude": 40.7128,
      "longitude": -74.0060,
    },
  };

  final List<Map<String, dynamic>> paymentMethods = [
    {
      "id": 1,
      "type": "Credit Card",
      "details": "**** **** **** 4242",
      "icon": "credit_card",
      "isDefault": true,
    },
    {
      "id": 2,
      "type": "PayPal",
      "details": "johndoe@example.com",
      "icon": "account_balance_wallet",
      "isDefault": false,
    },
    {
      "id": 3,
      "type": "Apple Pay",
      "details": "iPhone",
      "icon": "phone_iphone",
      "isDefault": false,
    },
    {
      "id": 4,
      "type": "Cash on Delivery",
      "details": "Pay when you receive your order",
      "icon": "payments",
      "isDefault": false,
    },
  ];
}
