import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_app/services/network/api_service.dart';

void main() {
  ApiService apiService = ApiService();

  test(
    'search restaurant by name: ',
    () async {
      /// Arrange
      String name = "Melting Pot";

      /// Act
      final result = await apiService.restaurantSearch(name);

      /// Assert
      expect(result.restaurants[0].name, name);
    },
  );
}
