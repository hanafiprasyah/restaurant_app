import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restaurant_app/model/restaurant.dart';
import 'package:restaurant_app/view/components/card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          physics: const BouncingScrollPhysics(),
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                toolbarHeight: kToolbarHeight * 2,
                expandedHeight: 130,
                elevation: 0,
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Restaurant',
                      style: GoogleFonts.quicksand(
                          fontSize: 28, fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                    ),
                    Text(
                      'Recommendation restaurant for you!',
                      style: GoogleFonts.quicksand(
                          fontSize: 18, fontWeight: FontWeight.w300),
                      maxLines: 2,
                      overflow: TextOverflow.clip,
                    ),
                  ],
                ),
              )
            ];
          },
          body: FutureBuilder<String>(
            future: DefaultAssetBundle.of(context).loadString(
              'assets/local_restaurant.json',
              cache: true,
            ),
            builder: (context, snapshot) {
              final List<Restaurant> restaurant =
                  parseRestaurant(snapshot.data);
              return ListView.builder(
                itemCount: restaurant.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return _buildItem(context, restaurant[index]);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildItem(BuildContext context, Restaurant restaurant) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      /**
       * CustomCard : lib/components/card.dart
       */
      child: CustomCard(
        id: restaurant.id,
        onPress: () =>
            Navigator.pushNamed(context, '/detail', arguments: restaurant),
        imageUrl: restaurant.pictureId,
        name: restaurant.name,
        city: restaurant.city,
        rating: restaurant.rating,
      ),
    );
  }
}
