import 'package:flutter/material.dart';
import 'package:restaurant_app/components/styles.dart';
import 'package:restaurant_app/services/helper/preference_helper.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeHelper preferenceHelper;

  ThemeProvider({required this.preferenceHelper}) {
    getTheme();
  }

  bool _isDark = false;
  bool get isDark => _isDark;

  ThemeData get theme => _isDark ? darkTheme : lightTheme;

  void getTheme() async {
    _isDark = await preferenceHelper.getDarkValueFromHelper;
    notifyListeners();
  }

  void enableDarkTheme(bool value) async {
    preferenceHelper.setDarkTheme(value);
    getTheme();
  }
}
