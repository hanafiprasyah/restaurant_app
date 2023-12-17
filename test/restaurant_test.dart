import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_app/services/network/api_service.dart';

void main() {
  ApiService apiService = ApiService();

  group('Restaurant API testing: ', () {
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

    test(
      'get restaurant list detail by ID: ',
      () async {
        /// Arrange
        String id = "rqdv5juczeskfw1e867";

        /// Act
        final result = await apiService.restaurantDetail(id);

        /// Assert
        expect(result.id, id);
      },
    );
  });
}
