import 'package:flutter/material.dart';
import '../models/models.dart';
import '../utils/formatters.dart';
import '../widgets/widgets.dart';

class HomePage extends StatefulWidget {
  final Currency currency;
  final VoidCallback onNavigateToHistory;
  final VoidCallback onNavigateToSettings;

  const HomePage({
    super.key,
    required this.currency,
    required this.onNavigateToHistory,
    required this.onNavigateToSettings,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double _billAmount = 0;
  double _tipPercentage = 18;
  int _numberOfPeople = 1;
  RoundingOption _rounding = RoundingOption.none;
  TipCalculation? _calculation;

  @override
  void initState() {
    super.initState();
    _calculate();
  }

  void _calculate() {
    // Always calculate — show results even when bill is 0
    _calculation = TipCalculation.calculate(
      billAmount: _billAmount,
      tipPercentage: _tipPercentage,
      numberOfPeople: _numberOfPeople,
      rounding: _rounding,
    );
    setState(() {});
  }

  void _onBillChanged(double? amount) {
    setState(() {
      _billAmount = amount ?? 0;
    });
    _calculate();
  }

  void _onTipChanged(double percentage) {
    setState(() {
      _tipPercentage = percentage;
    });
    _calculate();
  }

  void _onSplitChanged(int count) {
    setState(() {
      _numberOfPeople = count;
    });
    _calculate();
  }

  void _onRoundingChanged(RoundingOption rounding) {
    setState(() {
      _rounding = rounding;
    });
    _calculate();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Scaffold(
      body: Stack(
        children: [
          // ── Layer 1: Rich gradient background ──
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: const [0.0, 0.3, 0.7, 1.0],
                colors: [
                  primaryColor.withOpacity(0.12),
                  primaryColor.withOpacity(0.05),
                  theme.scaffoldBackgroundColor,
                  theme.scaffoldBackgroundColor,
                ],
              ),
            ),
          ),

          // ── Layer 2: Decorative floating circles ──
          Positioned(
            top: -60,
            right: -60,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    primaryColor.withOpacity(0.15),
                    primaryColor.withOpacity(0.0),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            left: -80,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    primaryColor.withOpacity(0.08),
                    primaryColor.withOpacity(0.0),
                  ],
                ),
              ),
            ),
          ),

          // ── Layer 3: Subtle dot grid pattern ──
          Positioned.fill(
            child: Opacity(
              opacity: 0.03,
              child: CustomPaint(
                painter: _DotGridPainter(color: primaryColor),
              ),
            ),
          ),

          // ── Layer 4: Main scrollable content ──
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 600;
                
                return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: isWide ? 48 : 20,
                    vertical: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Tip Calculator',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                              Text(
                                'Calculate your tip easily',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surface,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.settings_rounded,
                                color: theme.colorScheme.onSurface.withOpacity(0.7),
                              ),
                              onPressed: widget.onNavigateToSettings,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      
                      // Bill Amount Input
                      TipInputField(
                        currency: widget.currency,
                        onChanged: _onBillChanged,
                        initialValue: _billAmount > 0 ? _billAmount : null,
                      ),
                      const SizedBox(height: 24),
                      
                      // Tip Percentage Selector
                      TipPresetSelector(
                        selectedPercentage: _tipPercentage,
                        onPercentageChanged: _onTipChanged,
                      ),
                      const SizedBox(height: 24),
                      
                      // Split Selector
                      SplitSelector(
                        count: _numberOfPeople,
                        onChanged: _onSplitChanged,
                      ),
                      const SizedBox(height: 24),
                      
                      // Rounding Selector
                      RoundingSelector(
                        selected: _rounding,
                        onChanged: _onRoundingChanged,
                      ),
                      const SizedBox(height: 32),
                      
                      // Results Card
                      ResultsCard(
                        calculation: _calculation,
                        currency: widget.currency,
                        onSave: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Saved to history!'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      
                      // Quick Actions
                      Text(
                        'Quick Actions',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(height: 12),
                      QuickActionsBar(
                        calculation: _calculation,
                        currency: widget.currency,
                        onCalculationChanged: (calc) {
                          setState(() {
                            _calculation = calc;
                            _billAmount = calc.billAmount;
                            _tipPercentage = calc.tipPercentage;
                            _numberOfPeople = calc.numberOfPeople;
                            _rounding = calc.rounding;
                          });
                        },
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: widget.onNavigateToHistory,
        child: const Icon(Icons.history_rounded),
      ),
    );
  }
}

/// ── Subtle dot grid background pattern ──
class _DotGridPainter extends CustomPainter {
  final Color color;

  _DotGridPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.fill;

    const spacing = 24.0;
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 1.5, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_DotGridPainter oldDelegate) => false;
}
