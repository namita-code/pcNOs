import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SharedPrefs {
  static SharedPreferences? _prefs;

  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Save Todo
  static Future saveTodo(String content) async {
    await _prefs?.setString("todo_plan", content);
  }

  // Load Todo
  static String? getTodo() {
    return _prefs?.getString("todo_plan");
  }

  // Clear
  static Future clearTodo() async {
    await _prefs?.remove("todo_plan");
  }

  static Future saveSymptomsData(Map<String, dynamic> data) async {
    await _prefs?.setString("symptoms_data", jsonEncode(data));
  }

  static Map<String, dynamic>? getSymptomsData() {
    final raw = _prefs?.getString("symptoms_data");
    if (raw == null) return null;
    return jsonDecode(raw);
  }

  static Future clearSymptomsData() async {
    await _prefs?.remove("symptoms_data");
  }

}
