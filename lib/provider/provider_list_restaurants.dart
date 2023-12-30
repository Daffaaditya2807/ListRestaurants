import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_with_api/api/api_list_restaurants.dart';
import 'package:restaurant_with_api/database/databasehelper.dart';
import 'package:restaurant_with_api/database/db_model_restaurants.dart';
import 'package:restaurant_with_api/model/list_restaurants.dart';

enum ResulState { loading, noData, hasData, error, first }

class RestaurantsProvider extends ChangeNotifier {
  final ApiListRestaurants apiListRestaurants;
  StreamSubscription? _connectivitySubscription;

  List<DbRestaurants> _dblistrestaurants = [];
  Map<String, bool> _favorites = {};
  late DatabaseHelper _databaseHelper;

  RestaurantsProvider({required this.apiListRestaurants}) {
    _fetAllListRestaurants();
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
    _databaseHelper = DatabaseHelper();
    getAllRestaurantsdb();
    loadFavorite();
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  late ListRestaurants _listRestaurants;
  late ResulState _state;
  String _message = '';

  String get message => _message;
  ListRestaurants get result => _listRestaurants;
  ResulState get state => _state;
  List<DbRestaurants> get dbrest => _dblistrestaurants;

  void getAllRestaurantsdb() async {
    _dblistrestaurants = await _databaseHelper.getRestaurants();
    notifyListeners();
  }

  void loadFavorite() async {
    // Muat status favorit dari database
    List<DbRestaurants> favRestaurants =
        await _databaseHelper.getRestaurantsFavorite();
    _favorites.clear();
    for (var rest in favRestaurants) {
      _favorites[rest.id] = true;
    }
    notifyListeners();
  }

  Future<void> addRestaurantsDb(DbRestaurants restaurants) async {
    await _databaseHelper.insertRestaurants(restaurants);
    getAllRestaurantsdb();
    loadFavorite();
    _favorites[restaurants.id] = true;
    notifyListeners();
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    if (result != ConnectivityResult.none) {
      await _fetAllListRestaurants();
    }
  }

  Map<String, bool> get favorites => _favorites;

  void updateFavoriteStatus(String id, bool isFavorite) {
    _favorites[id] = isFavorite;
    notifyListeners();
  }

  Future<bool> isFavorite(String id) async {
    return await _databaseHelper.isFavorite(id);
  }

  Future<void> deleteRestaurantsDb(String id) async {
    await _databaseHelper.deleteRestaurants(id);
    getAllRestaurantsdb();
  }

  Future<dynamic> _fetAllListRestaurants() async {
    try {
      _state = ResulState.loading;
      notifyListeners();
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
    } on SocketException {
      _state = ResulState.error;
      notifyListeners();
      _message = '404';
    } catch (e) {
      _state = ResulState.error;
      notifyListeners();
      return _message = 'Error --> $e';
    }
  }
}
