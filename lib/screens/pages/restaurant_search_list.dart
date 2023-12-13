import 'package:auto_animated/auto_animated.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/components/card.dart';
import 'package:restaurant_app/services/data_provider.dart';

class SearchRestaurantPage extends StatefulWidget {
  const SearchRestaurantPage({super.key});

  @override
  State<SearchRestaurantPage> createState() => _SearchRestaurantPageState();
}

class _SearchRestaurantPageState extends State<SearchRestaurantPage> {
  final options = const LiveOptions(
    delay: Duration.zero,
    showItemInterval: Duration(milliseconds: 250),
    showItemDuration: Duration(milliseconds: 500),
    visibleFraction: 0.025,
    reAnimateOnVisibility: false,
  );

  @override
  Widget build(BuildContext context) {
    var data = Provider.of<RestaurantSearchProvider>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  flex: 8,
                  child: TextField(
                    onTap: () {
                      data.setSearchView();
                    },
                    onSubmitted: (name) {
                      if (name.isNotEmpty) {
                        /// TODO: using provider searchList() function to looking for the restaurant name
                        data.searchList(name);
                      } else {
                        /// TODO: clear the search list view
                        return data.clearView();
                      }
                    },
                    autofocus: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      /**
                       * Using enabled: true and false where state is loading or not.
                       * if it is on loading state, then disabled this TextField to avoid user input anything anonymous
                       */
                      enabled: true,
                      labelText: 'Search restaurant name',
                      labelStyle: GoogleFonts.quicksand(),
                      suffixIcon: const Icon(
                        Icons.search_rounded,
                        color: Colors.indigo,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: IconButton(
                    onPressed: () {
                      /// TODO: clear the search list view
                      FocusScope.of(context).requestFocus(FocusNode());
                      return data.clearView();
                    },
                    tooltip: 'Clear search',
                    icon: const Icon(Icons.delete_forever_rounded),
                    color: Colors.red,
                    iconSize: 24,
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 8,
          child: Consumer<RestaurantSearchProvider>(
            builder: (context, state, _) {
              if (state.state == SearchState.searching) {
                return Center(
                  child: Material(
                    child: Text(
                      'What are you looking for? Type the restaurant name or their menus..',
                      style: GoogleFonts.quicksand(),
                      maxLines: 2,
                      overflow: TextOverflow.clip,
                    ),
                  ),
                );
              } else if (state.state == SearchState.loading) {
                return Center(
                  child: LoadingAnimationWidget.fourRotatingDots(
                      color: Colors.indigo, size: 15),
                );
              } else if (state.state == SearchState.hasData) {
                return LiveList.options(
                  options: options,
                  shrinkWrap: false,
                  itemCount: state.restaurant.restaurants.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index, animation) {
                    var restaurant = state.restaurant.restaurants[index];
                    return FadeTransition(
                      opacity: Tween<double>(
                        begin: 0,
                        end: 1,
                      ).animate(animation),
                      // And slide transition
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, -0.1),
                          end: Offset.zero,
                        ).animate(animation),
                        // Paste you Widget
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          /**
                           * CustomCard : lib/components/card.dart
                           */
                          child: HorizontalListCard(
                            id: restaurant.id,
                            imageId: restaurant.pictureId,
                            name: restaurant.name,
                            city: restaurant.city,
                            rating: restaurant.rating.toDouble(),
                            restaurantElement: restaurant,
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else if (state.state == SearchState.noData) {
                return Center(
                  child: Material(
                      child: Text(
                    state.msg,
                    style: GoogleFonts.quicksand(),
                    maxLines: 2,
                    overflow: TextOverflow.clip,
                  )),
                );
              } else if (state.state == SearchState.error) {
                return Center(
                  child: Material(
                      child: Text(
                    state.msg,
                    style: GoogleFonts.quicksand(),
                    maxLines: 2,
                    overflow: TextOverflow.clip,
                  )),
                );
              } else {
                return Center(
                  child: Material(
                    child: Text(
                      'Search your favourite restaurant here!',
                      style: GoogleFonts.quicksand(),
                      maxLines: 2,
                      overflow: TextOverflow.clip,
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
