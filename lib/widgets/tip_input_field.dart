import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../models/models.dart';

class TipInputField extends StatefulWidget {
  final Currency currency;
  final ValueChanged<double?> onChanged;
  final double? initialValue;

  const TipInputField({
    super.key,
    required this.currency,
    required this.onChanged,
    this.initialValue,
  });

  @override
  State<TipInputField> createState() => _TipInputFieldState();
}

class _TipInputFieldState extends State<TipInputField>
    with SingleTickerProviderStateMixin {
  late TextEditingController _controller;
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;
  bool _hasError = false;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.initialValue != null && widget.initialValue! > 0
          ? _formatNumber(widget.initialValue!)
          : '',
    );
    
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    
    _shakeAnimation = Tween<double>(begin: 0, end: 10)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(_shakeController);
  }

  @override
  void dispose() {
    _controller.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  String _formatNumber(double value) {
    final formatter = NumberFormat('#,##0.00', 'en_US');
    return formatter.format(value);
  }

  double? _parseNumber(String text) {
    if (text.isEmpty) return null;
    final cleanText = text.replaceAll(',', '').replaceAll(' ', '');
    return double.tryParse(cleanText);
  }

  void _onTextChanged(String value) {
    final number = _parseNumber(value);
    setState(() {
      _hasError = false;
    });
    widget.onChanged(number);
  }

  void _onSubmitted(String value) {
    final number = _parseNumber(value);
    if (number == null || number <= 0) {
      setState(() {
        _hasError = true;
      });
      _shakeController.forward().then((_) => _shakeController.reverse());
    } else if (number > 999999.99) {
      setState(() {
        _hasError = true;
      });
      _shakeController.forward().then((_) => _shakeController.reverse());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    
    return AnimatedBuilder(
      animation: _shakeAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_shakeAnimation.value * (_shakeAnimation.value > 5 ? -1 : 1), 0),
          child: child,
        );
      },
      child: Focus(
        onFocusChange: (focused) {
          setState(() {
            _isFocused = focused;
          });
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bill Amount',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 8),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: _isFocused
                    ? [
                        BoxShadow(
                          color: primaryColor.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: TextField(
                controller: _controller,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                  _ThousandsSeparatorFormatter(),
                ],
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 16, right: 8),
                    child: Text(
                      widget.currency.symbol,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                  ),
                  prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                  hintText: '0.00',
                  hintStyle: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface.withOpacity(0.3),
                  ),
                  filled: true,
                  fillColor: theme.colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: _hasError ? Colors.red : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: _hasError
                          ? Colors.red.withOpacity(0.5)
                          : theme.colorScheme.onSurface.withOpacity(0.1),
                      width: 2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: _hasError ? Colors.red : primaryColor,
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                ),
                onChanged: _onTextChanged,
                onSubmitted: _onSubmitted,
              ),
            ),
            if (_hasError)
              Padding(
                padding: const EdgeInsets.only(top: 8, left: 4),
                child: Text(
                  'Please enter a valid amount (0.01 - 999,999.99)',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.red[400],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ThousandsSeparatorFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Handle decimal part
    String text = newValue.text;
    String decimalPart = '';
    
    if (text.contains('.')) {
      final parts = text.split('.');
      text = parts[0];
      decimalPart = '.${parts[1]}';
    }

    // Format the integer part with commas
    final number = int.tryParse(text);
    if (number == null) {
      return newValue;
    }

    final formatted = NumberFormat('#,###', 'en_US').format(number);
    
    return TextEditingValue(
      text: formatted + decimalPart,
      selection: TextSelection.collapsed(
        offset: (formatted + decimalPart).length,
      ),
    );
  }
}
