import 'package:auto_animated/auto_animated.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/components/cards/listview_card.dart';
import 'package:restaurant_app/components/styles.dart';
import 'package:restaurant_app/services/provider/data/restaurant_search_provider.dart';

class SearchRestaurantPage extends StatefulWidget {
  const SearchRestaurantPage({super.key});

  @override
  State<SearchRestaurantPage> createState() => _SearchRestaurantPageState();
}

class _SearchRestaurantPageState extends State<SearchRestaurantPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    if (!mounted) {
      _searchController.dispose();
    }
    super.dispose();
  }

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
            child: TextField(
              controller: _searchController,
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
                enabled: data.state == SearchState.loading ? false : true,
                labelText: 'Search restaurant name',
                labelStyle: GoogleFonts.quicksand(),
                suffixIcon: data.state == SearchState.searching
                    ? const Icon(
                        Icons.search_rounded,
                        color: Colors.indigo,
                      )
                    : IconButton(
                        icon: const Icon(
                          Icons.close_rounded,
                          color: Colors.redAccent,
                        ),
                        onPressed: () {
                          /// TODO: clear the search list view
                          FocusScope.of(context).requestFocus(FocusNode());
                          _searchController.clear();
                          return data.clearView();
                        },
                      ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 8,
          child: Consumer<RestaurantSearchProvider>(
            builder: (context, state, _) {
              if (state.state == SearchState.searching) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Material(
                      child: Text(
                        'What are you looking for? Type the restaurant name or their menus..',
                        style: GoogleFonts.quicksand(),
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.clip,
                      ),
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
                  options: globalOptions,
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
                          child: ListViewCard(
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
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Material(
                        child: Text(
                      state.msg,
                      style: GoogleFonts.quicksand(),
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.clip,
                    )),
                  ),
                );
              } else if (state.state == SearchState.error) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Material(
                        child: Text(
                      state.msg,
                      style: GoogleFonts.quicksand(),
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.clip,
                    )),
                  ),
                );
              } else {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Material(
                      child: Text(
                        'Search your favourite restaurant here!',
                        style: GoogleFonts.quicksand(),
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.clip,
                      ),
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
