import 'package:http/http.dart' as http;
import 'dart:convert';

import '../model/detail_restaurants.dart';

class ApiDetailRestaurants {
  Future<DetailRestaurants> fetchRestaurant({String? idRestaurants}) async {
    final response = await http.get(Uri.parse(
        'https://restaurant-api.dicoding.dev/detail/${idRestaurants}'));

    if (response.statusCode == 200) {
      return DetailRestaurants.fromJson(
          json.decode(response.body)['restaurant']);
    } else {
      throw Exception('Failed to load restaurant');
    }
  }
}
