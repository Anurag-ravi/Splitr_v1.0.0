// ignore_for_file: constant_identifier_names

import 'package:shared_preferences/shared_preferences.dart';

class ThemePreferences {
  static const PREF_KEY = 'pref_key';

  setTheme(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(PREF_KEY, value);
  }
  getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isdark = prefs.getBool(PREF_KEY)==null ? false : prefs.getBool(PREF_KEY)!;
    return isdark;
  }
}