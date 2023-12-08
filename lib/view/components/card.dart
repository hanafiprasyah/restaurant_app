import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomCard extends StatelessWidget {
  const CustomCard(
      {super.key,
      required this.id,
      required this.imageUrl,
      required this.name,
      required this.city,
      required this.rating,
      required this.onPress});

  /// Image URL on String
  final String imageUrl;

  /// Restaurant Name on String
  final String name;

  /// Restaurant Location (City) on String
  final String city;

  /// Restaurant Rating on integer
  final double rating;

  /// Restaurant UUID on String
  final String id;

  /// onTap Function on void Callbacks
  final Function() onPress;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      autofocus: false,
      onDoubleTap: null,
      splashColor: Colors.black12,
      child: Container(
        height: kToolbarHeight * 2,
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// It will display the image of this restaurant
            Expanded(
              flex: 4,
              child: Hero(
                tag: id,
                transitionOnUserGestures: true,
                child: Container(
                  margin: const EdgeInsets.only(left: 16),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(imageUrl),
                      filterQuality: FilterQuality.medium,
                      fit: BoxFit.cover,
                    ),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),

            /// It will display the restaurant name,location,rating
            Expanded(
                flex: 8,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                      ),
                      const SizedBox(height: 8),

                      /// Restaurant location with icon on Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(right: 4),
                            child: Icon(Icons.pin_drop,
                                color: Colors.grey, size: 12),
                          ),
                          Text(
                            city,
                            style: GoogleFonts.quicksand(
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.clip,
                          ),
                        ],
                      ),

                      /// Restaurant rating on Row
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(right: 4),
                              child: Icon(Icons.star,
                                  color: Colors.orangeAccent, size: 14),
                            ),
                            Text(
                              '$rating',
                              style: GoogleFonts.quicksand(
                                fontWeight: FontWeight.w400,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
