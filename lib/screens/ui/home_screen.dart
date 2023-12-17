import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/screens/pages/favourite_restaurant_page.dart';
import 'package:restaurant_app/screens/pages/restaurant_list_page.dart';
import 'package:restaurant_app/screens/pages/restaurant_search_list.dart';
import 'package:restaurant_app/screens/pages/settings_page.dart';
import 'package:restaurant_app/services/helper/notification_helper.dart';
import 'package:restaurant_app/services/provider/screen/connection_provider.dart';
import 'package:restaurant_app/services/provider/screen/home_page_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NotificationHelper notificationHelper = NotificationHelper();
  StreamSubscription? connection;
  @override
  void initState() {
    super.initState();
    connection = Connectivity().onConnectivityChanged.listen((result) {
      if (result == ConnectivityResult.none) {
        context.read<ConnectivityListenerProvider>().setOffline(result);
      } else {
        context.read<ConnectivityListenerProvider>().setOnline(result);
      }
    });
    notificationHelper.configSelectNotificationSubject('/detail');
  }

  @override
  void dispose() {
    connection!.cancel();
    selectNotificationSubject.close();
    super.dispose();
  }

  static const List<Widget> pages = [
    RestaurantListPage(),
    FavouriteRestaurantPage(),
    SearchRestaurantPage(),
    SettingPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              rippleColor: Colors.grey[300]!,
              hoverColor: Colors.grey[100]!,
              gap: 8,
              activeColor: Colors.indigo,
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: const Duration(milliseconds: 400),
              tabBackgroundColor: Colors.grey[100]!,
              color: Colors.blueGrey,
              tabs: [
                GButton(
                  icon: Ionicons.home_outline,
                  textStyle: GoogleFonts.quicksand(fontSize: 12),
                  text: 'Home',
                ),
                GButton(
                  icon: Ionicons.heart_outline,
                  textStyle: GoogleFonts.quicksand(fontSize: 12),
                  text: 'Favourite',
                ),
                GButton(
                  icon: Ionicons.search_outline,
                  textStyle: GoogleFonts.quicksand(fontSize: 12),
                  text: 'Search',
                ),
                GButton(
                  icon: Ionicons.cog_outline,
                  textStyle: GoogleFonts.quicksand(fontSize: 12),
                  text: 'Settings',
                ),
              ],
              selectedIndex: context.watch<SelectedHomePageProvider>().index,
              onTabChange: (index) {
                context
                    .read<SelectedHomePageProvider>()
                    .onTabChangeSelectedIndex(index);
              },
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: context.watch<ConnectivityListenerProvider>().offline == true
            ? Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Text(
                    'No internet access',
                    style: GoogleFonts.quicksand(),
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                  ),
                ),
              )
            : pages.elementAt(context.watch<SelectedHomePageProvider>().index),
      ),
    );
  }
}
