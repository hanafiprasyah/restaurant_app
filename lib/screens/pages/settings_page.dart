import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/services/provider/data/scheduling_provider.dart';
import 'package:restaurant_app/services/provider/screen/preference_provider.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PreferencesProvider>(
      builder: (context, value, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 36, bottom: 36),
              child: Text(
                'Settings',
                style: GoogleFonts.quicksand(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Expanded(
              flex: 8,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Application Theme',
                              style: GoogleFonts.quicksand(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'Change theme by yours',
                              style: GoogleFonts.quicksand(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        DayNightSwitcher(
                          isDarkModeEnabled: value.isDark,
                          onStateChanged: (isDarkModeEnabled) {
                            value.enableDarkTheme(isDarkModeEnabled);
                          },
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Notification',
                              style: GoogleFonts.quicksand(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'Enable notification',
                              style: GoogleFonts.quicksand(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        Consumer<SchedulingProvider>(
                          builder: (context, provider, _) {
                            return Switch.adaptive(
                              value: value.isDailyScheduleActive,
                              onChanged: (scheduled) async {
                                provider.scheduledDataRestaurant(scheduled);
                                value.enableDailySchedule(scheduled);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      scheduled
                                          ? 'Got it! We will give you information every 11 AM about the best restaurants for lunch!'
                                          : 'Oh no, you You will not get any restaurant suggestions from us!',
                                      style: GoogleFonts.quicksand(),
                                      maxLines: 2,
                                      overflow: TextOverflow.clip,
                                    ),
                                    duration: const Duration(seconds: 1),
                                    elevation: 0,
                                    dismissDirection: DismissDirection.down,
                                    showCloseIcon: true,
                                    closeIconColor: Colors.white,
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
