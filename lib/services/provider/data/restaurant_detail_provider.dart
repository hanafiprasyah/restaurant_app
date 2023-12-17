import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:restaurant_app/models/restaurant/restaurant.dart';
import 'package:restaurant_app/services/network/api_service.dart';

class RestaurantDetailProvider with ChangeNotifier {
  late RestaurantElement _data;
  bool loading = false;
  ApiService apiService = ApiService();

  RestaurantElement get data => _data;

  Future<RestaurantElement?> getDetailData(String id) async {
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
    return null;
  }
}
