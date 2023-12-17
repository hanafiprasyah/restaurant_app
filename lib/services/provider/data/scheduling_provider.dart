import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app/services/background/background_service.dart';
import 'package:restaurant_app/services/helper/date_helper.dart';

class SchedulingProvider extends ChangeNotifier {
  bool _isSchedule = false;
  bool get isSchedule => _isSchedule;

  Future<bool> scheduledDataRestaurant(bool value) async {
    _isSchedule = value;
    if (_isSchedule) {
      notifyListeners();
      return await AndroidAlarmManager.periodic(
        const Duration(hours: 24),
        1,
        BackgroundService.callback,
        startAt: DateTimeHelper.format(),
        exact: true,
        wakeup: true,
      );
    } else {
      notifyListeners();
      return await AndroidAlarmManager.cancel(1);
    }
  }
}
