import 'package:flutter/material.dart';
import 'models/models.dart';
import 'themes/app_themes.dart';
import 'services/storage_service.dart';
import 'pages/main_shell.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();
  
  final settings = StorageService.loadSettings();
  final themes = AppThemes.getThemes(settings.themeId);
  final currency = Currency.fromCode(settings.defaultCurrencyCode);
  
  runApp(TipCalcApp(
    settings: settings,
    initialTheme: settings.isDarkMode ? themes.dark : themes.light,
    defaultCurrency: currency,
  ));
}

class TipCalcApp extends StatefulWidget {
  final AppSettings settings;
  final ThemeData initialTheme;
  final Currency defaultCurrency;

  const TipCalcApp({
    super.key,
    required this.settings,
    required this.initialTheme,
    required this.defaultCurrency,
  });

  @override
  State<TipCalcApp> createState() => _TipCalcAppState();
}

class _TipCalcAppState extends State<TipCalcApp> {
  late AppSettings _settings;
  late ThemeData _theme;
  late Currency _currency;
  final GlobalKey<_AppState> _appKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _settings = widget.settings;
    _theme = widget.initialTheme;
    _currency = widget.defaultCurrency;
  }

  void _onSettingsChanged(AppSettings newSettings) {
    final newThemes = AppThemes.getThemes(newSettings.themeId);
    final newTheme = newSettings.isDarkMode ? newThemes.dark : newThemes.light;
    final newCurrency = Currency.fromCode(newSettings.defaultCurrencyCode);
    
    setState(() {
      _settings = newSettings;
      _theme = newTheme;
      _currency = newCurrency;
    });
    StorageService.saveSettings(newSettings);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tip Calculator',
      debugShowCheckedModeBanner: false,
      theme: _theme,
      home: _AppStateProvider(
        key: _appKey,
        settings: _settings,
        currency: _currency,
        onSettingsChanged: _onSettingsChanged,
      ),
    );
  }
}

class _AppStateProvider extends StatefulWidget {
  final AppSettings settings;
  final Currency currency;
  final Function(AppSettings) onSettingsChanged;

  const _AppStateProvider({
    super.key,
    required this.settings,
    required this.currency,
    required this.onSettingsChanged,
  });

  @override
  State<_AppStateProvider> createState() => _AppState();
}

class _AppState extends State<_AppStateProvider> {
  late AppSettings _settings;
  late Currency _currency;

  @override
  void initState() {
    super.initState();
    _settings = widget.settings;
    _currency = widget.currency;
  }

  void _updateSettings(AppSettings newSettings) {
    setState(() {
      _settings = newSettings;
      _currency = Currency.fromCode(newSettings.defaultCurrencyCode);
    });
    widget.onSettingsChanged(newSettings);
  }

  @override
  Widget build(BuildContext context) {
    return _AppContext(
      settings: _settings,
      currency: _currency,
      onSettingsChanged: _updateSettings,
      child: MainShell(
        settings: _settings,
        currency: _currency,
        onSettingsChanged: _updateSettings,
        onThemeChanged: () {},
      ),
    );
  }
}

class _AppContext extends InheritedWidget {
  final AppSettings settings;
  final Currency currency;
  final Function(AppSettings) onSettingsChanged;

  const _AppContext({
    required this.settings,
    required this.currency,
    required this.onSettingsChanged,
    required super.child,
  });

  static _AppContext of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<_AppContext>();
    if (result == null) {
      throw FlutterError('AppContext not found');
    }
    return result;
  }

  @override
  bool updateShouldNotify(_AppContext oldWidget) {
    return settings != oldWidget.settings || currency != oldWidget.currency;
  }
}
