import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:restaurant_with_api/model/list_restaurants.dart';

class ApiSearchListRestaurants {
  Future<ListRestaurants> fetctDataRestaurant({String? key}) async {
    final response = await http
        .get(Uri.parse("https://restaurant-api.dicoding.dev/search?q=${key}"));
    if (response.statusCode == 200) {
      return ListRestaurants.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load top headlines');
    }
  }
}
