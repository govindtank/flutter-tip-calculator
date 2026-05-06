import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/models.dart';
import '../services/storage_service.dart';
import '../utils/share_utils.dart';
import '../themes/app_themes.dart';
import '../widgets/widgets.dart';

class HomePage extends StatefulWidget {
  final AppSettings settings;
  final Currency currency;
  final VoidCallback onSettingsTap;

  const HomePage({
    super.key,
    required this.settings,
    required this.currency,
    required this.onSettingsTap,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late double _billAmount;
  late double _tipPercentage;
  late int _numberOfPeople;
  late RoundingOption _roundingOption;

  @override
  void initState() {
    super.initState();
    _billAmount = 0;
    _tipPercentage = widget.settings.defaultTipPercentage.toDouble();
    _numberOfPeople = widget.settings.defaultNumberOfPeople;
    _roundingOption = widget.settings.defaultRounding;
  }

  TipCalculation get _calculation {
    return TipCalculation.calculate(
      billAmount: _billAmount,
      tipPercentage: _tipPercentage,
      numberOfPeople: _numberOfPeople,
      rounding: _roundingOption,
    );
  }

  void _copyToClipboard() {
    final calc = _calculation;
    final text = '''
Bill: ${widget.currency.symbol}${calc.billAmount.toStringAsFixed(2)}
Tip: ${calc.tipPercentage.toInt()}%
Total: ${widget.currency.symbol}${calc.totalAmount.toStringAsFixed(2)}
Per Person: ${widget.currency.symbol}${calc.perPersonTotal.toStringAsFixed(2)}
''';
    Clipboard.setData(ClipboardData(text: text.trim()));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Copied to clipboard'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _share() {
    final calc = _calculation;
    ShareUtils.shareCalculation(calc, widget.currency);
  }

  void _saveCalculation() async {
    final calc = _calculation;
    if (_billAmount > 0) {
      await StorageService.addToHistory(calc);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Saved to history'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Theme.of(context).colorScheme.surface,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final glass = theme.glass;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0D0D0F) : glass.surface,
      body: Stack(
        children: [
          // Background decorations
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    glass.accent.withOpacity(0.08),
                    glass.accent.withOpacity(0),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            left: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    glass.accent.withOpacity(0.05),
                    glass.accent.withOpacity(0),
                  ],
                ),
              ),
            ),
          ),
          // Main content
          SafeArea(
            child: Column(
              children: [
                // App Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'TipCalc',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                      ),
                      IconButton(
                        onPressed: widget.onSettingsTap,
                        icon: Icon(
                          Icons.settings_rounded,
                          color: glass.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                // Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Results Card
                        ResultsCard(
                          calculation: _calculation,
                          currency: widget.currency,
                          onCopy: _copyToClipboard,
                          onShare: _share,
                          onSave: _saveCalculation,
                        ),
                        const SizedBox(height: 32),
                        // Bill Amount
                        _SectionLabel(label: 'BILL AMOUNT'),
                        const SizedBox(height: 8),
                        TipInputField(
                          currency: widget.currency,
                          initialValue: _billAmount,
                          onChanged: (value) {
                            setState(() {
                              _billAmount = value;
                            });
                          },
                        ),
                        const SizedBox(height: 24),
                        // Tip Percentage
                        _SectionLabel(label: 'TIP PERCENTAGE'),
                        const SizedBox(height: 8),
                        TipPresetSelector(
                          selected: _tipPercentage,
                          onChanged: (value) {
                            setState(() {
                              _tipPercentage = value;
                            });
                          },
                          onCustomTap: () {
                            CustomTipSheet.show(
                              context,
                              initialValue: _tipPercentage,
                              onChanged: (value) {
                                setState(() {
                                  _tipPercentage = value;
                                });
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 24),
                        // Split Between
                        _SectionLabel(label: 'SPLIT BETWEEN'),
                        const SizedBox(height: 8),
                        SplitSelector(
                          value: _numberOfPeople,
                          onChanged: (value) {
                            setState(() {
                              _numberOfPeople = value;
                            });
                          },
                        ),
                        const SizedBox(height: 24),
                        // Rounding
                        _SectionLabel(label: 'ROUNDING'),
                        const SizedBox(height: 8),
                        RoundingSelector(
                          selected: _roundingOption,
                          onChanged: (value) {
                            setState(() {
                              _roundingOption = value;
                            });
                          },
                        ),
                        const SizedBox(height: 24),
                        // Quick Actions
                        _SectionLabel(label: 'QUICK ACTIONS'),
                        const SizedBox(height: 8),
                        QuickActionsBar(
                          onRoundToOne: () {
                            setState(() {
                              _roundingOption = RoundingOption.roundToNearest;
                            });
                          },
                          onSplitThree: () {
                            setState(() {
                              _numberOfPeople = 3;
                            });
                          },
                          onTipPlus: () {
                            setState(() {
                              _tipPercentage = (_tipPercentage + 5).clamp(0, 100);
                            });
                          },
                          onTipMinus: () {
                            setState(() {
                              _tipPercentage = (_tipPercentage - 5).clamp(0, 100);
                            });
                          },
                        ),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;

  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final glass = theme.glass;

    return Text(
      label,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.0,
        color: glass.textTertiary,
      ),
    );
  }
}
