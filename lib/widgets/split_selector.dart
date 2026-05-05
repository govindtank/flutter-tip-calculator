import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplitSelector extends StatefulWidget {
  final int count;
  final ValueChanged<int> onChanged;
  final int minCount;
  final int maxCount;

  const SplitSelector({
    super.key,
    required this.count,
    required this.onChanged,
    this.minCount = 1,
    this.maxCount = 50,
  });

  @override
  State<SplitSelector> createState() => _SplitSelectorState();
}

class _SplitSelectorState extends State<SplitSelector>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _slideAnimation;
  bool _isIncrementing = false;
  bool _isDecrementing = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _slideAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void didUpdateWidget(SplitSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.count != widget.count) {
      _controller.forward().then((_) => _controller.reset());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _increment() {
    if (widget.count < widget.maxCount) {
      HapticFeedback.lightImpact();
      widget.onChanged(widget.count + 1);
    } else {
      HapticFeedback.heavyImpact();
    }
  }

  void _decrement() {
    if (widget.count > widget.minCount) {
      HapticFeedback.lightImpact();
      widget.onChanged(widget.count - 1);
    } else {
      HapticFeedback.heavyImpact();
    }
  }

  void _startIncrement() {
    setState(() => _isIncrementing = true);
    _increment();
    _startContinuousIncrement();
  }

  void _startDecrement() {
    setState(() => _isDecrementing = true);
    _decrement();
    _startContinuousDecrement();
  }

  void _startContinuousIncrement() {
    Future.delayed(const Duration(milliseconds: 150), () {
      if (_isIncrementing && widget.count < widget.maxCount) {
        widget.onChanged(widget.count + 1);
        _startContinuousIncrement();
      }
    });
  }

  void _startContinuousDecrement() {
    Future.delayed(const Duration(milliseconds: 150), () {
      if (_isDecrementing && widget.count > widget.minCount) {
        widget.onChanged(widget.count - 1);
        _startContinuousDecrement();
      }
    });
  }

  void _stopContinuous() {
    setState(() {
      _isIncrementing = false;
      _isDecrementing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Split Between',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: theme.colorScheme.onSurface.withOpacity(0.1),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _CircleButton(
                icon: Icons.remove,
                onTap: _decrement,
                onLongPressStart: (_) => _startDecrement(),
                onLongPressEnd: (_) => _stopContinuous(),
                enabled: widget.count > widget.minCount,
                color: primaryColor,
              ),
              const SizedBox(width: 24),
              AnimatedBuilder(
                animation: _slideAnimation,
                builder: (context, child) {
                  return SizedBox(
                    width: 80,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        if (_controller.isAnimating)
                          Transform.translate(
                            offset: Offset(
                              0,
                              -20 * (1 - _slideAnimation.value),
                            ),
                            child: Opacity(
                              opacity: 1 - _slideAnimation.value,
                              child: Text(
                                '${widget.count - 1}',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.onSurface.withOpacity(0.3),
                                ),
                              ),
                            ),
                          ),
                        Text(
                          '${widget.count}',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(width: 24),
              _CircleButton(
                icon: Icons.add,
                onTap: _increment,
                onLongPressStart: (_) => _startIncrement(),
                onLongPressEnd: (_) => _stopContinuous(),
                enabled: widget.count < widget.maxCount,
                color: primaryColor,
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Text(
              widget.count == 1 ? 'person' : 'people',
              key: ValueKey(widget.count),
              style: TextStyle(
                fontSize: 14,
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CircleButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Function(LongPressStartDetails) onLongPressStart;
  final Function(LongPressEndDetails) onLongPressEnd;
  final bool enabled;
  final Color color;

  const _CircleButton({
    required this.icon,
    required this.onTap,
    required this.onLongPressStart,
    required this.onLongPressEnd,
    required this.enabled,
    required this.color,
  });

  @override
  State<_CircleButton> createState() => _CircleButtonState();
}

class _CircleButtonState extends State<_CircleButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      onLongPressStart: widget.onLongPressStart,
      onLongPressEnd: widget.onLongPressEnd,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.enabled
                ? widget.color.withOpacity(0.1)
                : widget.color.withOpacity(0.05),
            border: Border.all(
              color: widget.enabled
                  ? widget.color.withOpacity(0.3)
                  : widget.color.withOpacity(0.1),
              width: 2,
            ),
          ),
          child: Icon(
            widget.icon,
            color: widget.enabled
                ? widget.color
                : widget.color.withOpacity(0.3),
            size: 24,
          ),
        ),
      ),
    );
  }
}
