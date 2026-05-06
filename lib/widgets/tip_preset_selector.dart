import 'package:flutter/material.dart';
import '../themes/app_themes.dart';

class TipPresetSelector extends StatelessWidget {
  final double selected;
  final ValueChanged<double> onChanged;
  final VoidCallback onCustomTap;

  const TipPresetSelector({
    super.key,
    required this.selected,
    required this.onChanged,
    required this.onCustomTap,
  });

  static const List<double> presets = [0, 10, 15, 18, 20, 25];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final pct in presets)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _GlassPillChip(
                label: '${pct.toInt()}%',
                isSelected: selected == pct,
                onTap: () => onChanged(pct),
              ),
            ),
          _GlassPillChip(
            label: 'Custom',
            isSelected: !presets.contains(selected),
            onTap: onCustomTap,
            trailingIcon: Icons.arrow_forward_ios_rounded,
          ),
        ],
      ),
    );
  }
}

class _GlassPillChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData? trailingIcon;

  const _GlassPillChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.trailingIcon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final glass = theme.glass;
    final isDark = theme.brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: isSelected
                ? glass.accent.withOpacity(isDark ? 0.15 : 0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? glass.accent.withOpacity(isDark ? 0.8 : 0.5)
                  : glass.border,
              width: 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: glass.accent.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? glass.accent : glass.textSecondary,
                ),
              ),
              if (trailingIcon != null) ...[
                const SizedBox(width: 4),
                Icon(
                  trailingIcon,
                  size: 12,
                  color: isSelected ? glass.accent : glass.textTertiary,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class CustomTipSheet extends StatefulWidget {
  final double initialValue;
  final ValueChanged<double> onChanged;

  const CustomTipSheet({
    super.key,
    required this.initialValue,
    required this.onChanged,
  });

  static Future<void> show(
    BuildContext context, {
    required double initialValue,
    required ValueChanged<double> onChanged,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => CustomTipSheet(
        initialValue: initialValue,
        onChanged: onChanged,
      ),
    );
  }

  @override
  State<CustomTipSheet> createState() => _CustomTipSheetState();
}

class _CustomTipSheetState extends State<CustomTipSheet> {
  late double _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final glass = theme.glass;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: glass.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border.all(color: glass.border),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: glass.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              // Title
              Text(
                'CUSTOM TIP',
                style: theme.textTheme.labelSmall?.copyWith(
                  letterSpacing: 1.5,
                  color: glass.textTertiary,
                ),
              ),
              const SizedBox(height: 16),
              // Value Display
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: _value, end: _value),
                duration: const Duration(milliseconds: 100),
                builder: (context, value, child) {
                  return Text(
                    '${value.toInt()}%',
                    style: TextStyle(
                      fontSize: 56,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -1.5,
                      color: glass.accent,
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),
              // Slider
              SliderTheme(
                data: SliderThemeData(
                  trackHeight: 8,
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 14,
                  ),
                  overlayShape: const RoundSliderOverlayShape(
                    overlayRadius: 24,
                  ),
                  activeTrackColor: glass.accent,
                  inactiveTrackColor: glass.border,
                  thumbColor: glass.accent,
                  overlayColor: glass.accent.withOpacity(0.2),
                ),
                child: Slider(
                  value: _value,
                  min: 0,
                  max: 50,
                  divisions: 50,
                  onChanged: (value) {
                    setState(() {
                      _value = value;
                    });
                    widget.onChanged(value);
                  },
                ),
              ),
              const SizedBox(height: 8),
              // Labels
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '0%',
                    style: TextStyle(
                      fontSize: 12,
                      color: glass.textTertiary,
                    ),
                  ),
                  Text(
                    '50%',
                    style: TextStyle(
                      fontSize: 12,
                      color: glass.textTertiary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Done Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: glass.accent,
                    foregroundColor: isDark ? Colors.white : Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Done',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
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
}
