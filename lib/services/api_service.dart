import "dart:convert";

import "package:http/http.dart" as http;
import 'package:restaurant_app/models/restaurants/restaurant.dart';

class ApiService {
  static const String _baseURL = 'https://restaurant-api.dicoding.dev';

  Future<RestaurantList> restaurantList() async {
    final response = await http.get(Uri.parse("$_baseURL/list"));
    if (response.statusCode == 200) {
      return RestaurantList.fromJson(json.decode(response.body));
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw Exception('Bad syntax: Error caught by client side.');
    } else if (response.statusCode >= 500) {
      throw Exception(
          'Failed to connect to server: Error caught by server side.');
    } else {
      throw Exception(
          'Failed to load this restaurant detail. Please check your Internet connection.');
    }
  }

  Future<RestaurantElement> restaurantDetail(String id) async {
    final response = await http.get(Uri.parse("$_baseURL/detail/$id"));
    if (response.statusCode == 200) {
      return RestaurantElement.fromJson(
          json.decode(response.body)['restaurant']);
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw Exception('Bad syntax: Error caught by client side.');
    } else if (response.statusCode >= 500) {
      throw Exception(
          'Failed to connect to server: Error caught by server side.');
    } else {
      throw Exception(
          'Failed to load this restaurant detail. Please check your Internet connection.');
    }
  }

  Future<RestaurantList> restaurantSearch(String name) async {
    final response = await http.get(
        Uri(host: _baseURL, scheme: 'https', path: 'search', query: 'q=$name'));
    if (response.statusCode == 200) {
      return RestaurantList.fromJson(json.decode(response.body));
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw Exception('Bad syntax: Error caught by client side.');
    } else if (response.statusCode >= 500) {
      throw Exception(
          'Failed to connect to server: Error caught by server side.');
    } else {
      throw Exception(
          'Failed to load this restaurant detail. Please check your Internet connection.');
    }
  }
}