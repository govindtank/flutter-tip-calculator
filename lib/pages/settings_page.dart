import 'package:flutter/material.dart';
import '../models/models.dart';
import '../themes/app_themes.dart';
import '../widgets/widgets.dart';

class SettingsPage extends StatelessWidget {
  final AppSettings settings;
  final Currency defaultCurrency;
  final Function(AppSettings) onSettingsChanged;
  final VoidCallback onClearHistory;
  final VoidCallback onExportHistory;

  const SettingsPage({
    super.key,
    required this.settings,
    required this.defaultCurrency,
    required this.onSettingsChanged,
    required this.onClearHistory,
    required this.onExportHistory,
  });

  void _showThemeSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => ThemeSelectorSheet(
        currentThemeId: settings.themeId,
        isDarkMode: settings.isDarkMode,
        onThemeChanged: (themeId) {
          onSettingsChanged(settings.copyWith(themeId: themeId));
          Navigator.pop(context);
        },
        onDarkModeChanged: (isDark) {
          onSettingsChanged(settings.copyWith(isDarkMode: isDark));
        },
      ),
    );
  }

  void _showCurrencyPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Select Currency',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: Currency.all.length,
              itemBuilder: (context, index) {
                final currency = Currency.all[index];
                final isSelected = currency.code == settings.defaultCurrencyCode;
                return ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                          : Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      currency.symbol,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                  title: Text(
                    currency.name,
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  subtitle: Text(
                    currency.code,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                  trailing: isSelected
                      ? Icon(
                          Icons.check_circle_rounded,
                          color: Theme.of(context).colorScheme.primary,
                        )
                      : null,
                  onTap: () {
                    onSettingsChanged(settings.copyWith(
                      defaultCurrencyCode: currency.code,
                    ));
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Appearance Section
            _SectionHeader(title: 'Appearance'),
            _SettingsTile(
              icon: Icons.palette_rounded,
              title: 'Theme',
              subtitle: AppThemes.getThemeName(settings.themeId),
              onTap: () => _showThemeSelector(context),
            ),
            _SettingsTile(
              icon: settings.isDarkMode ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
              title: 'Dark Mode',
              trailing: Switch(
                value: settings.isDarkMode,
                onChanged: (value) {
                  onSettingsChanged(settings.copyWith(isDarkMode: value));
                },
                activeColor: theme.colorScheme.primary,
              ),
            ),
            
            // Defaults Section
            _SectionHeader(title: 'Defaults'),
            _SettingsTile(
              icon: Icons.percent_rounded,
              title: 'Default Tip %',
              subtitle: '${settings.defaultTipPercentage}%',
              onTap: () => _showTipPicker(context),
            ),
            _SettingsTile(
              icon: Icons.group_rounded,
              title: 'Default Split Count',
              subtitle: '${settings.defaultNumberOfPeople} ${settings.defaultNumberOfPeople == 1 ? 'person' : 'people'}',
              onTap: () => _showSplitPicker(context),
            ),
            _SettingsTile(
              icon: Icons.attach_money_rounded,
              title: 'Default Currency',
              subtitle: '${defaultCurrency.symbol} ${defaultCurrency.name}',
              onTap: () => _showCurrencyPicker(context),
            ),
            
            // Rounding Section
            _SectionHeader(title: 'Rounding'),
            _SettingsTile(
              icon: Icons.auto_awesome_rounded,
              title: 'Default Rounding',
              subtitle: settings.defaultRounding.displayName,
              onTap: () => _showRoundingPicker(context),
            ),
            
            // Data Section
            _SectionHeader(title: 'Data'),
            _SettingsTile(
              icon: Icons.download_rounded,
              title: 'Export History',
              subtitle: 'Share your calculation history',
              onTap: onExportHistory,
            ),
            _SettingsTile(
              icon: Icons.delete_forever_rounded,
              title: 'Clear All History',
              subtitle: 'Delete all saved calculations',
              iconColor: Colors.red,
              onTap: () => _showClearConfirmation(context),
            ),
            
            // About Section
            _SectionHeader(title: 'About'),
            _SettingsTile(
              icon: Icons.info_outline_rounded,
              title: 'Version',
              subtitle: '1.0.0',
            ),
            _SettingsTile(
              icon: Icons.code_rounded,
              title: 'Open Source',
              subtitle: 'View source code on GitHub',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Opening GitHub repository...'),
                  ),
                );
              },
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  void _showTipPicker(BuildContext context) {
    int selected = settings.defaultTipPercentage;
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Default Tip Percentage',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                '$selected%',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 24),
              Slider(
                value: selected.toDouble(),
                min: 5,
                max: 50,
                divisions: 45,
                onChanged: (value) {
                  setState(() {
                    selected = value.round();
                  });
                },
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    onSettingsChanged(settings.copyWith(defaultTipPercentage: selected));
                    Navigator.pop(context);
                  },
                  child: const Text('Save'),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _showSplitPicker(BuildContext context) {
    int selected = settings.defaultNumberOfPeople;
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Default Split Count',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: selected > 1
                        ? () => setState(() => selected--)
                        : null,
                    icon: const Icon(Icons.remove_circle_outline),
                    iconSize: 40,
                  ),
                  const SizedBox(width: 32),
                  Text(
                    '$selected',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 32),
                  IconButton(
                    onPressed: selected < 50
                        ? () => setState(() => selected++)
                        : null,
                    icon: const Icon(Icons.add_circle_outline),
                    iconSize: 40,
                  ),
                ],
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    onSettingsChanged(settings.copyWith(defaultNumberOfPeople: selected));
                    Navigator.pop(context);
                  },
                  child: const Text('Save'),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _showRoundingPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Default Rounding',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          ...RoundingOption.values.map((option) {
            final isSelected = option == settings.defaultRounding;
            return ListTile(
              title: Text(
                option.displayName,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              subtitle: Text(
                option.tooltip,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              trailing: isSelected
                  ? Icon(
                      Icons.check_circle_rounded,
                      color: Theme.of(context).colorScheme.primary,
                    )
                  : null,
              onTap: () {
                onSettingsChanged(settings.copyWith(defaultRounding: option));
                Navigator.pop(context);
              },
            );
          }),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  void _showClearConfirmation(BuildContext context) {
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
              onClearHistory();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? iconColor;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: (iconColor ?? theme.colorScheme.primary).withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: iconColor ?? theme.colorScheme.primary,
          size: 22,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: theme.colorScheme.onSurface,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: TextStyle(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
                fontSize: 13,
              ),
            )
          : null,
      trailing: trailing ??
          (onTap != null
              ? Icon(
                  Icons.chevron_right_rounded,
                  color: theme.colorScheme.onSurface.withOpacity(0.3),
                )
              : null),
      onTap: onTap,
    );
  }
}
