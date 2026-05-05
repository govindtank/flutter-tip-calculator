import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TipPresetSelector extends StatefulWidget {
  final double selectedPercentage;
  final ValueChanged<double> onPercentageChanged;

  const TipPresetSelector({
    super.key,
    required this.selectedPercentage,
    required this.onPercentageChanged,
  });

  @override
  State<TipPresetSelector> createState() => _TipPresetSelectorState();
}

class _TipPresetSelectorState extends State<TipPresetSelector> {
  static const List<double> presets = [0, 10, 15, 18, 20, 25];

  void _showCustomSlider(BuildContext context) {
    final theme = Theme.of(context);
    double customValue = widget.selectedPercentage;
    
    if (!presets.contains(widget.selectedPercentage)) {
      customValue = widget.selectedPercentage.clamp(0.0, 50.0);
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurface.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Custom Tip Percentage',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                '${customValue.toStringAsFixed(0)}%',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 24),
              SliderTheme(
                data: SliderThemeData(
                  activeTrackColor: theme.colorScheme.primary,
                  inactiveTrackColor: theme.colorScheme.primary.withOpacity(0.2),
                  thumbColor: theme.colorScheme.primary,
                  overlayColor: theme.colorScheme.primary.withOpacity(0.1),
                  trackHeight: 8,
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 14),
                ),
                child: Slider(
                  value: customValue,
                  min: 0,
                  max: 50,
                  divisions: 50,
                  onChanged: (value) {
                    HapticFeedback.selectionClick();
                    setModalState(() {
                      customValue = value;
                    });
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '0%',
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                  Text(
                    '50%',
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    widget.onPercentageChanged(customValue);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Apply',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isCustom = !presets.contains(widget.selectedPercentage);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Tip %',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ...presets.map((percentage) => Padding(
                padding: const EdgeInsets.only(right: 10),
                child: _PresetButton(
                  percentage: percentage,
                  isSelected: widget.selectedPercentage == percentage,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    widget.onPercentageChanged(percentage);
                  },
                ),
              )),
              _PresetButton(
                percentage: null,
                isSelected: isCustom,
                customText: isCustom 
                    ? '${widget.selectedPercentage.toStringAsFixed(0)}%'
                    : 'Custom',
                onTap: () => _showCustomSlider(context),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PresetButton extends StatefulWidget {
  final double? percentage;
  final bool isSelected;
  final String? customText;
  final VoidCallback onTap;

  const _PresetButton({
    required this.percentage,
    required this.isSelected,
    this.customText,
    required this.onTap,
  });

  @override
  State<_PresetButton> createState() => _PresetButtonState();
}

class _PresetButtonState extends State<_PresetButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: widget.isSelected ? primaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: widget.isSelected ? primaryColor : primaryColor.withOpacity(0.4),
              width: 2,
            ),
            boxShadow: widget.isSelected
                ? [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Text(
            widget.customText ?? '${widget.percentage!.toInt()}%',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: widget.isSelected
                  ? Colors.white
                  : primaryColor,
            ),
          ),
        ),
      ),
    );
  }
}
