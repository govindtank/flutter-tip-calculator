import 'package:flutter/material.dart';
import '../models/models.dart';
import '../utils/formatters.dart';
import '../themes/app_themes.dart';

class ResultsCard extends StatelessWidget {
  final TipCalculation calculation;
  final Currency currency;
  final VoidCallback? onCopy;
  final VoidCallback? onShare;
  final VoidCallback? onSave;

  const ResultsCard({
    super.key,
    required this.calculation,
    required this.currency,
    this.onCopy,
    this.onShare,
    this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final glass = theme.glass;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: glass.surface.withOpacity(isDark ? 0.8 : 0.95),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: glass.border,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: glass.accent.withOpacity(0.1),
            blurRadius: 40,
            spreadRadius: -10,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Top accent border
          Container(
            height: 3,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  glass.accent.withOpacity(0),
                  glass.accent,
                  glass.accent.withOpacity(0),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Per Person Label
                Text(
                  'PER PERSON',
                  style: theme.textTheme.labelSmall?.copyWith(
                    letterSpacing: 1.5,
                    color: glass.textTertiary,
                  ),
                ),
                const SizedBox(height: 8),
                // Animated Amount
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(
                    begin: calculation.perPersonTotal,
                    end: calculation.perPersonTotal,
                  ),
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, child) {
                    return TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0, end: value),
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeOutCubic,
                      builder: (context, animatedValue, child) {
                        return Text(
                          Formatters.formatCurrencyCompact(
                            animatedValue,
                            currency,
                          ),
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -1.5,
                            color: glass.accent,
                            height: 1.1,
                          ),
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 24),
                // Divider
                Container(
                  height: 1,
                  color: glass.border,
                ),
                const SizedBox(height: 20),
                // Breakdown Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _BreakdownItem(
                      label: 'BILL',
                      value: Formatters.formatCurrencyCompact(
                        calculation.billAmount,
                        currency,
                      ),
                      glass: glass,
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: glass.border,
                    ),
                    _BreakdownItem(
                      label: 'TIP',
                      value: '${calculation.tipPercentage.toInt()}%',
                      glass: glass,
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: glass.border,
                    ),
                    _BreakdownItem(
                      label: 'TOTAL',
                      value: Formatters.formatCurrencyCompact(
                        calculation.totalAmount,
                        currency,
                      ),
                      glass: glass,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Divider
                Container(
                  height: 1,
                  color: glass.border,
                ),
                const SizedBox(height: 20),
                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _ActionButton(
                      icon: Icons.copy_rounded,
                      label: 'Copy',
                      onTap: onCopy,
                      glass: glass,
                    ),
                    const SizedBox(width: 12),
                    _ActionButton(
                      icon: Icons.share_rounded,
                      label: 'Share',
                      onTap: onShare,
                      glass: glass,
                    ),
                    const SizedBox(width: 12),
                    _ActionButton(
                      icon: Icons.star_rounded,
                      label: 'Save',
                      onTap: onSave,
                      glass: glass,
                      isAccent: true,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BreakdownItem extends StatelessWidget {
  final String label;
  final String value;
  final GlassThemeExtension glass;

  const _BreakdownItem({
    required this.label,
    required this.value,
    required this.glass,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.0,
              color: glass.textTertiary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: glass.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final GlassThemeExtension glass;
  final bool isAccent;

  const _ActionButton({
    required this.icon,
    required this.label,
    this.onTap,
    required this.glass,
    this.isAccent = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: isAccent
                ? glass.accent.withOpacity(0.15)
                : const Color(0x0DFFFFFF),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isAccent
                  ? glass.accent.withOpacity(0.5)
                  : glass.border,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 18,
                color: isAccent ? glass.accent : glass.textSecondary,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isAccent ? glass.accent : glass.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
