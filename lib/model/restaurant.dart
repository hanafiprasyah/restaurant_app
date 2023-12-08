import 'dart:convert';

class Restaurant {
  final String id;
  final String name;
  final String description;
  final String pictureId;
  final String city;
  final double rating;
  // final List<Menus> menus;
  final Menus menus;
  Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.pictureId,
    required this.city,
    required this.rating,
    required this.menus,
  });

  factory Restaurant.fromJson(Map<String, dynamic> restaurant) {
    return Restaurant(
        id: restaurant['id'],
        name: restaurant['name'],
        description: restaurant['description'],
        pictureId: restaurant['pictureId'],
        city: restaurant['city'],
        rating: restaurant['rating'],
        menus: Menus.fromJson(restaurant['menus']));
    // menus: parseMenus(restaurant['menus']));
  }
}

class Menus {
  List<Food> foods;
  List<Drink> drinks;

  Menus({required this.foods, required this.drinks});

  factory Menus.fromJson(Map<String, dynamic> json) {
    var listFood = json['foods'] as List;
    var listDrink = json['drinks'] as List;

    List<Food> foodList = listFood.map((data) => Food.fromJson(data)).toList();
    List<Drink> drinkList =
        listDrink.map((data) => Drink.fromJson(data)).toList();

    return Menus(
      foods: foodList,
      drinks: drinkList,
    );
  }
}

class Food {
  final String name;

  Food({required this.name});

  factory Food.fromJson(Map<String, dynamic> food) {
    return Food(name: food['name']);
  }
}

class Drink {
  final String name;

  Drink({required this.name});

  factory Drink.fromJson(Map<String, dynamic> drink) {
    return Drink(name: drink['name']);
  }
}

List<Restaurant> parseRestaurant(String? json) {
  if (json == null) return [];
  final List parsed = jsonDecode(json)['restaurants'];
  return parsed.map((json) => Restaurant.fromJson(json)).toList();
}

// List<Menus> parseMenus(String? jsonMenus) {
//   if (jsonMenus == null) return [];
//   final List parsed = jsonDecode(jsonMenus);
//   return parsed.map((json) => Menus.fromJson(json)).toList();
// }

// List<Food> parseFood(String? jsonFood) {
//   if (jsonFood == null) return [];
//   final List parsed = jsonDecode(jsonFood)['menus'];
//   return parsed.map((json) => Food.fromJson(json)).toList();
// }
//
// List<Drink> parseDrink(String? jsonDrink) {
//   if (jsonDrink == null) return [];
//   final List parsed = jsonDecode(jsonDrink)['menus'];
//   return parsed.map((json) => Drink.fromJson(json)).toList();
// }
