import 'package:flutter/material.dart';
import '../models/models.dart';
import '../utils/formatters.dart';
import '../widgets/widgets.dart';

class HomePage extends StatefulWidget {
  final Currency currency;
  final VoidCallback onNavigateToHistory;

  const HomePage({
    super.key,
    required this.currency,
    required this.onNavigateToHistory,
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
    if (_billAmount > 0) {
      _calculation = TipCalculation.calculate(
        billAmount: _billAmount,
        tipPercentage: _tipPercentage,
        numberOfPeople: _numberOfPeople,
        rounding: _rounding,
      );
    } else {
      _calculation = null;
    }
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              primaryColor.withOpacity(0.05),
              theme.scaffoldBackgroundColor,
              theme.scaffoldBackgroundColor,
            ],
          ),
        ),
        child: SafeArea(
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
                            onPressed: () {
                              // Navigate to settings via parent
                            },
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
                        if (_calculation != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Saved to history!'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: widget.onNavigateToHistory,
        child: const Icon(Icons.history_rounded),
      ),
    );
  }
}
