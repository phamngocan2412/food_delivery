import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/loyalty_status_widget.dart';
import './widgets/profile_header_widget.dart';
import './widgets/settings_section_widget.dart';

class UserProfileSettings extends StatefulWidget {
  const UserProfileSettings({Key? key}) : super(key: key);

  @override
  State<UserProfileSettings> createState() => _UserProfileSettingsState();
}

class _UserProfileSettingsState extends State<UserProfileSettings> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Profile & Settings'),
        leading: IconButton(
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.gray700,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Simulate data refresh
          await Future.delayed(const Duration(seconds: 1));
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Header
                const ProfileHeaderWidget(
                  name: 'Sarah Johnson',
                  email: 'sarah.johnson@example.com',
                  memberSince: 'Member since Oct 2022',
                  imageUrl: 'https://randomuser.me/api/portraits/women/44.jpg',
                ),

                const SizedBox(height: 24),

                // Loyalty Status
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: LoyaltyStatusWidget(
                    currentPoints: 750,
                    nextTierPoints: 1000,
                    currentTier: 'Silver',
                    nextTier: 'Gold',
                  ),
                ),

                const SizedBox(height: 24),

                // Saved Addresses
                SettingsSectionWidget(
                  title: 'Saved Addresses',
                  icon: 'location_on',
                  iconColor: AppTheme.info,
                  children: [
                    _buildAddressItem(
                      'Home',
                      '123 Main Street, Apt 4B, New York, NY 10001',
                      true,
                    ),
                    _buildAddressItem(
                      'Work',
                      '456 Business Ave, Suite 200, New York, NY 10002',
                      false,
                    ),
                    _buildAddButton('Add New Address'),
                  ],
                ),

                const SizedBox(height: 16),

                // Payment Methods
                SettingsSectionWidget(
                  title: 'Payment Methods',
                  icon: 'credit_card',
                  iconColor: AppTheme.success,
                  children: [
                    _buildPaymentMethodItem(
                      'Visa ending in 4242',
                      'Expires 05/25',
                      true,
                    ),
                    _buildPaymentMethodItem(
                      'Mastercard ending in 8353',
                      'Expires 12/24',
                      false,
                    ),
                    _buildAddButton('Add Payment Method'),
                  ],
                ),

                const SizedBox(height: 16),

                // Notification Preferences
                SettingsSectionWidget(
                  title: 'Notification Preferences',
                  icon: 'notifications',
                  iconColor: AppTheme.warning,
                  children: [
                    _buildSwitchItem(
                      'Order Updates',
                      'Receive notifications about your orders',
                      true,
                      (value) {
                        _showToast(
                            'Order updates ${value ? 'enabled' : 'disabled'}');
                      },
                    ),
                    _buildSwitchItem(
                      'Promotions & Offers',
                      'Receive notifications about deals and discounts',
                      false,
                      (value) {
                        _showToast(
                            'Promotions ${value ? 'enabled' : 'disabled'}');
                      },
                    ),
                    _buildSwitchItem(
                      'Recommendations',
                      'Receive personalized food recommendations',
                      true,
                      (value) {
                        _showToast(
                            'Recommendations ${value ? 'enabled' : 'disabled'}');
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Dietary Preferences
                SettingsSectionWidget(
                  title: 'Dietary Preferences',
                  icon: 'restaurant',
                  iconColor: AppTheme.primary,
                  children: [
                    _buildDietaryPreferenceItem('Vegetarian'),
                    _buildDietaryPreferenceItem('Gluten-Free'),
                    _buildDietaryPreferenceItem('Dairy-Free'),
                    _buildDietaryPreferenceItem('Vegan'),
                    _buildDietaryPreferenceItem('Nut Allergy'),
                  ],
                ),

                const SizedBox(height: 16),

                // Account Settings
                SettingsSectionWidget(
                  title: 'Account Settings',
                  icon: 'settings',
                  iconColor: AppTheme.gray700,
                  children: [
                    _buildSettingsItem(
                      'Change Password',
                      'Update your account password',
                      () {
                        _showChangePasswordDialog();
                      },
                    ),
                    _buildSettingsItem(
                      'Language',
                      'English (US)',
                      () {
                        _showLanguageSelectionDialog();
                      },
                    ),
                    _buildSwitchItem(
                      'Dark Mode',
                      'Switch between light and dark themes',
                      _isDarkMode,
                      (value) {
                        setState(() {
                          _isDarkMode = value;
                        });
                        _showToast(
                            'Dark mode ${value ? 'enabled' : 'disabled'}');
                      },
                    ),
                    _buildSettingsItem(
                      'Privacy Settings',
                      'Manage your data and privacy preferences',
                      () {
                        // Navigate to privacy settings
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Help & Support
                SettingsSectionWidget(
                  title: 'Help & Support',
                  icon: 'help',
                  iconColor: AppTheme.info,
                  children: [
                    _buildSettingsItem(
                      'FAQs',
                      'Frequently asked questions',
                      () {
                        // Navigate to FAQs
                      },
                    ),
                    _buildSettingsItem(
                      'Contact Support',
                      'Get help with your account or orders',
                      () {
                        // Navigate to contact support
                      },
                    ),
                    _buildSettingsItem(
                      'Report an Issue',
                      'Let us know about problems with an order',
                      () {
                        // Navigate to report issue
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Logout Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        _showLogoutConfirmationDialog();
                      },
                      icon: CustomIconWidget(
                        iconName: 'logout',
                        color: AppTheme.error,
                        size: 20,
                      ),
                      label: Text(
                        'Log Out',
                        style: TextStyle(
                          color: AppTheme.error,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppTheme.error),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Delete Account
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextButton(
                    onPressed: () {
                      _showDeleteAccountDialog();
                    },
                    child: Text(
                      'Delete Account',
                      style: TextStyle(
                        color: AppTheme.error,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // App Version
                Center(
                  child: Text(
                    'App Version 1.0.0',
                    style: TextStyle(
                      color: AppTheme.gray500,
                      fontSize: 12,
                    ),
                  ),
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 4, // Profile tab is selected
        onTap: (index) {
          if (index != 4) {
            // Navigate to other tabs
            if (index == 0) {
              Navigator.pushReplacementNamed(context, '/home-screen');
            }
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'home',
              color: AppTheme.gray500,
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
              color: AppTheme.primary,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  // Helper methods to build UI components
  Widget _buildAddressItem(String title, String address, bool isDefault) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppTheme.gray50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDefault ? AppTheme.primary : AppTheme.gray200,
          width: isDefault ? 2 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: AppTheme.lightTheme.textTheme.titleMedium,
                    ),
                    if (isDefault)
                      Container(
                        margin: const EdgeInsets.only(left: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppTheme.primary.withAlpha(26),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Default',
                          style: TextStyle(
                            color: AppTheme.primary,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: CustomIconWidget(
                        iconName: 'edit',
                        color: AppTheme.gray500,
                        size: 20,
                      ),
                      onPressed: () {
                        // Edit address
                      },
                      constraints: const BoxConstraints(),
                      padding: const EdgeInsets.all(8),
                    ),
                    IconButton(
                      icon: CustomIconWidget(
                        iconName: 'delete',
                        color: AppTheme.error,
                        size: 20,
                      ),
                      onPressed: () {
                        // Delete address
                      },
                      constraints: const BoxConstraints(),
                      padding: const EdgeInsets.all(8),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              address,
              style: TextStyle(
                color: AppTheme.gray700,
                fontSize: 14,
              ),
            ),
            if (!isDefault)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    _showToast('Address set as default');
                  },
                  child: Text(
                    'Set as Default',
                    style: TextStyle(
                      color: AppTheme.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodItem(
      String title, String subtitle, bool isDefault) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppTheme.gray50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDefault ? AppTheme.primary : AppTheme.gray200,
          width: isDefault ? 2 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.gray200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: title.toLowerCase().contains('visa')
                      ? 'credit_card'
                      : 'credit_card',
                  color: AppTheme.gray700,
                  size: 24,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: AppTheme.lightTheme.textTheme.titleSmall,
                      ),
                      if (isDefault)
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppTheme.primary.withAlpha(26),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Default',
                            style: TextStyle(
                              color: AppTheme.primary,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: AppTheme.gray500,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                if (!isDefault)
                  TextButton(
                    onPressed: () {
                      _showToast('Payment method set as default');
                    },
                    child: Text(
                      'Set Default',
                      style: TextStyle(
                        color: AppTheme.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                IconButton(
                  icon: CustomIconWidget(
                    iconName: 'delete',
                    color: AppTheme.error,
                    size: 20,
                  ),
                  onPressed: () {
                    // Delete payment method
                  },
                  constraints: const BoxConstraints(),
                  padding: const EdgeInsets.all(8),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchItem(String title, String subtitle, bool initialValue,
      Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.lightTheme.textTheme.titleSmall,
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: AppTheme.gray500,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: initialValue,
            onChanged: onChanged,
            activeColor: AppTheme.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildDietaryPreferenceItem(String preference) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              preference,
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
          ),
          Checkbox(
            value: preference == 'Vegetarian' || preference == 'Gluten-Free',
            onChanged: (value) {
              _showToast(
                  '${preference} preference ${value! ? 'added' : 'removed'}');
            },
            activeColor: AppTheme.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem(String title, String subtitle, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.lightTheme.textTheme.titleSmall,
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: AppTheme.gray500,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            CustomIconWidget(
              iconName: 'chevron_right',
              color: AppTheme.gray500,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddButton(String label) {
    return TextButton.icon(
      onPressed: () {
        // Add new item
      },
      icon: CustomIconWidget(
        iconName: 'add',
        color: AppTheme.primary,
        size: 20,
      ),
      label: Text(
        label,
        style: TextStyle(
          color: AppTheme.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 8),
        alignment: Alignment.centerLeft,
      ),
    );
  }

  // Dialog methods
  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Change Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Current Password',
                  hintText: 'Enter your current password',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'New Password',
                  hintText: 'Enter your new password',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirm New Password',
                  hintText: 'Confirm your new password',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _showToast('Password updated successfully');
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void _showLanguageSelectionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Language'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildLanguageOption('English (US)', true),
              _buildLanguageOption('Spanish', false),
              _buildLanguageOption('French', false),
              _buildLanguageOption('German', false),
              _buildLanguageOption('Chinese', false),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _showToast('Language updated to English (US)');
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLanguageOption(String language, bool isSelected) {
    return InkWell(
      onTap: () {
        // Select language
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: Text(
                language,
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
            ),
            if (isSelected)
              CustomIconWidget(
                iconName: 'check',
                color: AppTheme.primary,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  void _showLogoutConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Log Out'),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _showToast('Logged out successfully');
                // Navigate to login screen
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.error,
              ),
              child: const Text('Log Out'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Account'),
          content: const Text(
            'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently lost.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _showConfirmDeleteAccountDialog();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.error,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _showConfirmDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Please type "DELETE" to confirm account deletion:',
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Type DELETE',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _showToast('Account deleted successfully');
                // Navigate to login screen
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.error,
              ),
              child: const Text('Confirm Delete'),
            ),
          ],
        );
      },
    );
  }

  void _showToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
