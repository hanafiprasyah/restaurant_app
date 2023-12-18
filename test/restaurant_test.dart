import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:restaurant_app/models/restaurant/list.dart';
import 'package:restaurant_app/services/network/api_service.dart';

import 'restaurant_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  final ApiService apiService = ApiService();
  group('Restaurant API testing: ', () {
    test('fetch restaurants list if successfully', () async {
      final client = MockClient();
      when(client.get(Uri.parse("https://restaurant-api.dicoding.dev/list")))
          .thenAnswer((_) async => http.Response(
              '{"error": false, "message": "success", "count": 20}', 200));
      expect(await apiService.restaurantList(client), isA<RestaurantList>());
    });

    test('throw an exception when restaurants list is failed to fetch', () {
      final client = MockClient();
      when(client.get(Uri.parse("https://restaurant-api.dicoding.dev/list")))
          .thenAnswer((_) async =>
              http.Response('{"error": true, "message": "Not Found"}', 404));
      expect(apiService.restaurantList(client), throwsException);
    });
  });
}
