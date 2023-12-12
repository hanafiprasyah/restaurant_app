import 'dart:developer';

import 'package:auto_animated/auto_animated.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/components/card.dart';
import 'package:restaurant_app/services/data_provider.dart';
import 'package:restaurant_app/services/screen_provider.dart';

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
                    onSubmitted: (name) {
                      if (name.isNotEmpty) {
                        /// TODO: using provider searchList() function to looking for the restaurant name
                        // state.searchList(name);
                        log('You are search: $name');
                      } else {
                        /// TODO: clear the search list view
                        // return state.clearView();
                        log('Your search list view was cleared');
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
                      // return state.clearView();
                      log('Your search list view was cleared');
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                    tooltip: 'Clear search',
                    icon: const Icon(Icons.delete_forever_rounded),
                    color: Colors.red,
                    iconSize: 24,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: IconButton(
                    onPressed: () {
                      context.read<SelectViewHomeProvider>().selectView();
                    },
                    icon: context.watch<SelectViewHomeProvider>().isGrid
                        ? const Icon(Icons.grid_view_rounded)
                        : const Icon(Icons.list_rounded),
                  ),
                )
              ],
            ),
          ),
        ),
        Expanded(
          flex: 8,
          child: Consumer<RestaurantListProvider>(
            builder: (context, state, _) {
              if (state.state == ResultState.loading) {
                return Center(
                  child: LoadingAnimationWidget.fourRotatingDots(
                      color: Colors.indigo, size: 15),
                );
              } else if (state.state == ResultState.hasData) {
                return context.watch<SelectViewHomeProvider>().isGrid
                    ? LiveGrid.options(
                        options: options,
                        padding: const EdgeInsets.all(16),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: MediaQuery.of(context).size.width /
                              (MediaQuery.of(context).size.height / 1.2),
                        ),
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
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                /**
                           * CustomCard : lib/components/card.dart
                           */
                                child: VerticalListCard(
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
                      )
                    : LiveList.options(
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
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
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
              } else if (state.state == ResultState.noData) {
                return Center(
                  child: Material(child: Text(state.msg)),
                );
              } else if (state.state == ResultState.error) {
                return Center(
                  child: Material(
                      child:
                          Text('Error. ${state.msg} Please reload your app.')),
                );
              } else {
                return const Center(
                  child: Material(child: Text('')),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
