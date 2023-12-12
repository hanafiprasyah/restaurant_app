import 'package:auto_animated/auto_animated.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/components/card.dart';
import 'package:restaurant_app/services/data_provider.dart';
import 'package:restaurant_app/services/screen_provider.dart';

class RestaurantListPage extends StatefulWidget {
  const RestaurantListPage({super.key});

  @override
  State<RestaurantListPage> createState() => _RestaurantListPageState();
}

class _RestaurantListPageState extends State<RestaurantListPage> {
  final options = const LiveOptions(
    delay: Duration.zero,
    showItemInterval: Duration(milliseconds: 250),
    showItemDuration: Duration(milliseconds: 500),
    visibleFraction: 0.025,
    reAnimateOnVisibility: false,
  );

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      context.read<SelectViewHomeProvider>().selectView();
                    },
                    icon: context.watch<SelectViewHomeProvider>().isGrid
                        ? const Icon(Icons.grid_view_rounded)
                        : const Icon(Icons.list_rounded),
                  ),
                  Text(
                    context.watch<SelectViewHomeProvider>().title,
                    style: GoogleFonts.quicksand(fontSize: 14),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            flex: 9,
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
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            childAspectRatio:
                                MediaQuery.of(context).size.width /
                                    (MediaQuery.of(context).size.height / 1.2),
                          ),
                          shrinkWrap: false,
                          itemCount: state.restaurant.restaurants.length,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index, animation) {
                            var restaurant =
                                state.restaurant.restaurants[index];
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
                            var restaurant =
                                state.restaurant.restaurants[index];
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
                        child: Text(
                            'Error. ${state.msg} Please reload your app.')),
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
      ),
    );
  }
}
