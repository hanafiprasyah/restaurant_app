import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:restaurant_app/models/restaurant/list.dart';
import 'package:restaurant_app/services/network/api_service.dart';

enum SearchState { searching, loading, noData, hasData, error }

class RestaurantSearchProvider with ChangeNotifier {
  final ApiService apiService;

  RestaurantSearchProvider({required this.apiService}) {
    setSearchView();
  }

  SearchState? _state;
  RestaurantList? _restaurant;
  String _msg = "";

  RestaurantList get restaurant => _restaurant!;
  SearchState get state => _state!;
  String get msg => _msg;

  void setSearchView() {
    _state = SearchState.searching;
    notifyListeners();
  }

  Future<dynamic> searchList(String name) async {
    try {
      _state = SearchState.loading;
      notifyListeners();

      final restaurants = await apiService.restaurantSearch(name);

      if (restaurants.restaurants.isEmpty) {
        _state = SearchState.noData;
        notifyListeners();
        return _msg =
            'Sorry. Unknown restaurant or never registered in our app.';
      } else {
        _state = SearchState.hasData;
        notifyListeners();
        return _restaurant = restaurants;
      }
    } catch (err) {
      _state = SearchState.error;
      notifyListeners();
      return _msg =
          'Error: App cannot fetch your data because of some problem on data service.';
    }
  }

  void clearView() {
    _state = SearchState.searching;
    notifyListeners();
  }
}
