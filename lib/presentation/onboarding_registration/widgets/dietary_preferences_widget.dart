import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class DietaryPreferencesWidget extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final Map<String, dynamic> userData;
  final Function(String, dynamic) onUpdateUserData;
  final VoidCallback onComplete;

  const DietaryPreferencesWidget({
    Key? key,
    required this.formKey,
    required this.userData,
    required this.onUpdateUserData,
    required this.onComplete,
  }) : super(key: key);

  @override
  State<DietaryPreferencesWidget> createState() =>
      _DietaryPreferencesWidgetState();
}

class _DietaryPreferencesWidgetState extends State<DietaryPreferencesWidget> {
  final List<String> _selectedPreferences = [];

  @override
  void initState() {
    super.initState();
    _selectedPreferences
        .addAll(List<String>.from(widget.userData['dietaryPreferences'] ?? []));
  }

  void _togglePreference(String preference) {
    setState(() {
      if (_selectedPreferences.contains(preference)) {
        _selectedPreferences.remove(preference);
      } else {
        _selectedPreferences.add(preference);
      }
    });
    widget.onUpdateUserData('dietaryPreferences', _selectedPreferences);
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
                'Dietary Preferences',
                style: AppTheme.lightTheme.textTheme.displaySmall,
              ),
              const SizedBox(height: 8),
              Text(
                'Help us personalize your food recommendations',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.gray500,
                ),
              ),

              const SizedBox(height: 16),

              // Optional step note
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.info.withAlpha(26),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  'Optional',
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: AppTheme.info,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Dietary preferences grid
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.5,
                children: [
                  _buildPreferenceCard(
                    title: 'Vegetarian',
                    icon: 'spa',
                    color: Colors.green,
                  ),
                  _buildPreferenceCard(
                    title: 'Vegan',
                    icon: 'eco',
                    color: Colors.green.shade700,
                  ),
                  _buildPreferenceCard(
                    title: 'Gluten-Free',
                    icon: 'grain',
                    color: Colors.amber.shade700,
                  ),
                  _buildPreferenceCard(
                    title: 'Dairy-Free',
                    icon: 'no_drinks',
                    color: Colors.blue,
                  ),
                  _buildPreferenceCard(
                    title: 'Keto',
                    icon: 'egg',
                    color: Colors.purple,
                  ),
                  _buildPreferenceCard(
                    title: 'Low-Carb',
                    icon: 'rice_bowl',
                    color: Colors.orange,
                  ),
                  _buildPreferenceCard(
                    title: 'Halal',
                    icon: 'restaurant',
                    color: Colors.teal,
                  ),
                  _buildPreferenceCard(
                    title: 'Kosher',
                    icon: 'restaurant_menu',
                    color: Colors.indigo,
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Allergies section
              Text(
                'Any food allergies?',
                style: AppTheme.lightTheme.textTheme.titleMedium,
              ),
              const SizedBox(height: 16),

              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'E.g., peanuts, shellfish, etc.',
                  prefixIcon: CustomIconWidget(
                    iconName: 'warning',
                    color: AppTheme.warning,
                  ),
                ),
                onChanged: (value) {
                  widget.onUpdateUserData('allergies', value);
                },
              ),

              const SizedBox(height: 32),

              // Complete button
              ElevatedButton(
                onPressed: widget.onComplete,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(56),
                ),
                child: Text(
                  'Complete Setup',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Skip preferences
              Center(
                child: TextButton(
                  onPressed: widget.onComplete,
                  child: Text(
                    'Skip for now',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.gray500,
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

  Widget _buildPreferenceCard({
    required String title,
    required String icon,
    required Color color,
  }) {
    final bool isSelected = _selectedPreferences.contains(title);

    return InkWell(
      onTap: () => _togglePreference(title),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? color.withAlpha(26) : AppTheme.gray100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : AppTheme.gray200,
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: icon,
              color: isSelected ? color : AppTheme.gray500,
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: isSelected ? color : AppTheme.gray700,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
