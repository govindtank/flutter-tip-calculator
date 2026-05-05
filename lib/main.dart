import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';

void main() {
  runApp(const TipCalculatorApp());
}

class Calculation {
  final String id;
  final double billAmount;
  final int numberOfPeople;
  final String percentage;
  final DateTime timestamp;

  Calculation({
    required this.id,
    required this.billAmount,
    required this.numberOfPeople,
    required this.percentage,
    required this.timestamp,
  });

  double get tipAmount => billAmount * (double.parse(percentage) / 100);
  double get perPersonTotal => (billAmount + tipAmount) / numberOfPeople;
}

class TipCalculatorApp extends StatefulWidget {
  const TipCalculatorApp({super.key});

  @override
  State<TipCalculatorApp> createState() => _TipCalculatorAppState();
}

class _TipCalculatorAppState extends State<TipCalculatorApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tip Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6750A4),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _billController = TextEditingController();
  String _selectedPercentage = '20';
  
  final List<Calculation> _history = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _billController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Calculation calculate(double billAmount, int peopleCount, String percentage) {
    return Calculation(
      id: const Uuid().v4(),
      billAmount: billAmount,
      numberOfPeople: peopleCount,
      percentage: percentage,
      timestamp: DateTime.now(),
    );
  }

  Future<void> _calculateTip(String percent) async {
    final billText = _billController.text.trim();
    if (billText.isEmpty) return;

    final billAmount = double.tryParse(billText);
    if (billAmount == null || billAmount <= 0) return;

    setState(() {
      _selectedPercentage = percent;
      
      final calc = calculate(billAmount, 2, percent);
      final total = billAmount + calc.tipAmount;
      
      setState(() {
        if (_history.length < 50) {
          _history.insert(0, calc);
        }
      });
    });
  }

  Future<void> _copyToClipboard(String text) async {
    try {
      await Clipboard.setData(ClipboardData(text: text));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Copied to clipboard!')),
      );
    } catch (e) {
      debugPrint('Error copying: $e');
    }
  }

  Future<void> _exportHistory() async {
    if (_history.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No history to export')),
      );
      return;
    }

    final jsonExport = convert.JsonEncoder().convert(_history.map((e) => {
      'id': e.id,
      'billAmount': e.billAmount,
      'numberOfPeople': e.numberOfPeople,
      'percentage': e.percentage,
      'timestamp': e.timestamp.toIso8601String(),
    }).toList());

    await Share.share(
      jsonExport,
      subject: 'Tip Calculator History',
    );
  }

  Future<void> _clearHistory() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear History'),
        content: const Text('Are you sure you want to clear all calculation history?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Clear'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() {
        _history.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('History cleared')),
      );
    }
  }

  void _showHistoryDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Calculation History'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_history.isEmpty)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'No calculations yet. Start by entering a bill amount!',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(8),
                itemCount: _history.length,
                itemBuilder: (context, index) {
                  final calc = _history[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      leading: Icon(Icons.calculate, color: Colors.purple[700]),
                      title: Text('Bill: \$${calc.billAmount.toStringAsFixed(2)}'),
                      subtitle: Text(
                        '${calc.percentage}% tip for ${calc.numberOfPeople} people\n'
                        'Per person: \$${calc.perPersonTotal.toStringAsFixed(2)}',
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            DateFormat('MMM dd, yyyy h:mm a').format(calc.timestamp),
                            style: const TextStyle(fontSize: 10, color: Colors.grey),
                          ),
                          SizedBox(height: 4),
                          IconButton(
                            icon: const Icon(Icons.share, size: 18),
                            onPressed: () async {
                              final calc = _history[index];
                              await Share.share(
                                'Per Person: \$${calc.perPersonTotal.toStringAsFixed(2)}',
                                subject: 'Tip Calculator Result',
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            if (_history.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  '${_history.length} calculation${_history.length != 1 ? 's' : ''}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _exportHistory,
                    icon: const Icon(Icons.download),
                    label: const Text('Export JSON'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _clearHistory,
                    icon: const Icon(Icons.delete),
                    label: const Text('Clear'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tip Calculator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: _showHistoryDialog,
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _exportHistory,
          ),
        ],
      ),
      body: _tabController.index == 0
        ? _buildCalculatorView()
        : _buildHistoryPlaceholder(),
    );
  }

  Widget _buildCalculatorView() {
    return const Center(child: Text('Calculator view'));
  }

  Widget _buildHistoryPlaceholder() {
    return const Center(child: Text('History view'));
  }
}
