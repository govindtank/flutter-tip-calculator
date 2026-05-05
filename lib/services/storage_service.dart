import 'dart:convert' as convert;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';

class StorageService {
  static const String _settingsKey = 'app_settings';
  static const String _historyKey = 'calculation_history';

  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> saveSettings(AppSettings settings) async {
    final jsonString = convert.jsonEncode(settings.toJson());
    await _prefs.setString(_settingsKey, jsonString);
  }

  static AppSettings loadSettings() {
    final jsonString = _prefs.getString(_settingsKey);
    if (jsonString == null) {
      return const AppSettings();
    }
    try {
      final json = convert.jsonDecode(jsonString) as Map<String, dynamic>;
      return AppSettings.fromJson(json);
    } catch (e) {
      return const AppSettings();
    }
  }

  static Future<void> saveHistory(List<TipCalculation> history) async {
    final jsonList = history.map((calc) => calc.toJson()).toList();
    final jsonString = convert.jsonEncode(jsonList);
    await _prefs.setString(_historyKey, jsonString);
  }

  static List<TipCalculation> loadHistory() {
    final jsonString = _prefs.getString(_historyKey);
    if (jsonString == null) {
      return [];
    }
    try {
      final jsonList = convert.jsonDecode(jsonString) as List<dynamic>;
      return jsonList
          .map((json) => TipCalculation.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  static Future<void> clearHistory() async {
    await _prefs.remove(_historyKey);
  }

  static Future<void> addToHistory(TipCalculation calculation) async {
    final history = loadHistory();
    history.insert(0, calculation);
    // Keep only last 100 calculations
    if (history.length > 100) {
      history.removeRange(100, history.length);
    }
    await saveHistory(history);
  }

  static Future<void> removeFromHistory(String id) async {
    final history = loadHistory();
    history.removeWhere((calc) => calc.id == id);
    await saveHistory(history);
  }
}
