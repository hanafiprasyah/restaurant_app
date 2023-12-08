import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  /// This page will displayed if user
  /// navigate to unknown routes

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: Text('404 Not Found. Please back to previous page!'),
        ),
      ),
    );
  }
}
