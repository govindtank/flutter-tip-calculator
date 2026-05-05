import 'package:flutter/material.dart';
import '../models/models.dart';

class QuickActionsBar extends StatelessWidget {
  final TipCalculation? calculation;
  final Currency currency;
  final Function(TipCalculation) onCalculationChanged;

  const QuickActionsBar({
    super.key,
    this.calculation,
    required this.currency,
    required this.onCalculationChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasCalculation = calculation != null && calculation!.billAmount > 0;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: hasCalculation ? 1.0 : 0.3,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Row(
          children: [
            _QuickActionChip(
              icon: Icons.attach_money_rounded,
              label: 'Round to \$1',
              onTap: hasCalculation
                  ? () {
                      final calc = calculation!;
                      onCalculationChanged(calc.copyWith(
                        rounding: calc.rounding == RoundingOption.roundToNearest
                            ? RoundingOption.none
                            : RoundingOption.roundToNearest,
                      ));
                    }
                  : null,
              isActive: calculation?.rounding == RoundingOption.roundToNearest,
            ),
            const SizedBox(width: 8),
            _QuickActionChip(
              icon: Icons.group_add_rounded,
              label: 'Split 3 ways',
              onTap: hasCalculation
                  ? () {
                      final calc = calculation!;
                      onCalculationChanged(calc.copyWith(
                        numberOfPeople: calc.numberOfPeople == 3 ? 1 : 3,
                      ));
                    }
                  : null,
              isActive: calculation?.numberOfPeople == 3,
            ),
            const SizedBox(width: 8),
            _QuickActionChip(
              icon: Icons.person_add_alt_1_rounded,
              label: 'Add person',
              onTap: hasCalculation && calculation!.numberOfPeople < 50
                  ? () {
                      final calc = calculation!;
                      onCalculationChanged(calc.copyWith(
                        numberOfPeople: calc.numberOfPeople + 1,
                      ));
                    }
                  : null,
            ),
            const SizedBox(width: 8),
            _QuickActionChip(
              icon: Icons.volunteer_activism_rounded,
              label: 'Double tip',
              onTap: hasCalculation
                  ? () {
                      final calc = calculation!;
                      onCalculationChanged(calc.copyWith(
                        tipPercentage: (calc.tipPercentage * 2).clamp(0, 100),
                      ));
                    }
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool isActive;

  const _QuickActionChip({
    required this.icon,
    required this.label,
    this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final isEnabled = onTap != null;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: isActive
                ? primaryColor.withOpacity(0.15)
                : theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isActive
                  ? primaryColor
                  : theme.colorScheme.onSurface.withOpacity(0.15),
              width: isActive ? 2 : 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 18,
                color: isActive
                    ? primaryColor
                    : isEnabled
                        ? theme.colorScheme.onSurface.withOpacity(0.7)
                        : theme.colorScheme.onSurface.withOpacity(0.3),
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                  color: isActive
                      ? primaryColor
                      : isEnabled
                          ? theme.colorScheme.onSurface
                          : theme.colorScheme.onSurface.withOpacity(0.3),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
