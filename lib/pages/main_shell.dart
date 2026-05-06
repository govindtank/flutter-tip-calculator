import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/storage_service.dart';
import '../themes/app_themes.dart';
import 'home_page.dart';
import 'history_page.dart';
import 'settings_page.dart';
import '../widgets/theme_selector_sheet.dart';

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

  void _onNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });
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
          // Page Content
          IndexedStack(
            index: _currentIndex,
            children: [
              HomePage(
                settings: widget.settings,
                currency: widget.currency,
                onSettingsTap: () => _onNavTap(2),
              ),
              HistoryPage(
                currency: widget.currency,
                onHistoryChanged: widget.onThemeChanged,
              ),
              SettingsPage(
                settings: widget.settings,
                currency: widget.currency,
                onSettingsChanged: widget.onSettingsChanged,
              ),
            ],
          ),
          // Bottom Nav Bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 16,
            child: Center(
              child: _GlassNavBar(
                currentIndex: _currentIndex,
                onTap: _onNavTap,
                historyCount: StorageService.loadHistory().length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlassNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final int historyCount;

  const _GlassNavBar({
    required this.currentIndex,
    required this.onTap,
    required this.historyCount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final glass = theme.glass;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: glass.surface.withOpacity(0.95),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: glass.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _NavButton(
            icon: Icons.calculate_rounded,
            label: 'Calculator',
            isSelected: currentIndex == 0,
            onTap: () => onTap(0),
            glass: glass,
          ),
          const SizedBox(width: 4),
          _NavButton(
            icon: Icons.history_rounded,
            label: 'History',
            isSelected: currentIndex == 1,
            badge: historyCount > 0 ? historyCount : null,
            onTap: () => onTap(1),
            glass: glass,
          ),
          const SizedBox(width: 4),
          _NavButton(
            icon: Icons.settings_rounded,
            label: 'Settings',
            isSelected: currentIndex == 2,
            onTap: () => onTap(2),
            glass: glass,
          ),
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final int? badge;
  final VoidCallback onTap;
  final GlassThemeExtension glass;

  const _NavButton({
    required this.icon,
    required this.label,
    required this.isSelected,
    this.badge,
    required this.onTap,
    required this.glass,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? glass.accent.withOpacity(0.15)
              : Colors.transparent,
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
                  size: 22,
                  color: isSelected ? glass.accent : glass.textSecondary,
                ),
                if (badge != null)
                  Positioned(
                    top: -6,
                    right: -8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: glass.accent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        badge! > 99 ? '99+' : '$badge',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? glass.accent : glass.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
