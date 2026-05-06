import 'package:flutter/material.dart';
import '../themes/app_themes.dart';

class QuickActionsBar extends StatelessWidget {
  final VoidCallback onRoundToOne;
  final VoidCallback onSplitThree;
  final VoidCallback onTipPlus;
  final VoidCallback onTipMinus;

  const QuickActionsBar({
    super.key,
    required this.onRoundToOne,
    required this.onSplitThree,
    required this.onTipPlus,
    required this.onTipMinus,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _QuickActionChip(
            icon: Icons.attach_money_rounded,
            label: 'Round to \$1',
            onTap: onRoundToOne,
          ),
          const SizedBox(width: 8),
          _QuickActionChip(
            icon: Icons.group_add_rounded,
            label: 'Split 3',
            onTap: onSplitThree,
          ),
          const SizedBox(width: 8),
          _QuickActionChip(
            icon: Icons.add_rounded,
            label: 'Tip +5%',
            onTap: onTipPlus,
          ),
          const SizedBox(width: 8),
          _QuickActionChip(
            icon: Icons.remove_rounded,
            label: 'Tip -5%',
            onTap: onTipMinus,
          ),
        ],
      ),
    );
  }
}

class _QuickActionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionChip({
    required this.icon,
    required this.label,
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
          height: 36,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: glass.accent.withOpacity(isDark ? 0.08 : 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: glass.accent.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 16,
                color: glass.accent,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: glass.accent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
