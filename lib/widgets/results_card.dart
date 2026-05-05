import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/models.dart';
import '../utils/formatters.dart';
import '../utils/share_utils.dart';

class ResultsCard extends StatefulWidget {
  final TipCalculation? calculation;
  final Currency currency;
  final VoidCallback? onShare;
  final VoidCallback? onSave;
  final VoidCallback? onCopy;

  const ResultsCard({
    super.key,
    this.calculation,
    required this.currency,
    this.onShare,
    this.onSave,
    this.onCopy,
  });

  @override
  State<ResultsCard> createState() => _ResultsCardState();
}

class _ResultsCardState extends State<ResultsCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _counterController;
  late Animation<double> _counterAnimation;
  double _displayValue = 0;

  @override
  void initState() {
    super.initState();
    _counterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _counterAnimation = CurvedAnimation(
      parent: _counterController,
      curve: Curves.easeOutCubic,
    );
    _counterController.addListener(() {
      setState(() {
        _displayValue = _counterAnimation.value * (widget.calculation?.perPersonTotal ?? 0);
      });
    });
  }

  @override
  void didUpdateWidget(ResultsCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.calculation?.perPersonTotal != widget.calculation?.perPersonTotal) {
      _counterController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _counterController.dispose();
    super.dispose();
  }

  void _copyToClipboard() {
    if (widget.calculation != null) {
      Clipboard.setData(ClipboardData(
        text: Formatters.formatCurrency(widget.calculation!.perPersonTotal, widget.currency),
      ));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Copied to clipboard!'),
          duration: Duration(seconds: 2),
        ),
      );
    }
    widget.onCopy?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final primaryLight = theme.colorScheme.secondary;

    final hasCalculation = widget.calculation != null && widget.calculation!.billAmount > 0;
    final calc = widget.calculation;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primaryColor,
            primaryLight,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Container(
        margin: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(21),
          color: theme.colorScheme.surface,
        ),
        child: Column(
          children: [
            // Per Person Amount Section
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Text(
                    'Per Person',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 8),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Text(
                      Formatters.formatCurrency(_displayValue, widget.currency),
                      key: ValueKey(calc?.perPersonTotal ?? 0),
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                  ),
                  if (calc != null && calc.numberOfPeople > 1)
                    Text(
                      'Split ${calc.numberOfPeople} ways',
                      style: TextStyle(
                        fontSize: 14,
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _ActionButton(
                        icon: Icons.copy_rounded,
                        label: 'Copy',
                        onTap: hasCalculation ? _copyToClipboard : null,
                      ),
                      const SizedBox(width: 16),
                      _ActionButton(
                        icon: Icons.share_rounded,
                        label: 'Share',
                        onTap: hasCalculation
                            ? () {
                                ShareUtils.shareCalculation(calc!, widget.currency);
                                widget.onShare?.call();
                              }
                            : null,
                      ),
                      const SizedBox(width: 16),
                      _ActionButton(
                        icon: Icons.favorite_border_rounded,
                        label: 'Save',
                        onTap: hasCalculation ? widget.onSave : null,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Divider
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    primaryColor.withOpacity(0.2),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            // Breakdown Section
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  _BreakdownRow(
                    label: 'Bill Subtotal',
                    value: Formatters.formatCurrency(calc?.billAmount ?? 0, widget.currency),
                  ),
                  const SizedBox(height: 12),
                  _BreakdownRow(
                    label: 'Tip Amount',
                    value: '${Formatters.formatPercentage(calc?.tipPercentage ?? 0)} (${Formatters.formatCurrency(calc?.tipAmount ?? 0, widget.currency)})',
                  ),
                  const SizedBox(height: 12),
                  _BreakdownRow(
                    label: 'Total Amount',
                    value: Formatters.formatCurrency(calc?.totalAmount ?? 0, widget.currency),
                    isBold: true,
                  ),
                  if (calc != null && calc.numberOfPeople > 1) ...[
                    const SizedBox(height: 12),
                    _BreakdownRow(
                      label: 'Per Person Tip',
                      value: Formatters.formatCurrency(calc.perPersonTip, widget.currency),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final isEnabled = onTap != null;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
              color: isEnabled
                  ? primaryColor
                  : theme.colorScheme.onSurface.withOpacity(0.3),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isEnabled
                    ? primaryColor
                    : theme.colorScheme.onSurface.withOpacity(0.3),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BreakdownRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;

  const _BreakdownRow({
    required this.label,
    required this.value,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
            color: theme.colorScheme.onSurface.withOpacity(isBold ? 1 : 0.7),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
