import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class LocationPermissionWidget extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final Map<String, dynamic> userData;
  final Function(String, dynamic) onUpdateUserData;
  final VoidCallback onContinue;

  const LocationPermissionWidget({
    Key? key,
    required this.formKey,
    required this.userData,
    required this.onUpdateUserData,
    required this.onContinue,
  }) : super(key: key);

  @override
  State<LocationPermissionWidget> createState() =>
      _LocationPermissionWidgetState();
}

class _LocationPermissionWidgetState extends State<LocationPermissionWidget> {
  final TextEditingController _addressController = TextEditingController();
  bool _locationPermissionGranted = false;

  @override
  void initState() {
    super.initState();
    _addressController.text = widget.userData['location'] ?? '';
    _locationPermissionGranted =
        widget.userData['allowLocationAccess'] ?? false;
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  void _saveFormData() {
    widget.onUpdateUserData('location', _addressController.text);
    widget.onUpdateUserData('allowLocationAccess', _locationPermissionGranted);
  }

  void _requestLocationPermission() {
    // In a real app, this would request actual device location permission
    setState(() {
      _locationPermissionGranted = true;
    });
    widget.onUpdateUserData('allowLocationAccess', true);

    // Simulate getting location
    Future.delayed(const Duration(seconds: 1), () {
      _addressController.text = '123 Main Street, New York, NY 10001';
      widget.onUpdateUserData('location', _addressController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: widget.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                'Set your location',
                style: AppTheme.lightTheme.textTheme.displaySmall,
              ),
              const SizedBox(height: 8),
              Text(
                'Help us serve you better by sharing your location',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.gray500,
                ),
              ),

              const SizedBox(height: 32),

              // Location illustration
              Center(
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withAlpha(26),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: 'location_on',
                      color: AppTheme.primary,
                      size: 80,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Location benefits
              _buildBenefitItem(
                icon: 'delivery_dining',
                title: 'Accurate delivery estimates',
                description:
                    'Get precise delivery times based on your location',
              ),

              const SizedBox(height: 16),

              _buildBenefitItem(
                icon: 'restaurant',
                title: 'Relevant restaurant suggestions',
                description: 'Discover restaurants that deliver to your area',
              ),

              const SizedBox(height: 16),

              _buildBenefitItem(
                icon: 'local_offer',
                title: 'Location-based offers',
                description:
                    'Receive special promotions available in your area',
              ),

              const SizedBox(height: 32),

              // Location permission toggle
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.gray100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: _locationPermissionGranted
                          ? 'check_circle'
                          : 'location_on',
                      color: _locationPermissionGranted
                          ? AppTheme.success
                          : AppTheme.primary,
                      size: 24,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _locationPermissionGranted
                                ? 'Location access granted'
                                : 'Allow location access',
                            style: AppTheme.lightTheme.textTheme.titleMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'We only access your location while using the app',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.gray500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: _locationPermissionGranted,
                      onChanged: (value) {
                        if (value) {
                          _requestLocationPermission();
                        } else {
                          setState(() {
                            _locationPermissionGranted = false;
                            _addressController.clear();
                          });
                          widget.onUpdateUserData('allowLocationAccess', false);
                          widget.onUpdateUserData('location', '');
                        }
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Manual address input
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Delivery Address',
                  prefixIcon: CustomIconWidget(
                    iconName: 'home',
                    color: AppTheme.gray500,
                  ),
                ),
                validator: (value) {
                  if (!_locationPermissionGranted &&
                      (value == null || value.isEmpty)) {
                    return 'Please enter your address or enable location access';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Note about privacy
              Text(
                'Your privacy is important to us. We only use your location to provide better service and never share it with third parties.',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.gray500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBenefitItem({
    required String icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppTheme.primary.withAlpha(26),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: CustomIconWidget(
              iconName: icon,
              color: AppTheme.primary,
              size: 20,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTheme.lightTheme.textTheme.titleSmall,
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.gray500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
