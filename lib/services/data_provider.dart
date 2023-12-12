import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:restaurant_app/models/restaurants/restaurant.dart';
import 'package:restaurant_app/services/api_service.dart';

enum ResultState { loading, noData, hasData, error }

enum SearchState { searching, loading, noData, hasData, error }

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

  Future<dynamic> fetchList() async {
    try {
      _state = ResultState.loading;
      notifyListeners();

      final restaurants = await apiService.restaurantList();

      if (restaurants.restaurants.isEmpty) {
        _state = ResultState.noData;
        notifyListeners();
        return _msg = 'Restaurant data is empty.';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _restaurant = restaurants;
      }
    } catch (err) {
      _state = ResultState.error;
      notifyListeners();
      return _msg =
          'Error: App cannot fetch your data because of some problem on data service.';
    }
  }
}

class RestaurantDetailProvider with ChangeNotifier {
  late RestaurantElement _data;
  bool loading = false;
  ApiService apiService = ApiService();

  RestaurantElement get data => _data;

  getDetailData(String id) async {
    loading = true;
    try {
      final data = await apiService.restaurantDetail(id);

      if (data.id.isNotEmpty) {
        _data = data;
        loading = false;
        notifyListeners();
      } else {
        loading = false;
        notifyListeners();
      }
    } catch (err) {
      loading = false;
      notifyListeners();
    }
  }
}

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
      log(err.toString());
      return _msg =
          'Error: App cannot fetch your data because of some problem on data service.';
    }
  }

  void clearView() {
    _state = SearchState.searching;
    notifyListeners();
  }
}
