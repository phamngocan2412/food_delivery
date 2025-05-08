import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class RegistrationFormWidget extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final Map<String, dynamic> userData;
  final Function(String, dynamic) onUpdateUserData;
  final VoidCallback onContinue;

  const RegistrationFormWidget({
    Key? key,
    required this.formKey,
    required this.userData,
    required this.onUpdateUserData,
    required this.onContinue,
  }) : super(key: key);

  @override
  State<RegistrationFormWidget> createState() => _RegistrationFormWidgetState();
}

class _RegistrationFormWidgetState extends State<RegistrationFormWidget> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  bool _obscurePassword = true;
  String _selectedRegistrationType = 'email'; // 'email', 'phone', 'social'

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.userData['email'] ?? '';
    _passwordController.text = widget.userData['password'] ?? '';
    _nameController.text = widget.userData['name'] ?? '';
    _phoneController.text = widget.userData['phone'] ?? '';
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _saveFormData() {
    widget.onUpdateUserData('email', _emailController.text);
    widget.onUpdateUserData('password', _passwordController.text);
    widget.onUpdateUserData('name', _nameController.text);
    widget.onUpdateUserData('phone', _phoneController.text);
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
                'Create your account',
                style: AppTheme.lightTheme.textTheme.displaySmall,
              ),
              const SizedBox(height: 8),
              Text(
                'Join us to start ordering from your favorite restaurants',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.gray500,
                ),
              ),

              const SizedBox(height: 32),

              // Registration type tabs
              Row(
                children: [
                  _buildRegistrationTypeTab(
                    title: 'Email',
                    type: 'email',
                    icon: 'email',
                  ),
                  const SizedBox(width: 12),
                  _buildRegistrationTypeTab(
                    title: 'Phone',
                    type: 'phone',
                    icon: 'phone',
                  ),
                  const SizedBox(width: 12),
                  _buildRegistrationTypeTab(
                    title: 'Social',
                    type: 'social',
                    icon: 'person',
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Registration form based on selected type
              if (_selectedRegistrationType == 'email') ...[
                // Name field
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: CustomIconWidget(
                      iconName: 'person',
                      color: AppTheme.gray500,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Email field
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email Address',
                    prefixIcon: CustomIconWidget(
                      iconName: 'email',
                      color: AppTheme.gray500,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Password field
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const CustomIconWidget(
                      iconName: 'lock',
                      color: AppTheme.gray500,
                    ),
                    suffixIcon: IconButton(
                      icon: CustomIconWidget(
                        iconName:
                            _obscurePassword ? 'visibility' : 'visibility_off',
                        color: AppTheme.gray500,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
              ] else if (_selectedRegistrationType == 'phone') ...[
                // Name field
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: CustomIconWidget(
                      iconName: 'person',
                      color: AppTheme.gray500,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Phone field
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    prefixIcon: CustomIconWidget(
                      iconName: 'phone',
                      color: AppTheme.gray500,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    if (!RegExp(r'^\+?[0-9]{10,15}$').hasMatch(value)) {
                      return 'Please enter a valid phone number';
                    }
                    return null;
                  },
                ),
              ] else if (_selectedRegistrationType == 'social') ...[
                // Social login buttons
                _buildSocialLoginButton(
                  icon: 'g',
                  title: 'Continue with Google',
                  color: Colors.red.shade600,
                  backgroundColor: Colors.red.shade50,
                ),

                const SizedBox(height: 16),

                _buildSocialLoginButton(
                  icon: 'facebook',
                  title: 'Continue with Facebook',
                  color: Colors.blue.shade800,
                  backgroundColor: Colors.blue.shade50,
                ),

                const SizedBox(height: 16),

                _buildSocialLoginButton(
                  icon: 'apple',
                  title: 'Continue with Apple',
                  color: Colors.black,
                  backgroundColor: Colors.grey.shade200,
                ),
              ],

              const SizedBox(height: 32),

              // Terms and conditions
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'By continuing, you agree to our Terms of Service and Privacy Policy',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.gray500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Already have an account
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account?',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.gray700,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigate to login screen
                    },
                    child: Text(
                      'Log in',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRegistrationTypeTab({
    required String title,
    required String type,
    required String icon,
  }) {
    final bool isSelected = _selectedRegistrationType == type;

    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedRegistrationType = type;
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color:
                isSelected ? AppTheme.primary.withAlpha(26) : AppTheme.gray100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppTheme.primary : AppTheme.gray200,
              width: 1.5,
            ),
          ),
          child: Column(
            children: [
              CustomIconWidget(
                iconName: icon,
                color: isSelected ? AppTheme.primary : AppTheme.gray500,
                size: 24,
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: isSelected ? AppTheme.primary : AppTheme.gray700,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialLoginButton({
    required String icon,
    required String title,
    required Color color,
    required Color backgroundColor,
  }) {
    return ElevatedButton(
      onPressed: () {
        // Handle social login
        widget.formKey.currentState?.validate();
        widget.onContinue();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: color,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: icon,
            color: color,
            size: 24,
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
