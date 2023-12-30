import 'package:http/http.dart' as http;
import 'dart:convert';

import '../model/list_restaurants.dart';

class ApiListRestaurants {
  http.Client? client;
  ApiListRestaurants({this.client}) {
    if (client == null) {
      client = http.Client();
    }
  }

  Future<ListRestaurants> fetctDataRestaurant() async {
    final response = await client!
        .get(Uri.parse("https://restaurant-api.dicoding.dev/list"));
    if (response.statusCode == 200) {
      return ListRestaurants.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load top headlines');
    }
  }
}
