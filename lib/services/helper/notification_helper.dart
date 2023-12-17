import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:restaurant_app/components/navigator.dart';
import 'package:restaurant_app/models/restaurant/list.dart';
import 'package:restaurant_app/models/restaurant/restaurant.dart';
import 'package:rxdart/rxdart.dart';

final selectNotificationSubject = BehaviorSubject<String?>();

class NotificationHelper {
  static NotificationHelper? _instance;

  NotificationHelper._internal() {
    _instance = this;
  }

  factory NotificationHelper() => _instance ?? NotificationHelper._internal();

  Future<void> initNotifications(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var init = const AndroidInitializationSettings('app_icon');
    var initSettings = InitializationSettings(android: init);

    await flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) async {
        final payload = details.payload;
        selectNotificationSubject.add(payload ?? 'empty payload');
      },
    );
  }

  Future<String> _downloadAndSaveFile(String url, String fileName) async {
    var directory = await getApplicationDocumentsDirectory();
    var filePath = '${directory.path}/$fileName';
    var response = await http.get(Uri.parse(url));
    var file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  /// Set random restaurant from RestaurantElement Model
  RestaurantElement _setRandomIndexForRestaurant(
      RestaurantList restaurantList) {
    var randomRestaurantIndex =
        Random().nextInt(restaurantList.restaurants.length);
    var randomRestaurantSelected =
        restaurantList.restaurants[randomRestaurantIndex];
    return randomRestaurantSelected;
  }

  Future<void> showNotification(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      RestaurantList restaurantList) async {
    /// get random restaurant from _setRandomIndexForRestaurant function
    var random = _setRandomIndexForRestaurant(restaurantList);

    /// notification channel info
    var channelId = "01";
    var channelName = "channel_01";
    var channelDescription = "favourite restaurant channel";

    var image = await _downloadAndSaveFile(
        'https://restaurant-api.dicoding.dev/images/small/${random.pictureId}',
        'restaurant-${random.pictureId}');

    var vibratePattern = Int64List(4);
    vibratePattern[0] = 0;
    vibratePattern[1] = 1000;
    vibratePattern[2] = 4000;
    vibratePattern[3] = 2000;

    var androidPlatformDetails = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      icon: 'secondary_icon',
      sound: const RawResourceAndroidNotificationSound('slow_spring_board'),
      largeIcon: DrawableResourceAndroidBitmap(
        random.pictureId,
      ),
      enableVibration: true,
      vibrationPattern: vibratePattern,
      enableLights: false,
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      styleInformation: BigPictureStyleInformation(
        FilePathAndroidBitmap(image),
        contentTitle: random.name,
        summaryText: random.city,
        htmlFormatContentTitle: true,
        htmlFormatSummaryText: true,
      ),
    );

    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformDetails,
    );

    var notificationTitle = "Favourite Restaurant";
    var restaurantTitle = "Here's today's restaurant for you";

    await flutterLocalNotificationsPlugin.show(
      0,
      notificationTitle,
      restaurantTitle,
      platformChannelSpecifics,
      payload: json.encode(
        random.toJson(),
      ),
    );
  }

  void configSelectNotificationSubject(String route) {
    selectNotificationSubject.stream.listen(
      (payload) async {
        // var data = RestaurantList.fromJson(json.decode(payload!));
        var data = RestaurantElement.fromJson(json.decode(payload!));
        // var article = data.restaurants[0];
        // var random = _setRandomIndexForRestaurant(data);
        Navigation.intentWithData(route, data);
      },
    );
  }
}
