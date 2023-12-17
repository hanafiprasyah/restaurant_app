import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:restaurant_app/models/restaurant/list.dart';
import 'package:restaurant_app/services/network/api_service.dart';

enum ResultState { loading, noData, hasData, error }

class RestaurantListProvider extends ChangeNotifier {
  final ApiService apiService;

  RestaurantListProvider({required this.apiService}) {
    fetchList();
  }

  late RestaurantList _restaurant;
  late ResultState _state;
  String _msg = "";

  RestaurantList get restaurant => _restaurant;
  ResultState get state => _state;
  String get msg => _msg;

  Future<void> fetchList() async {
    try {
      _state = ResultState.loading;
      notifyListeners();

      final restaurants = await apiService.restaurantList();

      if (restaurants.restaurants.isEmpty) {
        _state = ResultState.noData;
        _msg = 'Restaurant data is empty.';
        notifyListeners();
      } else {
        _state = ResultState.hasData;
        _restaurant = restaurants;
        notifyListeners();
      }
    } catch (err) {
      _state = ResultState.error;
      _msg =
          'Error: App cannot fetch your data because of some problem on data service.';
      notifyListeners();
    }
  }
}
