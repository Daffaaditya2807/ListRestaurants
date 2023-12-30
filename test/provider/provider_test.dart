import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:restaurant_with_api/api/api_detail_restaurants.dart';
import 'package:restaurant_with_api/api/api_list_restaurants.dart';
import 'package:restaurant_with_api/model/detail_restaurants.dart';
import 'package:restaurant_with_api/model/list_restaurants.dart';
import 'mocks.mocks.dart';

void main() {
  group('fetchDataRestaurant', () {
    test('returns ListRestaurants if the http call completes successfully',
        () async {
      final client = MockClient();
      final apiListRestaurants = ApiListRestaurants();
      final response = {};

      // Setup the mock
      when(client.get(Uri.parse("https://restaurant-api.dicoding.dev/list")))
          .thenAnswer((_) async => http.Response(jsonEncode(response), 200));

      expect(await apiListRestaurants.fetctDataRestaurant(),
          isA<ListRestaurants>());
    });

    test('throws an exception if the http call completes with an error',
        () async {
      final client = MockClient();
      final apiListRestaurants = ApiListRestaurants(client: client);
      final response = {};

      when(client.get(Uri.parse("https://restaurant-api.dicoding.dev/list")))
          .thenAnswer((_) async => http.Response(jsonEncode(response), 404));

      expect(apiListRestaurants.fetctDataRestaurant(), throwsException);
    });

    test("get id when get restaurants Details", () async {
      final client = MockClient();
      final apiDetailRestaurants = ApiDetailRestaurants();
      final response = {};
      String idRestaurants = 'rqdv5juczeskfw1e867';

      when(client.get(Uri.parse(
              'https://restaurant-api.dicoding.dev/detail/${idRestaurants}')))
          .thenAnswer((_) async => http.Response(jsonEncode(response), 200));

      expect(
          await apiDetailRestaurants.fetchRestaurant(
              idRestaurants: idRestaurants),
          isA<DetailRestaurants>());
    });

    test("Show Error when failed to get Data", () async {
      final client = MockClient();
      final apiDetailListRestaurants = ApiDetailRestaurants(client: client);
      final response = {};
      String idRestaurants = 'rqdv5juczeskfw1e867';

      when(client.get(Uri.parse(
              "https://restaurant-api.dicoding.dev/detail/${idRestaurants}")))
          .thenAnswer((_) async => http.Response(jsonEncode(response), 404));

      expect(
          apiDetailListRestaurants.fetchRestaurant(
              idRestaurants: idRestaurants),
          throwsException);
    });
  });
}
