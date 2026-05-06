import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/storage_service.dart';
import '../themes/app_themes.dart';
import '../widgets/theme_selector_sheet.dart';

class SettingsPage extends StatelessWidget {
  final AppSettings settings;
  final Currency currency;
  final Function(AppSettings) onSettingsChanged;

  const SettingsPage({
    super.key,
    required this.settings,
    required this.currency,
    required this.onSettingsChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final glass = theme.glass;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0D0D0F) : glass.surface,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Settings',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
            ),
            // Content
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Appearance Section
                  _SectionHeader(label: 'APPEARANCE'),
                  const SizedBox(height: 8),
                  _SettingsGroup(
                    children: [
                      _SettingsTile(
                        icon: Icons.palette_rounded,
                        label: 'Theme',
                        value: _getThemeLabel(settings.themeId),
                        onTap: () => _showThemeSelector(context),
                        glass: glass,
                      ),
                      _SettingsTile(
                        icon: settings.isDarkMode
                            ? Icons.dark_mode_rounded
                            : Icons.light_mode_rounded,
                        label: 'Dark Mode',
                        trailing: Switch(
                          value: settings.isDarkMode,
                          onChanged: (value) {
                            onSettingsChanged(
                              settings.copyWith(isDarkMode: value),
                            );
                          },
                          activeColor: glass.accent,
                        ),
                        glass: glass,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Defaults Section
                  _SectionHeader(label: 'DEFAULTS'),
                  const SizedBox(height: 8),
                  _SettingsGroup(
                    children: [
                      _SettingsTile(
                        icon: Icons.percent_rounded,
                        label: 'Default Tip',
                        value: '${settings.defaultTipPercentage}%',
                        onTap: () => _showTipPicker(context),
                        glass: glass,
                      ),
                      _SettingsTile(
                        icon: Icons.group_rounded,
                        label: 'Default Split',
                        value: '${settings.defaultNumberOfPeople}',
                        onTap: () => _showSplitPicker(context),
                        glass: glass,
                      ),
                      _SettingsTile(
                        icon: Icons.attach_money_rounded,
                        label: 'Default Currency',
                        value: currency.code,
                        onTap: () => _showCurrencyPicker(context),
                        glass: glass,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Rounding Section
                  _SectionHeader(label: 'ROUNDING'),
                  const SizedBox(height: 8),
                  _SettingsGroup(
                    children: [
                      _SettingsTile(
                        icon: Icons.calculate_rounded,
                        label: 'Default Rounding',
                        value: settings.defaultRounding.displayName,
                        onTap: () => _showRoundingPicker(context),
                        glass: glass,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Data Section
                  _SectionHeader(label: 'DATA'),
                  const SizedBox(height: 8),
                  _SettingsGroup(
                    children: [
                      _SettingsTile(
                        icon: Icons.delete_outline_rounded,
                        label: 'Clear History',
                        onTap: () => _clearHistory(context),
                        glass: glass,
                        isDestructive: true,
                      ),
                      _SettingsTile(
                        icon: Icons.file_download_outlined,
                        label: 'Export History',
                        onTap: () => _exportHistory(context),
                        glass: glass,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // About Section
                  _SectionHeader(label: 'ABOUT'),
                  const SizedBox(height: 8),
                  _SettingsGroup(
                    children: [
                      _SettingsTile(
                        icon: Icons.info_outline_rounded,
                        label: 'Version',
                        value: '1.0.0',
                        glass: glass,
                      ),
                      _SettingsTile(
                        icon: Icons.code_rounded,
                        label: 'GitHub',
                        onTap: () {
                          // Open GitHub link
                        },
                        glass: glass,
                      ),
                    ],
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getThemeLabel(String themeId) {
    switch (themeId) {
      case 'violet':
        return 'Violet';
      case 'ocean':
        return 'Ocean';
      case 'emerald':
        return 'Emerald';
      case 'amber':
        return 'Amber';
      case 'rose':
        return 'Rose';
      case 'slate':
        return 'Slate';
      default:
        return 'Violet';
    }
  }

  void _showThemeSelector(BuildContext context) {
    ThemeSelectorSheet.show(
      context,
      selectedThemeId: settings.themeId,
      isDarkMode: settings.isDarkMode,
      onThemeChanged: (themeId) {
        onSettingsChanged(settings.copyWith(themeId: themeId));
      },
      onDarkModeChanged: (isDark) {
        onSettingsChanged(settings.copyWith(isDarkMode: isDark));
      },
    );
  }

  void _showTipPicker(BuildContext context) {
    _showOptionsSheet(
      context,
      title: 'DEFAULT TIP',
      options: [10, 15, 18, 20, 25].map((t) => '$t%').toList(),
      selectedIndex: [10, 15, 18, 20, 25].indexOf(settings.defaultTipPercentage),
      onSelected: (index) {
        final tips = [10, 15, 18, 20, 25];
        onSettingsChanged(settings.copyWith(defaultTipPercentage: tips[index]));
      },
    );
  }

  void _showSplitPicker(BuildContext context) {
    _showOptionsSheet(
      context,
      title: 'DEFAULT SPLIT',
      options: ['1', '2', '3', '4', '5', '6'],
      selectedIndex: settings.defaultNumberOfPeople - 1,
      onSelected: (index) {
        onSettingsChanged(settings.copyWith(defaultNumberOfPeople: index + 1));
      },
    );
  }

  void _showCurrencyPicker(BuildContext context) {
    final currencies = Currency.all;
    _showOptionsSheet(
      context,
      title: 'DEFAULT CURRENCY',
      options: currencies.map((c) => '${c.symbol} ${c.code}').toList(),
      selectedIndex: currencies.indexWhere((c) => c.code == currency.code),
      onSelected: (index) {
        onSettingsChanged(
          settings.copyWith(defaultCurrencyCode: currencies[index].code),
        );
      },
    );
  }

  void _showRoundingPicker(BuildContext context) {
    final options = RoundingOption.values;
    _showOptionsSheet(
      context,
      title: 'DEFAULT ROUNDING',
      options: options.map((o) => o.displayName).toList(),
      selectedIndex: options.indexOf(settings.defaultRounding),
      onSelected: (index) {
        onSettingsChanged(settings.copyWith(defaultRounding: options[index]));
      },
    );
  }

  void _showOptionsSheet(
    BuildContext context, {
    required String title,
    required List<String> options,
    required int selectedIndex,
    required Function(int) onSelected,
  }) {
    final theme = Theme.of(context);
    final glass = theme.glass;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: glass.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(color: glass.border),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: glass.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: theme.textTheme.labelSmall?.copyWith(
                  letterSpacing: 1.5,
                  color: glass.textTertiary,
                ),
              ),
              const SizedBox(height: 16),
              ...List.generate(options.length, (index) {
                final isSelected = index == selectedIndex;
                return ListTile(
                  onTap: () {
                    onSelected(index);
                    Navigator.pop(context);
                  },
                  title: Text(
                    options[index],
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected ? glass.accent : glass.textPrimary,
                    ),
                  ),
                  trailing: isSelected
                      ? Icon(Icons.check_rounded, color: glass.accent)
                      : null,
                );
              }),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _clearHistory(BuildContext context) async {
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
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Clear'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await StorageService.clearHistory();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('History cleared'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Theme.of(context).colorScheme.surface,
          ),
        );
      }
    }
  }

  void _exportHistory(BuildContext context) {
    // TODO: Implement export
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Export coming soon'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;

  const _SectionHeader({required this.label});

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

class _SettingsGroup extends StatelessWidget {
  final List<Widget> children;

  const _SettingsGroup({required this.children});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final glass = theme.glass;

    return Container(
      decoration: BoxDecoration(
        color: glass.surface.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: glass.border),
      ),
      child: Column(
        children: List.generate(children.length * 2 - 1, (index) {
          if (index.isOdd) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(height: 1, color: glass.border),
            );
          }
          return children[index ~/ 2];
        }),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? value;
  final Widget? trailing;
  final VoidCallback? onTap;
  final GlassThemeExtension glass;
  final bool isDestructive;

  const _SettingsTile({
    required this.icon,
    required this.label,
    this.value,
    this.trailing,
    this.onTap,
    required this.glass,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? Colors.red.shade400 : glass.textPrimary;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(
              icon,
              size: 22,
              color: isDestructive ? Colors.red.shade400 : glass.textSecondary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
              ),
            ),
            if (value != null)
              Text(
                value!,
                style: TextStyle(
                  fontSize: 15,
                  color: glass.textSecondary,
                ),
              ),
            if (trailing != null) trailing!,
            if (onTap != null && trailing == null && value == null)
              Icon(
                Icons.chevron_right_rounded,
                color: glass.textTertiary,
              ),
          ],
        ),
      ),
    );
  }
}
