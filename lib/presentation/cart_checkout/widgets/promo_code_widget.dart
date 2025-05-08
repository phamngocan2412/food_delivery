import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class PromoCodeWidget extends StatefulWidget {
  final Function(String) onApplyPromo;
  final String? appliedCode;

  const PromoCodeWidget({
    Key? key,
    required this.onApplyPromo,
    this.appliedCode,
  }) : super(key: key);

  @override
  State<PromoCodeWidget> createState() => _PromoCodeWidgetState();
}

class _PromoCodeWidgetState extends State<PromoCodeWidget> {
  final TextEditingController _promoController = TextEditingController();
  bool _isExpanded = false;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Promo Code Header
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'local_offer',
                      color: AppTheme.warning,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Promo Code',
                      style: AppTheme.lightTheme.textTheme.titleMedium,
                    ),
                  ],
                ),
                if (widget.appliedCode != null)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.success.withAlpha(26),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomIconWidget(
                          iconName: 'check_circle',
                          color: AppTheme.success,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          widget.appliedCode!,
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.success,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  CustomIconWidget(
                    iconName: _isExpanded
                        ? 'keyboard_arrow_up'
                        : 'keyboard_arrow_down',
                    color: AppTheme.gray500,
                    size: 24,
                  ),
              ],
            ),
          ),

          // Expanded Promo Code Input
          if (_isExpanded && widget.appliedCode == null) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _promoController,
                    decoration: InputDecoration(
                      hintText: 'Enter promo code',
                      errorText: _errorMessage,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(12),
                        child: CustomIconWidget(
                          iconName: 'confirmation_number',
                          color: AppTheme.gray500,
                          size: 20,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    ),
                    textCapitalization: TextCapitalization.characters,
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _isLoading ? null : _applyPromoCode,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    backgroundColor: AppTheme.warning,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Apply'),
                ),
              ],
            ),
          ],

          // Applied Promo Code Details
          if (widget.appliedCode != null) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Discount applied: \$5.00',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.success,
                  ),
                ),
                TextButton(
                  onPressed: _removePromoCode,
                  style: TextButton.styleFrom(
                    foregroundColor: AppTheme.error,
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(40, 20),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'Remove',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.error,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  void _applyPromoCode() {
    final code = _promoController.text.trim();
    if (code.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a promo code';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Simulate API call to validate promo code
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        if (code == 'WELCOME50' || code == 'SAVE5') {
          widget.onApplyPromo(code);
          setState(() {
            _isLoading = false;
            _isExpanded = false;
          });
        } else {
          setState(() {
            _isLoading = false;
            _errorMessage = 'Invalid promo code';
          });
        }
      }
    });
  }

  void _removePromoCode() {
    widget.onApplyPromo('');
  }
}
