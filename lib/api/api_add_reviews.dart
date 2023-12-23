import 'package:restaurant_with_api/model/add_reviews.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiAddReviews {
  static Future<Addreviews> InsertReviews(
      {String? id, String? name, String? reviews}) async {
    Uri url = Uri.parse("https://restaurant-api.dicoding.dev/review");
    var HasilResponse = await http.post(
      url,
      body: {"id": id, "name": name, "review": reviews},
    );

    var dataa = json.decode(HasilResponse.body);
    return Addreviews(
        error: dataa['error'].toString(), message: dataa['message']);
  }
}
