import 'package:flutter/material.dart';
import 'package:restaurant_with_api/api/api_list_restaurants.dart';
import 'package:restaurant_with_api/model/list_restaurants.dart';

enum ResulState { loading, noData, hasData, error }

class RestaurantsProvider extends ChangeNotifier {
  final ApiListRestaurants apiListRestaurants;

  RestaurantsProvider({required this.apiListRestaurants}) {
    _fetAllListRestaurants();
  }
  late ListRestaurants _listRestaurants;
  late ResulState _state;
  String _message = '';

  String get message => _message;
  ListRestaurants get result => _listRestaurants;
  ResulState get state => _state;

  Future<dynamic> _fetAllListRestaurants() async {
    try {
      _state = ResulState.loading;
      final restaurants = await apiListRestaurants.fetctDataRestaurant();
      if (restaurants.restaurants.isEmpty) {
        _state = ResulState.noData;
        notifyListeners();
        return _message = 'Empthy Data';
      } else {
        _state = ResulState.hasData;
        notifyListeners();
        return _listRestaurants = restaurants;
      }
    } catch (e) {
      _state = ResulState.error;
      notifyListeners();
      return _message = 'Error --> $e';
    }
  }
}
