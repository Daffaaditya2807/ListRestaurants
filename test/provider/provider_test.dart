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
      final apiListRestaurants = ApiListRestaurants(client: client);
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
      final apiDetailRestaurants = ApiDetailRestaurants(client: client);
      final response = {
        "error": false,
        "message": "success",
        "restaurant": {
          "id": "rqdv5juczeskfw1e867",
          "name": "Melting Pot",
          "description":
              "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac, enim. Aliquam lorem ante, dapibus in, viverra quis, feugiat a, tellus. Phasellus viverra nulla ut metus varius laoreet.",
          "city": "Medan",
          "address": "Jln. Pandeglang no 19",
          "pictureId": "14",
          "categories": [
            {"name": "Italia"},
            {"name": "Modern"}
          ],
          "menus": {
            "foods": [
              {"name": "Paket rosemary"},
              {"name": "Toastie salmon"},
              {"name": "Bebek crepes"},
              {"name": "Salad lengkeng"}
            ],
            "drinks": [
              {"name": "Es krim"},
              {"name": "Sirup"},
              {"name": "Jus apel"},
              {"name": "Jus jeruk"},
              {"name": "Coklat panas"},
              {"name": "Air"},
              {"name": "Es kopi"},
              {"name": "Jus alpukat"},
              {"name": "Jus mangga"},
              {"name": "Teh manis"},
              {"name": "Kopi espresso"},
              {"name": "Minuman soda"},
              {"name": "Jus tomat"}
            ]
          },
          "rating": 4.2,
          "customerReviews": [
            {
              "name": "Ahmad",
              "review": "Tidak rekomendasi untuk pelajar!",
              "date": "13 November 2019"
            },
            {
              "name": "yanto",
              "review": "testing add review",
              "date": "1 Januari 2024"
            },
            {
              "name": "Luffy",
              "review": "Daginganya enakk",
              "date": "1 Januari 2024"
            },
            {
              "name": "halo",
              "review": "2023 sudah berlalu",
              "date": "1 Januari 2024"
            },
            {
              "name": "budi",
              "review": "genangan air sangat menghanyutkan",
              "date": "1 Januari 2024"
            },
            {
              "name": "Gun gun",
              "review": "Pagi yang cerah",
              "date": "1 Januari 2024"
            }
          ]
        }
      };
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
