import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/components/cards/listview_card.dart';
import 'package:restaurant_app/models/restaurant/restaurant.dart';
import 'package:restaurant_app/services/provider/data/database_provider.dart';
import 'package:searchable_listview/resources/arrays.dart';
import 'package:searchable_listview/searchable_listview.dart';

class FavouriteRestaurantPage extends StatelessWidget {
  const FavouriteRestaurantPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: const EdgeInsets.only(left: 16, top: 36),
            child: Row(
              children: [
                Text(
                  'Favourites',
                  style: GoogleFonts.quicksand(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            )),
        Expanded(
          child: Consumer<DatabaseProvider>(
            builder: (context, value, child) {
              if (value.state == ResultState.loading) {
                return Center(
                  child: LoadingAnimationWidget.fourRotatingDots(
                      color: Colors.indigo, size: 15),
                );
              } else if (value.state == ResultState.hasData) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SearchableList<RestaurantElement>(
                    initialList: value.favourite,
                    style: GoogleFonts.quicksand(),
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    autoFocusOnSearch: false,
                    displayClearIcon: true,
                    searchMode: SearchMode.onEdit,
                    filter: (data) => value.favourite
                        .where((element) =>
                            element.name.toLowerCase().contains(data))
                        .toList(),
                    builder: (_, index, __) {
                      return Dismissible(
                        key: Key(value.favourite[index].id),
                        background: Container(
                          color: Colors.red,
                        ),
                        confirmDismiss: (direction) async {
                          return await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              key: Key(value.favourite[index].id),
                              elevation: 4,
                              buttonPadding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              title: Text(
                                'Confirm to delete',
                                style: GoogleFonts.quicksand(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w700),
                              ),
                              content: Text(
                                'Are you sure to delete ${value.favourite[index].name} from your favourite list?',
                                style: GoogleFonts.quicksand(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w400),
                              ),
                              icon: const Icon(Icons.delete_outline_rounded,
                                  color: Colors.redAccent),
                              actions: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red[600]!,
                                    side: const BorderSide(
                                        style: BorderStyle.none),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 0,
                                    textStyle: GoogleFonts.quicksand(),
                                  ),
                                  onPressed: () => Navigator.pop(context, true),
                                  child: Text(
                                    'Delete',
                                    style: GoogleFonts.quicksand(
                                        color: Colors.white),
                                  ),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey[600]!,
                                    side: const BorderSide(
                                        style: BorderStyle.none),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 0,
                                    textStyle: GoogleFonts.quicksand(),
                                  ),
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: Text(
                                    'Cancel',
                                    style: GoogleFonts.quicksand(
                                        color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        onDismissed: (direction) {
                          value.removeFavouriteInProvider(
                              value.favourite[index].id);
                        },
                        child: ListViewCard(
                          id: value.favourite[index].id,
                          imageId: value.favourite[index].pictureId,
                          name: value.favourite[index].name,
                          city: value.favourite[index].city,
                          rating: value.favourite[index].rating,
                          restaurantElement: value.favourite[index],
                        ),
                      );
                    },
                    loadingWidget: Center(
                      child: LoadingAnimationWidget.fourRotatingDots(
                          color: Colors.indigo, size: 15),
                    ),
                    errorWidget: const Center(
                      child: Text('Error when get your favourite restaurant.'),
                    ),
                    emptyWidget: const Center(
                      child: Text('Restaurant not found!'),
                    ),
                    inputDecoration: InputDecoration(
                      labelText: "Search your favourite",
                      labelStyle: GoogleFonts.quicksand(),
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.blue,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                );
              } else if (value.state == ResultState.noData) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Material(
                        child: Text(
                      value.msg,
                      style: GoogleFonts.quicksand(),
                      maxLines: 2,
                      overflow: TextOverflow.clip,
                    )),
                  ),
                );
              } else if (value.state == ResultState.error) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Material(
                        child: Text(
                      'Error: ${value.msg}',
                      style: GoogleFonts.quicksand(),
                      maxLines: 2,
                      overflow: TextOverflow.clip,
                    )),
                  ),
                );
              } else {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Material(child: Text('')),
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
