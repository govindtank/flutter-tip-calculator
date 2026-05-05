import 'package:flutter/material.dart';

class AppThemes {
  final ThemeData light;
  final ThemeData dark;

  const AppThemes({required this.light, required this.dark});

  static const Map<String, _ThemeColors> _themeColors = {
    'violet': _ThemeColors(
      name: 'Violet',
      primary: Color(0xFF7C3AED),
      primaryLight: Color(0xFFA855F7),
      primaryDark: Color(0xFF6D28D9),
      gradientStart: Color(0xFF7C3AED),
      gradientEnd: Color(0xFFA855F7),
    ),
    'ocean': _ThemeColors(
      name: 'Ocean',
      primary: Color(0xFF0284C7),
      primaryLight: Color(0xFF38BDF8),
      primaryDark: Color(0xFF0369A1),
      gradientStart: Color(0xFF0369A1),
      gradientEnd: Color(0xFF38BDF8),
    ),
    'emerald': _ThemeColors(
      name: 'Emerald',
      primary: Color(0xFF059669),
      primaryLight: Color(0xFF34D399),
      primaryDark: Color(0xFF047857),
      gradientStart: Color(0xFF047857),
      gradientEnd: Color(0xFF34D399),
    ),
    'amber': _ThemeColors(
      name: 'Amber',
      primary: Color(0xFFD97706),
      primaryLight: Color(0xFFFCD34D),
      primaryDark: Color(0xFFB45309),
      gradientStart: Color(0xFFB45309),
      gradientEnd: Color(0xFFFCD34D),
    ),
    'rose': _ThemeColors(
      name: 'Rose',
      primary: Color(0xFFE11D48),
      primaryLight: Color(0xFFFB7185),
      primaryDark: Color(0xFFBE123C),
      gradientStart: Color(0xFFBE123C),
      gradientEnd: Color(0xFFFB7185),
    ),
    'slate': _ThemeColors(
      name: 'Slate',
      primary: Color(0xFF475569),
      primaryLight: Color(0xFF94A3B8),
      primaryDark: Color(0xFF334155),
      gradientStart: Color(0xFF334155),
      gradientEnd: Color(0xFF94A3B8),
    ),
  };

  static AppThemes getThemes(String themeId) {
    final colors = _themeColors[themeId] ?? _themeColors['violet']!;
    
    final lightTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: colors.primary,
        secondary: colors.primaryLight,
        tertiary: colors.primaryDark,
        surface: Colors.white,
        onSurface: const Color(0xFF1F2937),
      ),
      scaffoldBackgroundColor: const Color(0xFFF8FAFC),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: const Color(0xFF1F2937),
        titleTextStyle: const TextStyle(
          color: Color(0xFF1F2937),
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.primary,
          side: BorderSide(color: colors.primary),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.primary, width: 2),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFFF1F5F9),
        selectedColor: colors.primary.withOpacity(0.2),
        labelStyle: const TextStyle(fontSize: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: colors.primary,
        unselectedItemColor: Colors.grey[600],
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colors.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );

    final darkTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: colors.primary,
        secondary: colors.primaryLight,
        tertiary: colors.primaryDark,
        surface: const Color(0xFF1E293B),
        onSurface: Colors.white,
      ),
      scaffoldBackgroundColor: const Color(0xFF0F172A),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.primaryLight,
          side: BorderSide(color: colors.primaryLight),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF334155),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF475569)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF475569)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.primaryLight, width: 2),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFF334155),
        selectedColor: colors.primary.withOpacity(0.3),
        labelStyle: const TextStyle(fontSize: 14, color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: const Color(0xFF1E293B),
        selectedItemColor: colors.primaryLight,
        unselectedItemColor: Colors.grey[400],
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colors.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );

    return AppThemes(light: lightTheme, dark: darkTheme);
  }

  static List<String> get availableThemes => _themeColors.keys.toList();

  static String getThemeName(String themeId) {
    return _themeColors[themeId]?.name ?? 'Violet';
  }
}

class _ThemeColors {
  final String name;
  final Color primary;
  final Color primaryLight;
  final Color primaryDark;
  final Color gradientStart;
  final Color gradientEnd;

  const _ThemeColors({
    required this.name,
    required this.primary,
    required this.primaryLight,
    required this.primaryDark,
    required this.gradientStart,
    required this.gradientEnd,
  });
}
