import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:restaurant_app/models/restaurants/restaurant.dart';
import 'package:restaurant_app/screens/detail_screen.dart';
import 'package:restaurant_app/screens/error_screen.dart';
import 'package:restaurant_app/screens/home_screen.dart';
import 'package:restaurant_app/services/api_service.dart';
import 'package:restaurant_app/services/data_provider.dart';
import 'package:restaurant_app/services/screen_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(DevicePreview(
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
      ],
      child: const App(),
    ),
  ));
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveApp(
      preferDesktop: false,
      builder: (_) => MaterialApp(
        title: "Restaurant App",
        theme: ThemeData.light(useMaterial3: true),
        darkTheme: ThemeData.dark(useMaterial3: true),
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,
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
            MaterialPageRoute(builder: (_) => const ErrorPage()),
      ),
    );
  }
}
