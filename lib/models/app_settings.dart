import 'calculation.dart';

class AppSettings {
  final bool isDarkMode;
  final String themeId;
  final int defaultTipPercentage;
  final int defaultNumberOfPeople;
  final String defaultCurrencyCode;
  final RoundingOption defaultRounding;

  const AppSettings({
    this.isDarkMode = false,
    this.themeId = 'violet',
    this.defaultTipPercentage = 18,
    this.defaultNumberOfPeople = 1,
    this.defaultCurrencyCode = 'USD',
    this.defaultRounding = RoundingOption.none,
  });

  AppSettings copyWith({
    bool? isDarkMode,
    String? themeId,
    int? defaultTipPercentage,
    int? defaultNumberOfPeople,
    String? defaultCurrencyCode,
    RoundingOption? defaultRounding,
  }) {
    return AppSettings(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      themeId: themeId ?? this.themeId,
      defaultTipPercentage: defaultTipPercentage ?? this.defaultTipPercentage,
      defaultNumberOfPeople: defaultNumberOfPeople ?? this.defaultNumberOfPeople,
      defaultCurrencyCode: defaultCurrencyCode ?? this.defaultCurrencyCode,
      defaultRounding: defaultRounding ?? this.defaultRounding,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isDarkMode': isDarkMode,
      'themeId': themeId,
      'defaultTipPercentage': defaultTipPercentage,
      'defaultNumberOfPeople': defaultNumberOfPeople,
      'defaultCurrencyCode': defaultCurrencyCode,
      'defaultRounding': defaultRounding.index,
    };
  }

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      isDarkMode: json['isDarkMode'] as bool? ?? false,
      themeId: json['themeId'] as String? ?? 'violet',
      defaultTipPercentage: json['defaultTipPercentage'] as int? ?? 18,
      defaultNumberOfPeople: json['defaultNumberOfPeople'] as int? ?? 1,
      defaultCurrencyCode: json['defaultCurrencyCode'] as String? ?? 'USD',
      defaultRounding: RoundingOption.values[json['defaultRounding'] as int? ?? 0],
    );
  }
}
