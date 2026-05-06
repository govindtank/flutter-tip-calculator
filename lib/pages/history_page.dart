import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/storage_service.dart';
import '../utils/formatters.dart';
import '../themes/app_themes.dart';

class HistoryPage extends StatefulWidget {
  final Currency currency;
  final VoidCallback onHistoryChanged;

  const HistoryPage({
    super.key,
    required this.currency,
    required this.onHistoryChanged,
  });

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<TipCalculation> _history = [];
  String _searchQuery = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  void _loadHistory() {
    setState(() {
      _history = StorageService.loadHistory();
      _isLoading = false;
    });
  }

  void _deleteItem(String id) async {
    await StorageService.removeFromHistory(id);
    widget.onHistoryChanged();
    _loadHistory();
  }

  void _clearAll() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Clear History'),
        content: const Text('Are you sure you want to clear all history?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await StorageService.clearHistory();
      widget.onHistoryChanged();
      _loadHistory();
    }
  }

  List<TipCalculation> get _filteredHistory {
    if (_searchQuery.isEmpty) return _history;
    return _history.where((calc) {
      return calc.billAmount.toString().contains(_searchQuery) ||
          calc.tipPercentage.toString().contains(_searchQuery) ||
          calc.numberOfPeople.toString().contains(_searchQuery);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final glass = theme.glass;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0D0D0F) : glass.surface,
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'History',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                  if (_history.isNotEmpty)
                    TextButton(
                      onPressed: _clearAll,
                      child: Text(
                        'Clear All',
                        style: TextStyle(
                          color: Colors.red.shade400,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Search Bar
            if (_history.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0x0DFFFFFF),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: glass.border),
                  ),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    style: TextStyle(
                      fontSize: 15,
                      color: glass.textPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search history...',
                      hintStyle: TextStyle(color: glass.textTertiary),
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        color: glass.textTertiary,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                  ),
                ),
              ),
            // Content
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _history.isEmpty
                      ? _EmptyState()
                      : _buildHistoryList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryList() {
    final theme = Theme.of(context);
    final glass = theme.glass;
    final filtered = _filteredHistory;

    if (filtered.isEmpty) {
      return Center(
        child: Text(
          'No results found',
          style: TextStyle(color: glass.textSecondary),
        ),
      );
    }

    // Calculate stats
    final totalCalcs = _history.length;
    final avgTip = _history.isEmpty
        ? 0.0
        : _history.fold<double>(0, (sum, calc) => sum + calc.tipPercentage) /
            _history.length;
    final avgSplit = _history.isEmpty
        ? 0.0
        : _history.fold<double>(0, (sum, calc) => sum + calc.numberOfPeople) /
            _history.length;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Stats Card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: glass.surface.withOpacity(0.8),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: glass.border),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatItem(
                label: 'Total',
                value: '$totalCalcs',
                glass: glass,
              ),
              Container(
                width: 1,
                height: 40,
                color: glass.border,
              ),
              _StatItem(
                label: 'Avg Tip',
                value: '${avgTip.toStringAsFixed(1)}%',
                glass: glass,
              ),
              Container(
                width: 1,
                height: 40,
                color: glass.border,
              ),
              _StatItem(
                label: 'Avg Split',
                value: avgSplit.toStringAsFixed(1),
                glass: glass,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // History Items
        ...filtered.map((calc) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _HistoryItem(
                calculation: calc,
                currency: widget.currency,
                onDelete: () => _deleteItem(calc.id),
              ),
            )),
        const SizedBox(height: 80),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final glass = theme.glass;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history_rounded,
            size: 64,
            color: glass.textTertiary,
          ),
          const SizedBox(height: 16),
          Text(
            'No calculations yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: glass.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your saved calculations will appear here',
            style: TextStyle(
              fontSize: 14,
              color: glass.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final GlassThemeExtension glass;

  const _StatItem({
    required this.label,
    required this.value,
    required this.glass,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: glass.accent,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: glass.textTertiary,
          ),
        ),
      ],
    );
  }
}

class _HistoryItem extends StatelessWidget {
  final TipCalculation calculation;
  final Currency currency;
  final VoidCallback onDelete;

  const _HistoryItem({
    required this.calculation,
    required this.currency,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final glass = theme.glass;
    final isDark = theme.brightness == Brightness.dark;

    return Dismissible(
      key: Key(calculation.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red.shade600,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(
          Icons.delete_rounded,
          color: Colors.white,
        ),
      ),
      onDismissed: (_) => onDelete(),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: glass.surface.withOpacity(0.8),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: glass.border),
        ),
        child: Row(
          children: [
            // Amount
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Formatters.formatCurrencyCompact(
                      calculation.perPersonTotal,
                      currency,
                    ),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: glass.accent,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'per person',
                    style: TextStyle(
                      fontSize: 12,
                      color: glass.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
            // Details
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  Formatters.formatDate(calculation.timestamp),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: glass.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${Formatters.formatCurrencyCompact(calculation.billAmount, currency)} · ${calculation.tipPercentage.toInt()}% · ${calculation.numberOfPeople}p',
                  style: TextStyle(
                    fontSize: 12,
                    color: glass.textTertiary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
