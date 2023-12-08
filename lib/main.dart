import 'package:flutter/material.dart';
import 'package:restaurant_app/model/restaurant.dart';
import 'package:restaurant_app/view/404.dart';
import 'package:restaurant_app/view/detail_page.dart';
import 'package:restaurant_app/view/home_screen.dart';

/// Cheat from me:
/// Started with braces it is means that you have the Map
/// Started with square bracket it is means that you have the List of the Map

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Restaurant App",
        theme: ThemeData(
          useMaterial3: true,
          primarySwatch: Colors.indigo,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        locale: const Locale('id', 'ID'),
        onUnknownRoute: (settings) =>
            MaterialPageRoute(builder: (_) => const ErrorPage()),
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        debugShowMaterialGrid: false,
        initialRoute: "/",
        routes: {
          "/": (context) => const HomeScreen(),
          "/detail": (context) => DetailPage(
              data: ModalRoute.of(context)?.settings.arguments as Restaurant)
        });
  }
}
