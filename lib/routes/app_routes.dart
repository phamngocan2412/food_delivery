import 'package:flutter/material.dart';
import '../presentation/home_screen/home_screen.dart';
import '../presentation/dish_customization/dish_customization.dart';
import '../presentation/user_profile_settings/user_profile_settings.dart';
import '../presentation/cart_checkout/cart_checkout.dart';
import '../presentation/restaurant_details/restaurant_details.dart';
import '../presentation/order_tracking/order_tracking.dart';
import '../presentation/order_history_reordering/order_history_reordering.dart';
import '../presentation/onboarding_registration/onboarding_registration.dart';
import '../presentation/search_filters/search_filters.dart';

class AppRoutes {
  static const String initial = '/';
  static const String homeScreen = '/home-screen';
  static const String dishCustomization = '/dish-customization';
  static const String userProfileSettings = '/user-profile-settings';
  static const String cartCheckout = '/cart-checkout';
  static const String restaurantDetails = '/restaurant-details';
  static const String orderTracking = '/order-tracking';
  static const String orderHistoryReordering = '/order-history-reordering';
  static const String onboardingRegistration = '/onboarding-registration';
  static const String searchFilters = '/search-filters';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) =>
        const HomeScreen(), // Using HomeScreen as initial for now
    homeScreen: (context) => const HomeScreen(),
    dishCustomization: (context) => const DishCustomizationScreen(),
    userProfileSettings: (context) => const UserProfileSettings(),
    cartCheckout: (context) => const CartCheckoutScreen(),
    restaurantDetails: (context) => const RestaurantDetailsScreen(),
    orderTracking: (context) => const OrderTrackingScreen(),
    orderHistoryReordering: (context) => const OrderHistoryReorderingScreen(),
    onboardingRegistration: (context) => const OnboardingRegistrationScreen(),
    searchFilters: (context) => const SearchFiltersScreen(),
  };
}
