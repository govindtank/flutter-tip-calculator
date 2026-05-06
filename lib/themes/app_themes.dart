import 'package:flutter/material.dart';

class AppThemeConfig {
  final Color accent;
  final Color accentLight;
  final Color accentGlow;
  final ThemeData dark;
  final ThemeData light;

  const AppThemeConfig({
    required this.accent,
    required this.accentLight,
    required this.accentGlow,
    required this.dark,
    required this.light,
  });
}

class AppThemes {
  static const Color _darkBg = Color(0xFF0D0D0F);
  static const Color _darkSurface = Color(0xFF18181B);
  static const Color _darkElevated = Color(0xFF27272A);
  static const Color _darkBorder = Color(0xFF3F3F46);
  static const Color _darkText = Color(0xFFFAFAFA);
  static const Color _darkTextSecondary = Color(0xFFA1A1AA);
  static const Color _darkTextTertiary = Color(0xFF71717A);

  static const Color _lightSurface = Color(0xFFF4F4F5);
  static const Color _lightElevated = Color(0xFFE4E4E7);
  static const Color _lightBorder = Color(0xFFD4D4D8);
  static const Color _lightText = Color(0xFF18181B);
  static const Color _lightTextSecondary = Color(0xFF52525B);
  static const Color _lightTextTertiary = Color(0xFF71717A);

  static const List<String> themeIds = [
    'violet',
    'ocean',
    'emerald',
    'amber',
    'rose',
    'slate',
  ];

  static AppThemeConfig getThemes(String id) {
    switch (id) {
      case 'violet':
        return _violetTheme;
      case 'ocean':
        return _oceanTheme;
      case 'emerald':
        return _emeraldTheme;
      case 'amber':
        return _amberTheme;
      case 'rose':
        return _roseTheme;
      case 'slate':
        return _slateTheme;
      default:
        return _violetTheme;
    }
  }

  static const _violetAccent = Color(0xFF7C3AED);
  static const _violetAccentLight = Color(0xFFA78BFA);

  static final AppThemeConfig _violetTheme = AppThemeConfig(
    accent: _violetAccent,
    accentLight: _violetAccentLight,
    accentGlow: _violetAccent.withOpacity(0.15),
    dark: _buildDarkTheme(_violetAccent, _violetAccentLight),
    light: _buildLightTheme(_violetAccent, _violetAccentLight),
  );

  static const _oceanAccent = Color(0xFF0284C7);
  static const _oceanAccentLight = Color(0xFF38BDF8);

  static final AppThemeConfig _oceanTheme = AppThemeConfig(
    accent: _oceanAccent,
    accentLight: _oceanAccentLight,
    accentGlow: _oceanAccent.withOpacity(0.15),
    dark: _buildDarkTheme(_oceanAccent, _oceanAccentLight),
    light: _buildLightTheme(_oceanAccent, _oceanAccentLight),
  );

  static const _emeraldAccent = Color(0xFF059669);
  static const _emeraldAccentLight = Color(0xFF34D399);

  static final AppThemeConfig _emeraldTheme = AppThemeConfig(
    accent: _emeraldAccent,
    accentLight: _emeraldAccentLight,
    accentGlow: _emeraldAccent.withOpacity(0.15),
    dark: _buildDarkTheme(_emeraldAccent, _emeraldAccentLight),
    light: _buildLightTheme(_emeraldAccent, _emeraldAccentLight),
  );

  static const _amberAccent = Color(0xFFD97706);
  static const _amberAccentLight = Color(0xFFFBBF24);

  static final AppThemeConfig _amberTheme = AppThemeConfig(
    accent: _amberAccent,
    accentLight: _amberAccentLight,
    accentGlow: _amberAccent.withOpacity(0.15),
    dark: _buildDarkTheme(_amberAccent, _amberAccentLight),
    light: _buildLightTheme(_amberAccent, _amberAccentLight),
  );

  static const _roseAccent = Color(0xFFE11D48);
  static const _roseAccentLight = Color(0xFFF43F5E);

  static final AppThemeConfig _roseTheme = AppThemeConfig(
    accent: _roseAccent,
    accentLight: _roseAccentLight,
    accentGlow: _roseAccent.withOpacity(0.15),
    dark: _buildDarkTheme(_roseAccent, _roseAccentLight),
    light: _buildLightTheme(_roseAccent, _roseAccentLight),
  );

  static const _slateAccent = Color(0xFF475569);
  static const _slateAccentLight = Color(0xFF94A3B8);

  static final AppThemeConfig _slateTheme = AppThemeConfig(
    accent: _slateAccent,
    accentLight: _slateAccentLight,
    accentGlow: _slateAccent.withOpacity(0.15),
    dark: _buildDarkTheme(_slateAccent, _slateAccentLight),
    light: _buildLightTheme(_slateAccent, _slateAccentLight),
  );

  static ThemeData _buildDarkTheme(Color accent, Color accentLight) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: _darkBg,
      colorScheme: ColorScheme.dark(
        primary: accent,
        secondary: accentLight,
        surface: _darkSurface,
        onSurface: _darkText,
        outline: _darkBorder,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: _darkText,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
        iconTheme: IconThemeData(color: _darkText),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
          color: _darkText,
        ),
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
          color: _darkText,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.3,
          color: _darkText,
        ),
        titleMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.3,
          color: _darkText,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: _darkText,
        ),
        bodyMedium: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: _darkText,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: _darkText,
        ),
        labelMedium: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: _darkTextSecondary,
        ),
        labelSmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.0,
          color: _darkTextTertiary,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: _darkBorder,
        thickness: 1,
      ),
      iconTheme: const IconThemeData(
        color: _darkText,
        size: 24,
      ),
      extensions: [
        GlassThemeExtension(
          surface: _darkSurface,
          elevated: _darkElevated,
          border: _darkBorder,
          textPrimary: _darkText,
          textSecondary: _darkTextSecondary,
          textTertiary: _darkTextTertiary,
          accent: accent,
          accentLight: accentLight,
          accentGlow: accent.withOpacity(0.15),
        ),
      ],
    );
  }

  static ThemeData _buildLightTheme(Color accent, Color accentLight) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: _lightSurface,
      colorScheme: ColorScheme.light(
        primary: accent,
        secondary: accentLight,
        surface: _lightSurface,
        onSurface: _lightText,
        outline: _lightBorder,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: _lightText,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
        iconTheme: IconThemeData(color: _lightText),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
          color: _lightText,
        ),
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
          color: _lightText,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.3,
          color: _lightText,
        ),
        titleMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.3,
          color: _lightText,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: _lightText,
        ),
        bodyMedium: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: _lightText,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: _lightText,
        ),
        labelMedium: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: _lightTextSecondary,
        ),
        labelSmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.0,
          color: _lightTextTertiary,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: _lightBorder,
        thickness: 1,
      ),
      iconTheme: const IconThemeData(
        color: _lightText,
        size: 24,
      ),
      extensions: [
        GlassThemeExtension(
          surface: _lightSurface,
          elevated: _lightElevated,
          border: _lightBorder,
          textPrimary: _lightText,
          textSecondary: _lightTextSecondary,
          textTertiary: _lightTextTertiary,
          accent: accent,
          accentLight: accentLight,
          accentGlow: accent.withOpacity(0.15),
        ),
      ],
    );
  }
}

class GlassThemeExtension extends ThemeExtension<GlassThemeExtension> {
  final Color surface;
  final Color elevated;
  final Color border;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color accent;
  final Color accentLight;
  final Color accentGlow;

  const GlassThemeExtension({
    required this.surface,
    required this.elevated,
    required this.border,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.accent,
    required this.accentLight,
    required this.accentGlow,
  });

  @override
  ThemeExtension<GlassThemeExtension> copyWith({
    Color? surface,
    Color? elevated,
    Color? border,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? accent,
    Color? accentLight,
    Color? accentGlow,
  }) {
    return GlassThemeExtension(
      surface: surface ?? this.surface,
      elevated: elevated ?? this.elevated,
      border: border ?? this.border,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      accent: accent ?? this.accent,
      accentLight: accentLight ?? this.accentLight,
      accentGlow: accentGlow ?? this.accentGlow,
    );
  }

  @override
  ThemeExtension<GlassThemeExtension> lerp(
    covariant ThemeExtension<GlassThemeExtension>? other,
    double t,
  ) {
    if (other is! GlassThemeExtension) return this;
    return GlassThemeExtension(
      surface: Color.lerp(surface, other.surface, t)!,
      elevated: Color.lerp(elevated, other.elevated, t)!,
      border: Color.lerp(border, other.border, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      accentLight: Color.lerp(accentLight, other.accentLight, t)!,
      accentGlow: Color.lerp(accentGlow, other.accentGlow, t)!,
    );
  }
}

extension ThemeExtension on ThemeData {
  GlassThemeExtension get glass => extension<GlassThemeExtension>()!;
}
