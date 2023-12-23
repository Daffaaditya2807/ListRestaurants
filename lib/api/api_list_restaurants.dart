import 'package:http/http.dart' as http;
import 'dart:convert';

import '../model/list_restaurants.dart';

class ApiListRestaurants {
  Future<ListRestaurants> fetctDataRestaurant() async {
    final response =
        await http.get(Uri.parse("https://restaurant-api.dicoding.dev/list"));
    if (response.statusCode == 200) {
      return ListRestaurants.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load top headlines');
    }
  }
}
