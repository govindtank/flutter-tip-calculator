import 'package:flutter/material.dart';
import '../models/calculation.dart';
import '../themes/app_themes.dart';

class RoundingSelector extends StatelessWidget {
  final RoundingOption selected;
  final ValueChanged<RoundingOption> onChanged;

  const RoundingSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  static const List<_RoundingOptionData> options = [
    _RoundingOptionData(
      option: RoundingOption.none,
      label: 'None',
      icon: Icons.remove_circle_outline_rounded,
    ),
    _RoundingOptionData(
      option: RoundingOption.roundUp,
      label: 'Round Up',
      icon: Icons.arrow_upward_rounded,
      prefix: '↑',
    ),
    _RoundingOptionData(
      option: RoundingOption.roundDown,
      label: 'Round Down',
      icon: Icons.arrow_downward_rounded,
      prefix: '↓',
    ),
    _RoundingOptionData(
      option: RoundingOption.roundToNearest,
      label: 'Nearest',
      icon: Icons.attach_money_rounded,
      prefix: '\$1',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: options.map((data) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: data == options.last ? 0 : 8,
            ),
            child: _RoundingChip(
              data: data,
              isSelected: selected == data.option,
              onTap: () => onChanged(data.option),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _RoundingOptionData {
  final RoundingOption option;
  final String label;
  final IconData icon;
  final String? prefix;

  const _RoundingOptionData({
    required this.option,
    required this.label,
    required this.icon,
    this.prefix,
  });
}

class _RoundingChip extends StatelessWidget {
  final _RoundingOptionData data;
  final bool isSelected;
  final VoidCallback onTap;

  const _RoundingChip({
    required this.data,
    required this.isSelected,
    required this.onTap,
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
          child: Center(
            child: Text(
              data.prefix ?? data.label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isSelected ? glass.accent : glass.textSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
