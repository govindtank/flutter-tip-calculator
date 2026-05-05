import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:convert' as convert;
import '../models/models.dart';
import '../utils/formatters.dart';
import '../utils/share_utils.dart';

class HistoryPage extends StatefulWidget {
  final Currency currency;
  final List<TipCalculation> history;
  final Function(String) onDelete;
  final VoidCallback onClearAll;

  const HistoryPage({
    super.key,
    required this.currency,
    required this.history,
    required this.onDelete,
    required this.onClearAll,
  });

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  String _searchQuery = '';
  String _filterPeriod = 'all';

  List<TipCalculation> get _filteredHistory {
    var history = widget.history;

    // Apply date filter
    final now = DateTime.now();
    switch (_filterPeriod) {
      case 'week':
        history = history.where((calc) {
          return calc.timestamp.isAfter(now.subtract(const Duration(days: 7)));
        }).toList();
        break;
      case 'month':
        history = history.where((calc) {
          return calc.timestamp.isAfter(now.subtract(const Duration(days: 30)));
        }).toList();
        break;
    }

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      history = history.where((calc) {
        return calc.billAmount.toString().contains(query) ||
            calc.tipPercentage.toString().contains(query) ||
            calc.perPersonTotal.toString().contains(query);
      }).toList();
    }

    return history;
  }

  Map<String, dynamic> get _stats {
    if (widget.history.isEmpty) {
      return {
        'total': 0,
        'avgTip': 0.0,
        'mostCommonSplit': 1,
      };
    }

    final total = widget.history.length;
    final avgTip = widget.history.fold<double>(
      0,
      (sum, calc) => sum + calc.tipPercentage,
    ) / total;

    // Count splits
    final splitCounts = <int, int>{};
    for (final calc in widget.history) {
      splitCounts[calc.numberOfPeople] = (splitCounts[calc.numberOfPeople] ?? 0) + 1;
    }
    final mostCommonSplit = splitCounts.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;

    return {
      'total': total,
      'avgTip': avgTip,
      'mostCommonSplit': mostCommonSplit,
    };
  }

  void _showClearConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All History'),
        content: const Text('Are you sure you want to clear all calculation history? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onClearAll();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  void _exportHistory() {
    if (widget.history.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No history to export')),
      );
      return;
    }

    final jsonExport = convert.jsonEncode(widget.history.map((e) => e.toJson()).toList());
    Share.share(jsonExport, subject: 'Tip Calculator History');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final stats = _stats;
    final filteredHistory = _filteredHistory;

    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download_rounded),
            onPressed: _exportHistory,
            tooltip: 'Export History',
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded),
            onPressed: widget.history.isEmpty ? null : _showClearConfirmation,
            tooltip: 'Clear All',
          ),
        ],
      ),
      body: Column(
        children: [
          // Stats Card
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  primaryColor,
                  primaryColor.withOpacity(0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatItem(
                  icon: Icons.calculate_rounded,
                  value: '${stats['total']}',
                  label: 'Calculations',
                ),
                _StatItem(
                  icon: Icons.percent_rounded,
                  value: '${(stats['avgTip'] as double).toStringAsFixed(1)}%',
                  label: 'Avg Tip',
                ),
                _StatItem(
                  icon: Icons.group_rounded,
                  value: '${stats['mostCommonSplit']}',
                  label: 'Common Split',
                ),
              ],
            ),
          ),
          
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: 'Search by amount or tip %',
                prefixIcon: const Icon(Icons.search_rounded),
                filled: true,
                fillColor: theme.colorScheme.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _FilterChip(
                  label: 'This Week',
                  isSelected: _filterPeriod == 'week',
                  onTap: () => setState(() => _filterPeriod = 'week'),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'This Month',
                  isSelected: _filterPeriod == 'month',
                  onTap: () => setState(() => _filterPeriod = 'month'),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'All Time',
                  isSelected: _filterPeriod == 'all',
                  onTap: () => setState(() => _filterPeriod = 'all'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          // History List
          Expanded(
            child: filteredHistory.isEmpty
                ? _EmptyState()
                : RefreshIndicator(
                    onRefresh: () async {
                      // Simulate refresh - data is local
                      await Future.delayed(const Duration(milliseconds: 500));
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: filteredHistory.length,
                      itemBuilder: (context, index) {
                        final calc = filteredHistory[index];
                        return Dismissible(
                          key: Key(calc.id),
                          direction: DismissDirection.endToStart,
                          onDismissed: (_) => widget.onDelete(calc.id),
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              Icons.delete_rounded,
                              color: Colors.white,
                            ),
                          ),
                          child: _HistoryCard(
                            calculation: calc,
                            currency: widget.currency,
                            onShare: () {
                              ShareUtils.shareCalculation(calc, widget.currency);
                            },
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? primaryColor
                : theme.colorScheme.onSurface.withOpacity(0.1),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: isSelected ? Colors.white : theme.colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final TipCalculation calculation;
  final Currency currency;
  final VoidCallback onShare;

  const _HistoryCard({
    required this.calculation,
    required this.currency,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Formatters.formatCurrency(calculation.billAmount, currency),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${Formatters.formatPercentage(calculation.tipPercentage)} tip • ${calculation.numberOfPeople} ${calculation.numberOfPeople == 1 ? 'person' : 'people'}',
                  style: TextStyle(
                    fontSize: 14,
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  Formatters.formatDateTime(calculation.timestamp),
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.onSurface.withOpacity(0.4),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                Formatters.formatCurrency(calculation.perPersonTotal, currency),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'per person',
                style: TextStyle(
                  fontSize: 12,
                  color: theme.colorScheme.onSurface.withOpacity(0.5),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.share_rounded,
                  size: 20,
                  color: theme.colorScheme.onSurface.withOpacity(0.5),
                ),
                onPressed: onShare,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history_rounded,
            size: 80,
            color: theme.colorScheme.onSurface.withOpacity(0.2),
          ),
          const SizedBox(height: 16),
          Text(
            'No calculations yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your tip calculations will appear here',
            style: TextStyle(
              fontSize: 14,
              color: theme.colorScheme.onSurface.withOpacity(0.3),
            ),
          ),
        ],
      ),
    );
  }
}
