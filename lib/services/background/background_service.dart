import 'dart:isolate';
import 'dart:ui';

import 'package:restaurant_app/main.dart';
import 'package:restaurant_app/services/helper/notification_helper.dart';
import 'package:restaurant_app/services/network/api_service.dart';

final ReceivePort port = ReceivePort();

class BackgroundService {
  static BackgroundService? _instance;
  static const String _isolateName = 'isolate';
  static SendPort? _uiSendPort;

  BackgroundService._internal() {
    _instance = this;
  }

  factory BackgroundService() => _instance ?? BackgroundService._internal();

  void initIsolate() {
    IsolateNameServer.registerPortWithName(port.sendPort, _isolateName);
  }

  static Future<void> callback() async {
    final NotificationHelper notificationHelper = NotificationHelper();
    var res = await ApiService().restaurantList();
    await notificationHelper.showNotification(
        flutterLocalNotificationsPlugin, res);

    _uiSendPort ??= IsolateNameServer.lookupPortByName(_isolateName);
    _uiSendPort?.send(null);
  }
}
