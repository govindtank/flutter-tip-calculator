import 'package:flutter/material.dart';

class ThemeSelectorSheet extends StatelessWidget {
  final String currentThemeId;
  final bool isDarkMode;
  final Function(String) onThemeChanged;
  final Function(bool) onDarkModeChanged;

  const ThemeSelectorSheet({
    super.key,
    required this.currentThemeId,
    required this.isDarkMode,
    required this.onThemeChanged,
    required this.onDarkModeChanged,
  });

  List<Color> _getThemeColors(String themeId) {
    switch (themeId) {
      case 'violet':
        return [const Color(0xFF7C3AED), const Color(0xFFA855F7)];
      case 'ocean':
        return [const Color(0xFF0284C7), const Color(0xFF38BDF8)];
      case 'emerald':
        return [const Color(0xFF059669), const Color(0xFF34D399)];
      case 'amber':
        return [const Color(0xFFD97706), const Color(0xFFFCD34D)];
      case 'rose':
        return [const Color(0xFFE11D48), const Color(0xFFFB7185)];
      case 'slate':
        return [const Color(0xFF475569), const Color(0xFF94A3B8)];
      default:
        return [const Color(0xFF7C3AED), const Color(0xFFA855F7)];
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themes = _getAvailableThemes();

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurface.withOpacity(0.2),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Choose Theme',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: themes.map((themeId) {
              final colors = _getThemeColors(themeId);
              final isSelected = currentThemeId == themeId;

              return GestureDetector(
                onTap: () => onThemeChanged(themeId),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: colors,
                    ),
                    border: Border.all(
                      color: isSelected ? Colors.white : Colors.transparent,
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: colors[0].withOpacity(isSelected ? 0.5 : 0.2),
                        blurRadius: isSelected ? 12 : 6,
                        spreadRadius: isSelected ? 2 : 0,
                      ),
                    ],
                  ),
                  child: isSelected
                      ? const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 24,
                        )
                      : null,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          Text(
            _getThemeName(currentThemeId),
            style: TextStyle(
              fontSize: 14,
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: theme.colorScheme.onSurface.withOpacity(0.1),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      isDarkMode ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      isDarkMode ? 'Dark Mode' : 'Light Mode',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
                Switch(
                  value: isDarkMode,
                  onChanged: onDarkModeChanged,
                  activeColor: theme.colorScheme.primary,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  List<String> _getAvailableThemes() {
    return ['violet', 'ocean', 'emerald', 'amber', 'rose', 'slate'];
  }

  String _getThemeName(String themeId) {
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
}
