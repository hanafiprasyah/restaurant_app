import 'dart:io';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:restaurant_app/components/navigator.dart';
import 'package:restaurant_app/models/restaurant/restaurant.dart';
import 'package:restaurant_app/screens/ui/detail_screen.dart';
import 'package:restaurant_app/screens/ui/home_screen.dart';
import 'package:restaurant_app/screens/ui/route_not_found.dart';
import 'package:restaurant_app/services/background/background_service.dart';
import 'package:restaurant_app/services/helper/database_helper.dart';
import 'package:restaurant_app/services/helper/notification_helper.dart';
import 'package:restaurant_app/services/helper/preference_helper.dart';
import 'package:restaurant_app/services/network/api_service.dart';
import 'package:restaurant_app/services/provider/data/database_provider.dart';
import 'package:restaurant_app/services/provider/data/restaurant_detail_provider.dart';
import 'package:restaurant_app/services/provider/data/restaurant_list_provider.dart';
import 'package:restaurant_app/services/provider/data/restaurant_search_provider.dart';
import 'package:restaurant_app/services/provider/data/scheduling_provider.dart';
import 'package:restaurant_app/services/provider/screen/connection_provider.dart';
import 'package:restaurant_app/services/provider/screen/home_page_provider.dart';
import 'package:restaurant_app/services/provider/screen/home_view_provider.dart';
import 'package:restaurant_app/services/provider/screen/preference_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final NotificationHelper notificationHelper = NotificationHelper();
  final BackgroundService backgroundService = BackgroundService();

  backgroundService.initIsolate();

  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.requestNotificationsPermission();
  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.requestExactAlarmsPermission();

  if (Platform.isAndroid) {
    AndroidAlarmManager.initialize();
  }

  await notificationHelper.initNotifications(flutterLocalNotificationsPlugin);

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => MultiProvider(
        providers: [
          ChangeNotifierProvider<RestaurantListProvider>(
            create: (_) => RestaurantListProvider(apiService: ApiService()),
          ),
          ChangeNotifierProvider<SelectedHomePageProvider>(
            create: (_) => SelectedHomePageProvider(),
          ),
          ChangeNotifierProvider<ConnectivityListenerProvider>(
            create: (_) => ConnectivityListenerProvider(),
          ),
          ChangeNotifierProvider<SelectViewHomeProvider>(
            create: (_) => SelectViewHomeProvider(),
          ),
          ChangeNotifierProvider<RestaurantDetailProvider>(
            create: (_) => RestaurantDetailProvider(),
          ),
          ChangeNotifierProvider<RestaurantSearchProvider>(
            create: (_) => RestaurantSearchProvider(apiService: ApiService()),
          ),
          ChangeNotifierProvider<PreferencesProvider>(
            create: (_) => PreferencesProvider(
              preferenceHelper: PreferencesHelper(
                sharedPref: SharedPreferences.getInstance(),
              ),
            ),
          ),
          ChangeNotifierProvider<DatabaseProvider>(
            create: (_) => DatabaseProvider(
              databaseHelper: DatabaseHelper(),
            ),
          ),
          ChangeNotifierProvider<SchedulingProvider>(
            create: (_) => SchedulingProvider(),
          ),
        ],
        child: const App(),
      ),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveApp(
      preferDesktop: false,
      builder: (_) => Consumer<PreferencesProvider>(
        builder: (context, value, child) {
          return MaterialApp(
            title: "Restaurant App",
            theme: value.theme,
            locale: DevicePreview.locale(context),
            navigatorKey: navigatorKey,
            builder: (context, child) {
              if (kReleaseMode) {
                /// Avoid text scale on release mode
                MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                    textScaler: const TextScaler.linear(1.0),
                  ),
                  child: child!,
                );
              } else {
                DevicePreview.appBuilder(context, child);
              }

              /// Showing the device preview when on development mode
              return CupertinoTheme(
                data: CupertinoThemeData(
                  brightness: value.isDark ? Brightness.dark : Brightness.light,
                ),
                child: child!,
              );
            },
            themeMode: ThemeMode.system,
            debugShowCheckedModeBanner: false,
            debugShowMaterialGrid: false,
            initialRoute: "/",
            routes: {
              "/": (context) => const HomeScreen(),
              "/detail": (context) => DetailPage(
                    data: ModalRoute.of(context)?.settings.arguments
                        as RestaurantElement,
                  ),
            },
            onUnknownRoute: (settings) =>
                MaterialPageRoute(builder: (_) => const RouteNotFound()),
          );
        },
      ),
    );
  }
}
