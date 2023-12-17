import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  /// This page will displayed if user
  /// navigate to unknown routes
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        elevation: 2,
        centerTitle: true,
        titleTextStyle: GoogleFonts.quicksand(),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              '404 Not Found. Please back to previous page!',
              style: GoogleFonts.quicksand(),
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.clip,
            ),
          ),
        ),
      ),
    );
  }
}
