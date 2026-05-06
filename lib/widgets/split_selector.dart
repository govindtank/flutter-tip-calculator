import 'dart:async';
import 'package:flutter/material.dart';
import '../themes/app_themes.dart';

class SplitSelector extends StatefulWidget {
  final int value;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;

  const SplitSelector({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 1,
    this.max = 50,
  });

  @override
  State<SplitSelector> createState() => _SplitSelectorState();
}

class _SplitSelectorState extends State<SplitSelector> {
  Timer? _longPressTimer;
  int _incrementDirection = 0;

  void _startLongPress(int direction) {
    _incrementDirection = direction;
    _longPressTimer?.cancel();
    _longPressTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      final newValue = widget.value + _incrementDirection;
      if (newValue >= widget.min && newValue <= widget.max) {
        widget.onChanged(newValue);
      }
    });
  }

  void _stopLongPress() {
    _longPressTimer?.cancel();
    _longPressTimer = null;
    _incrementDirection = 0;
  }

  void _increment() {
    if (widget.value < widget.max) {
      widget.onChanged(widget.value + 1);
    }
  }

  void _decrement() {
    if (widget.value > widget.min) {
      widget.onChanged(widget.value - 1);
    }
  }

  @override
  void dispose() {
    _longPressTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final glass = theme.glass;
    final isDark = theme.brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Minus Button
        GestureDetector(
          onTap: _decrement,
          onLongPressStart: (_) => _startLongPress(-1),
          onLongPressEnd: (_) => _stopLongPress(),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0x0DFFFFFF),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: glass.border,
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.remove_rounded,
              size: 24,
              color: widget.value > widget.min
                  ? glass.textPrimary
                  : glass.textTertiary,
            ),
          ),
        ),
        const SizedBox(width: 24),
        // Number Display
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.5),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  )),
                  child: FadeTransition(
                    opacity: animation,
                    child: child,
                  ),
                );
              },
              child: Text(
                '${widget.value}',
                key: ValueKey(widget.value),
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1,
                  color: glass.accent,
                  height: 1,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.value == 1 ? 'person' : 'people',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: glass.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(width: 24),
        // Plus Button
        GestureDetector(
          onTap: _increment,
          onLongPressStart: (_) => _startLongPress(1),
          onLongPressEnd: (_) => _stopLongPress(),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0x0DFFFFFF),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: glass.border,
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.add_rounded,
              size: 24,
              color: widget.value < widget.max
                  ? glass.textPrimary
                  : glass.textTertiary,
            ),
          ),
        ),
      ],
    );
  }
}
