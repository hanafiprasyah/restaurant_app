import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/screens/pages/booked_restaurant_page.dart';
import 'package:restaurant_app/screens/pages/restaurant_list_page.dart';
import 'package:restaurant_app/screens/pages/restaurant_search_list.dart';
import 'package:restaurant_app/screens/pages/settings_page.dart';
import 'package:restaurant_app/services/screen_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
  }

  @override
  void dispose() {
    connection!.cancel();
    super.dispose();
  }

  static const List<Widget> pages = [
    RestaurantListPage(),
    BookedRestaurantPage(),
    SearchRestaurantPage(),
    SettingPage(),
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
                  icon: Icons.home_max_rounded,
                  textStyle: GoogleFonts.quicksand(fontSize: 12),
                  text: 'Home',
                ),
                GButton(
                  icon: Icons.bookmark_add_rounded,
                  textStyle: GoogleFonts.quicksand(fontSize: 12),
                  text: 'Booked',
                ),
                GButton(
                  icon: Icons.search_rounded,
                  textStyle: GoogleFonts.quicksand(fontSize: 12),
                  text: 'Search',
                ),
                GButton(
                  icon: Icons.settings,
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
            ? Center(
                child: Text(
                  'No internet access.',
                  style: GoogleFonts.quicksand(),
                  maxLines: 1,
                  overflow: TextOverflow.fade,
                ),
              )
            : pages.elementAt(context.watch<SelectedHomePageProvider>().index),
      ),
    );
  }
}
