import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restaurant_app/components/navigator.dart';
import 'package:restaurant_app/models/restaurant/restaurant.dart';

class GridViewCard extends StatelessWidget {
  const GridViewCard({
    super.key,
    required this.imageId,
    required this.name,
    required this.city,
    required this.rating,
    required this.id,
    required this.restaurantElement,
  });

  /// Image URL on String
  final String imageId;

  /// Restaurant Name on String
  final String name;

  /// Restaurant Location (City) on String
  final String city;

  /// Restaurant Rating on integer
  final double rating;

  /// Restaurant UUID on String
  final String id;

  /// Restaurant
  final RestaurantElement restaurantElement;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigation.intentWithData('/detail', restaurantElement),
      autofocus: false,
      onDoubleTap: null,
      splashColor: Colors.black12,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200]!,
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// It will display the image of this restaurant
            Hero(
              tag: id,
              transitionOnUserGestures: true,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: (MediaQuery.of(context).size.height /
                        MediaQuery.of(context).size.width) *
                    kToolbarHeight,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(
                      "https://restaurant-api.dicoding.dev/images/small/$imageId",
                      errorListener: (val) => const Icon(Icons.error),
                    ),
                    filterQuality: FilterQuality.medium,
                    fit: BoxFit.cover,
                  ),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            /// It will display the restaurant name,location,rating
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    name,
                    style: GoogleFonts.quicksand(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                  ),

                  /// Restaurant location with icon on Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(right: 4),
                        child:
                            Icon(Icons.pin_drop, color: Colors.grey, size: 12),
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
                    padding: const EdgeInsets.only(top: 8),
                    child: SizedBox(
                      child: RatingStars(
                        value: rating,
                        starBuilder: (index, color) => Icon(
                          Icons.star,
                          color: color,
                          size: 12,
                        ),
                        starCount: 5,
                        starSize: 12,
                        valueLabelColor: Colors.indigo,
                        valueLabelTextStyle: GoogleFonts.quicksand(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: 10,
                        ),
                        valueLabelRadius: 10,
                        maxValue: 5,
                        starSpacing: 2,
                        maxValueVisibility: true,
                        valueLabelVisibility: true,
                        animationDuration: const Duration(milliseconds: 1000),
                        valueLabelPadding: const EdgeInsets.symmetric(
                            vertical: 1, horizontal: 8),
                        valueLabelMargin: const EdgeInsets.only(right: 8),
                        starOffColor: const Color(0xffe7e8ea),
                        starColor: Colors.yellow,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
