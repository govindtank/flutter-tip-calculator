import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/currency.dart';
import '../themes/app_themes.dart';

class TipInputField extends StatefulWidget {
  final Currency currency;
  final double initialValue;
  final ValueChanged<double> onChanged;

  const TipInputField({
    super.key,
    required this.currency,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  State<TipInputField> createState() => _TipInputFieldState();
}

class _TipInputFieldState extends State<TipInputField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.initialValue > 0
          ? _formatNumber(widget.initialValue)
          : '',
    );
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(TipInputField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue && !_isFocused) {
      _controller.text = widget.initialValue > 0
          ? _formatNumber(widget.initialValue)
          : '';
    }
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  String _formatNumber(double value) {
    if (value == value.truncateToDouble()) {
      return value.truncate().toString().replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (Match m) => '${m[1]},',
          );
    }
    final parts = value.toStringAsFixed(widget.currency.decimalDigits).split('.');
    final intPart = parts[0].replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
    return '${intPart}.${parts[1]}';
  }

  double _parseNumber(String text) {
    final cleanText = text.replaceAll(',', '');
    return double.tryParse(cleanText) ?? 0;
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final glass = theme.glass;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0x0DFFFFFF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isFocused
              ? glass.accent.withOpacity(0.5)
              : glass.border,
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              widget.currency.symbol,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: glass.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w600,
                color: glass.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: '0',
                hintStyle: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                  color: glass.textTertiary,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 20,
                ),
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[\d.,]')),
              ],
              onChanged: (value) {
                final numValue = _parseNumber(value);
                widget.onChanged(numValue);
              },
            ),
          ),
        ],
      ),
    );
  }
}
