import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BookedRestaurantPage extends StatelessWidget {
  const BookedRestaurantPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Under construction. Will be available ASAP!',
        style: GoogleFonts.quicksand(),
        maxLines: 2,
        overflow: TextOverflow.clip,
      ),
    );
  }
}
