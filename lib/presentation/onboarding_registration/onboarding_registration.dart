import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/dietary_preferences_widget.dart';
import './widgets/location_permission_widget.dart';
import './widgets/onboarding_page_widget.dart';
import './widgets/progress_indicator_widget.dart';
import './widgets/registration_form_widget.dart';

class OnboardingRegistrationScreen extends StatefulWidget {
  const OnboardingRegistrationScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingRegistrationScreen> createState() =>
      _OnboardingRegistrationScreenState();
}

class _OnboardingRegistrationScreenState
    extends State<OnboardingRegistrationScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 4;

  // Form keys for validation
  final GlobalKey<FormState> _registrationFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _locationFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _preferencesFormKey = GlobalKey<FormState>();

  // User data
  final Map<String, dynamic> _userData = {
    "email": "",
    "password": "",
    "name": "",
    "phone": "",
    "location": "",
    'allowLocationAccess': false,
    'dietaryPreferences': <String>[],
  };

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToNextPage() {
    // Validate current page before proceeding
    if (_currentPage == 1 && !_validateRegistrationForm()) return;
    if (_currentPage == 2 && !_validateLocationForm()) return;

    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Complete onboarding and navigate to home
      _completeOnboarding();
    }
  }

  void _goToPreviousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  bool _validateRegistrationForm() {
    return _registrationFormKey.currentState?.validate() ?? false;
  }

  bool _validateLocationForm() {
    return _locationFormKey.currentState?.validate() ?? false;
  }

  void _updateUserData(String key, dynamic value) {
    setState(() {
      _userData[key] = value;
    });
  }

  void _skipOnboarding() {
    Navigator.pushReplacementNamed(context, '/home-screen');
  }

  void _completeOnboarding() {
    // Here you would typically save user data to a backend or local storage
    // For now, we'll just navigate to the home screen
    Navigator.pushReplacementNamed(context, '/home-screen');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip button and progress indicator
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back button (hidden on first page)
                  _currentPage > 0
                      ? IconButton(
                          icon: CustomIconWidget(
                            iconName: 'arrow_back',
                            color: AppTheme.gray700,
                          ),
                          onPressed: _goToPreviousPage,
                        )
                      : const SizedBox(width: 48),

                  // Progress indicator
                  ProgressIndicatorWidget(
                    currentStep: _currentPage + 1,
                    totalSteps: _totalPages,
                  ),

                  // Skip button
                  TextButton(
                    onPressed: _skipOnboarding,
                    child: Text(
                      'Skip',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Main content
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const ClampingScrollPhysics(),
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                children: [
                  // Welcome/Onboarding page
                  OnboardingPageWidget(
                    onContinue: _goToNextPage,
                  ),

                  // Registration page
                  RegistrationFormWidget(
                    formKey: _registrationFormKey,
                    userData: _userData,
                    onUpdateUserData: _updateUserData,
                    onContinue: _goToNextPage,
                  ),

                  // Location permission page
                  LocationPermissionWidget(
                    formKey: _locationFormKey,
                    userData: _userData,
                    onUpdateUserData: _updateUserData,
                    onContinue: _goToNextPage,
                  ),

                  // Dietary preferences page
                  DietaryPreferencesWidget(
                    formKey: _preferencesFormKey,
                    userData: _userData,
                    onUpdateUserData: _updateUserData,
                    onComplete: _completeOnboarding,
                  ),
                ],
              ),
            ),

            // Bottom navigation buttons
            if (_currentPage < _totalPages - 1)
              Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: _goToNextPage,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(56),
                  ),
                  child: Text(
                    _currentPage == 0 ? 'Get Started' : 'Continue',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
