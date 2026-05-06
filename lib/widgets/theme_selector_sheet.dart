import 'package:flutter/material.dart';
import '../themes/app_themes.dart';

class ThemeSelectorSheet extends StatelessWidget {
  final String selectedThemeId;
  final bool isDarkMode;
  final ValueChanged<String> onThemeChanged;
  final ValueChanged<bool> onDarkModeChanged;

  const ThemeSelectorSheet({
    super.key,
    required this.selectedThemeId,
    required this.isDarkMode,
    required this.onThemeChanged,
    required this.onDarkModeChanged,
  });

  static Future<void> show(
    BuildContext context, {
    required String selectedThemeId,
    required bool isDarkMode,
    required ValueChanged<String> onThemeChanged,
    required ValueChanged<bool> onDarkModeChanged,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => ThemeSelectorSheet(
        selectedThemeId: selectedThemeId,
        isDarkMode: isDarkMode,
        onThemeChanged: onThemeChanged,
        onDarkModeChanged: onDarkModeChanged,
      ),
    );
  }

  static const List<_ThemeOption> themes = [
    _ThemeOption(id: 'violet', label: 'Violet', color: Color(0xFF7C3AED)),
    _ThemeOption(id: 'ocean', label: 'Ocean', color: Color(0xFF0284C7)),
    _ThemeOption(id: 'emerald', label: 'Emerald', color: Color(0xFF059669)),
    _ThemeOption(id: 'amber', label: 'Amber', color: Color(0xFFD97706)),
    _ThemeOption(id: 'rose', label: 'Rose', color: Color(0xFFE11D48)),
    _ThemeOption(id: 'slate', label: 'Slate', color: Color(0xFF475569)),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final glass = theme.glass;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: glass.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border.all(color: glass.border),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: glass.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              // Title
              Text(
                'APPEARANCE',
                style: theme.textTheme.labelSmall?.copyWith(
                  letterSpacing: 1.5,
                  color: glass.textTertiary,
                ),
              ),
              const SizedBox(height: 24),
              // Theme Colors
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: themes.map((themeOption) {
                  final isSelected = selectedThemeId == themeOption.id;
                  return GestureDetector(
                    onTap: () => onThemeChanged(themeOption.id),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: themeOption.color,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected
                                  ? glass.textPrimary
                                  : Colors.transparent,
                              width: 3,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: themeOption.color.withOpacity(0.5),
                                      blurRadius: 12,
                                      spreadRadius: 2,
                                    ),
                                  ]
                                : null,
                          ),
                          child: isSelected
                              ? const Icon(
                                  Icons.check_rounded,
                                  color: Colors.white,
                                  size: 24,
                                )
                              : null,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          themeOption.label,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w400,
                            color: isSelected
                                ? glass.textPrimary
                                : glass.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),
              // Divider
              Container(
                height: 1,
                color: glass.border,
              ),
              const SizedBox(height: 24),
              // Dark Mode Toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        isDarkMode
                            ? Icons.dark_mode_rounded
                            : Icons.light_mode_rounded,
                        color: glass.textPrimary,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        isDarkMode ? 'Dark Mode' : 'Light Mode',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: glass.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  Switch(
                    value: isDarkMode,
                    onChanged: onDarkModeChanged,
                    activeColor: glass.accent,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ThemeOption {
  final String id;
  final String label;
  final Color color;

  const _ThemeOption({
    required this.id,
    required this.label,
    required this.color,
  });
}
