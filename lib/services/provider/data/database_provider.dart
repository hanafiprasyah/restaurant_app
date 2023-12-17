import 'package:flutter/foundation.dart';
import 'package:restaurant_app/models/restaurant/restaurant.dart';
import 'package:restaurant_app/services/helper/database_helper.dart';

enum ResultState { loading, noData, hasData, error }

class DatabaseProvider extends ChangeNotifier {
  final DatabaseHelper databaseHelper;

  DatabaseProvider({required this.databaseHelper}) {
    getFavouritesInProvider();
  }

  late ResultState _state;
  String _msg = '';

  ResultState get state => _state;
  String get msg => _msg;

  List<RestaurantElement> _favourite = [];
  List<RestaurantElement> get favourite => _favourite;

  void getFavouritesInProvider() async {
    _state = ResultState.loading;
    notifyListeners();

    _favourite = await databaseHelper.getFavouriteList();

    if (_favourite.isNotEmpty) {
      _state = ResultState.hasData;
    } else {
      _state = ResultState.noData;
      _msg = "Empty favourite";
    }
    notifyListeners();
  }

  void addFavouriteInProvider(RestaurantElement restaurantElement) async {
    try {
      await databaseHelper.saveFavourite(restaurantElement);
      getFavouritesInProvider();
    } catch (e) {
      _state = ResultState.error;
      _msg = 'Failed when try to add this restaurant into your favourite list.';
      notifyListeners();
    }
  }

  Future<bool> isFavourite(String name) async {
    final favRestaurant = await databaseHelper.getFavouriteFromName(name);
    return favRestaurant.isNotEmpty;
  }

  void removeFavouriteInProvider(String id) async {
    try {
      await databaseHelper.removeFavourite(id);
      getFavouritesInProvider();
    } catch (e) {
      _state = ResultState.error;
      _msg = "Failed when delete this restaurant from your favourite list.";
      notifyListeners();
    }
  }
}
