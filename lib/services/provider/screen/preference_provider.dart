import 'package:flutter/material.dart';
import 'package:restaurant_app/components/styles.dart';
import 'package:restaurant_app/services/helper/preference_helper.dart';

class PreferencesProvider extends ChangeNotifier {
  PreferencesHelper preferenceHelper;

  PreferencesProvider({required this.preferenceHelper}) {
    getTheme();
    getDailySchedulePref();
  }

  bool _isDark = false;
  bool get isDark => _isDark;

  bool _isDailyScheduleActive = false;
  bool get isDailyScheduleActive => _isDailyScheduleActive;

  ThemeData get theme => _isDark ? darkTheme : lightTheme;

  void getTheme() async {
    _isDark = await preferenceHelper.getDarkValueFromHelper;
    notifyListeners();
  }

  void enableDarkTheme(bool value) async {
    preferenceHelper.setDarkTheme(value);
    getTheme();
  }

  void getDailySchedulePref() async {
    _isDailyScheduleActive = await preferenceHelper.isDailyScheduleActive;
    notifyListeners();
  }

  void enableDailySchedule(bool value) {
    preferenceHelper.setDailySchedule(value);
    getDailySchedulePref();
  }
}
