import 'package:restaurant_app/models/restaurant/category.dart';
import 'package:restaurant_app/models/restaurant/menu.dart';
import 'package:restaurant_app/models/restaurant/review.dart';

class RestaurantElement {
  String id;
  String name;
  String description;
  String pictureId;
  String city;
  double rating;
  String? address;
  List<Category>? categories;
  Menu? menus;
  List<CustomerReview>? customerReviews;

  RestaurantElement({
    required this.id,
    required this.name,
    required this.description,
    required this.pictureId,
    required this.city,
    required this.rating,
    this.address,
    this.categories,
    this.menus,
    this.customerReviews,
  });

  factory RestaurantElement.fromJson(Map<String, dynamic> json) =>
      RestaurantElement(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        pictureId: json["pictureId"],
        city: json["city"],
        rating: json["rating"]?.toDouble(),
        address: json["address"] ?? '',
        categories: json['categories'] != null
            ? List<Category>.from(
                json["categories"].map((x) => Category.fromJson(x)))
            : [],
        menus: json['menus'] != null ? Menu.fromJson(json["menus"]) : null,
        customerReviews: json["customerReviews"] != null
            ? List<CustomerReview>.from(
                json["customerReviews"].map((x) => CustomerReview.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "pictureId": pictureId,
        "city": city,
        "rating": rating,
      };
}
