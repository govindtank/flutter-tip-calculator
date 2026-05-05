import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/storage_service.dart';
import 'home_page.dart';
import 'history_page.dart';
import 'settings_page.dart';

class MainShell extends StatefulWidget {
  final AppSettings settings;
  final Currency currency;
  final Function(AppSettings) onSettingsChanged;
  final VoidCallback onThemeChanged;

  const MainShell({
    super.key,
    required this.settings,
    required this.currency,
    required this.onSettingsChanged,
    required this.onThemeChanged,
  });

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;
  late List<TipCalculation> _history;

  @override
  void initState() {
    super.initState();
    _history = StorageService.loadHistory();
  }

  void _onHistoryChanged(List<TipCalculation> newHistory) {
    setState(() {
      _history = newHistory;
    });
    StorageService.saveHistory(_history);
  }

  void _deleteHistoryItem(String id) {
    final newHistory = List<TipCalculation>.from(_history);
    newHistory.removeWhere((calc) => calc.id == id);
    _onHistoryChanged(newHistory);
  }

  void _clearAllHistory() {
    StorageService.clearHistory();
    setState(() {
      _history = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: IndexedStack(
          index: _currentIndex,
          children: [
            HomePage(
              key: const ValueKey('home'),
              currency: widget.currency,
              onNavigateToHistory: () => setState(() => _currentIndex = 1),
              onNavigateToSettings: () => setState(() => _currentIndex = 2),
            ),
            HistoryPage(
              key: const ValueKey('history'),
              currency: widget.currency,
              history: _history,
              onDelete: _deleteHistoryItem,
              onClearAll: _clearAllHistory,
            ),
            SettingsPage(
              key: const ValueKey('settings'),
              settings: widget.settings,
              defaultCurrency: widget.currency,
              onSettingsChanged: widget.onSettingsChanged,
              onClearHistory: _clearAllHistory,
              onExportHistory: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Export feature available')),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(
                  icon: Icons.calculate_rounded,
                  label: 'Calculator',
                  isSelected: _currentIndex == 0,
                  onTap: () => setState(() => _currentIndex = 0),
                ),
                _NavItem(
                  icon: Icons.history_rounded,
                  label: 'History',
                  isSelected: _currentIndex == 1,
                  onTap: () => setState(() => _currentIndex = 1),
                  badge: _history.isNotEmpty ? _history.length : null,
                ),
                _NavItem(
                  icon: Icons.settings_rounded,
                  label: 'Settings',
                  isSelected: _currentIndex == 2,
                  onTap: () => setState(() => _currentIndex = 2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final int? badge;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  icon,
                  color: isSelected ? primaryColor : theme.colorScheme.onSurface.withOpacity(0.5),
                  size: 24,
                ),
                if (badge != null)
                  Positioned(
                    right: -8,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(minWidth: 18),
                      child: Text(
                        badge! > 99 ? '99+' : '$badge',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: primaryColor,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
