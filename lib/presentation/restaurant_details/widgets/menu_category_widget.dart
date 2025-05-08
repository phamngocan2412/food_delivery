import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';
import './dish_card_widget.dart';

class MenuCategoryWidget extends StatefulWidget {
  final Map<String, dynamic> category;
  final List<Map<String, dynamic>> dishes;
  final Function(Map<String, dynamic>) onDishTap;

  const MenuCategoryWidget({
    Key? key,
    required this.category,
    required this.dishes,
    required this.onDishTap,
  }) : super(key: key);

  @override
  State<MenuCategoryWidget> createState() => _MenuCategoryWidgetState();
}

class _MenuCategoryWidgetState extends State<MenuCategoryWidget> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category Header
        GestureDetector(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: AppTheme.gray100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.category['name'],
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (widget.category['description'] != null)
                      Text(
                        widget.category['description'],
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.gray500,
                        ),
                      ),
                  ],
                ),
                CustomIconWidget(
                  iconName:
                      _isExpanded ? 'keyboard_arrow_up' : 'keyboard_arrow_down',
                  color: AppTheme.gray700,
                  size: 24,
                ),
              ],
            ),
          ),
        ),

        // Dishes
        if (_isExpanded)
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.dishes.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              return DishCardWidget(
                dish: widget.dishes[index],
                onTap: () => widget.onDishTap(widget.dishes[index]),
              );
            },
          ),
      ],
    );
  }
}
