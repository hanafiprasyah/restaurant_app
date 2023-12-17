import 'package:restaurant_app/models/restaurant.dart';

class RestaurantList {
  bool? error;
  String? message;
  int? count;
  List<RestaurantElement> restaurants;

  RestaurantList({
    this.error,
    this.message,
    this.count,
    required this.restaurants,
  });

  factory RestaurantList.fromJson(Map<String, dynamic> json) {
    return RestaurantList(
      error: json["error"],
      message: json["message"],
      count: json["count"],
      restaurants: json["restaurants"] == null
          ? []
          : List<RestaurantElement>.from(
              json["restaurants"].map((x) => RestaurantElement.fromJson(x))),
    );
  }
}
