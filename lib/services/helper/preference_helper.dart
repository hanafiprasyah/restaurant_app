import 'package:shared_preferences/shared_preferences.dart';

class ThemeHelper {
  final Future<SharedPreferences> sharedPref;

  ThemeHelper({required this.sharedPref});

  static const darkTheme = "DARK_THEME";

  Future<bool> get getDarkValueFromHelper async {
    final prefs = await sharedPref;
    return prefs.getBool(darkTheme) ?? false;
  }

  void setDarkTheme(bool value) async {
    final prefs = await sharedPref;
    prefs.setBool(darkTheme, value);
  }
}

class DailyScheduleHelper {
  final Future<SharedPreferences> sharedPref;

  DailyScheduleHelper({required this.sharedPref});

  static const dailySchedule = "DAILY_SCHEDULE";

  Future<bool> get isDailyScheduleActive async {
    final prefs = await sharedPref;
    return prefs.getBool(dailySchedule) ?? false;
  }

  void setDailySchedule(bool value) async {
    final prefs = await sharedPref;
    prefs.setBool(dailySchedule, value);
  }
}
