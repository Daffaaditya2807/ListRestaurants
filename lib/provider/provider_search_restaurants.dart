import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

import '../api/api_search_list_restaurants.dart';
import '../database/databasehelper.dart';
import '../database/db_model_restaurants.dart';
import '../model/list_restaurants.dart';

enum ResultsCari { loading, noData, hasData, error, first }

class CariRestaurantsProvider extends ChangeNotifier {
  final ApiSearchListRestaurants apiSearchListRestaurants;
  String? _lastRequestedId;
  StreamSubscription? _connectivitySubscription;

  late DatabaseHelper _databaseHelper;
  List<DbRestaurants> _dblistrestaurants = [];
  Map<String, bool> _favorites = {};

  CariRestaurantsProvider({required this.apiSearchListRestaurants}) {
    _databaseHelper = DatabaseHelper();
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
    getAllRestaurantsdb();
    loadFavorites();
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  ListRestaurants? _searchResults;
  ResultsCari _state = ResultsCari.first;
  String _message = '';

  ListRestaurants? get searchResults => _searchResults;
  ResultsCari get state => _state;
  String get message => _message;
  Map<String, bool> get favorites => _favorites;
  List<DbRestaurants> get dbrest => _dblistrestaurants;

  void getAllRestaurantsdb() async {
    _dblistrestaurants = await _databaseHelper.getRestaurants();
    notifyListeners();
  }

  Future<void> addRestaurantsDb(DbRestaurants restaurants) async {
    await _databaseHelper.insertRestaurants(restaurants);
    getAllRestaurantsdb();
    loadFavorites();
    notifyListeners();
  }

  Future<void> deleteRestaurantsDb(String id) async {
    await _databaseHelper.deleteRestaurants(id);
    getAllRestaurantsdb();
  }

  void updateFavoriteStatus(String id, bool isFavorite) {
    _favorites[id] = isFavorite;
    notifyListeners();
  }

  void loadFavorites() async {
    // Muat status favorit dari database
    List<DbRestaurants> favRestaurants =
        await _databaseHelper.getRestaurantsFavorite();
    _favorites.clear();
    for (var rest in favRestaurants) {
      _favorites[rest.id] = true;
    }
    notifyListeners();
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    if (result != ConnectivityResult.none && _lastRequestedId != null) {
      await searchRestaurants(_lastRequestedId!);
    }
  }

  Future<void> searchRestaurants(String query) async {
    _lastRequestedId = query;
    try {
      _state = ResultsCari.loading;
      notifyListeners();
      final results =
          await apiSearchListRestaurants.fetctDataRestaurant(key: query);
      getAllRestaurantsdb();
      loadFavorites();
      notifyListeners();
      if (results.restaurants.isEmpty) {
        _state = ResultsCari.noData;
        _message = 'No results found.';
      } else {
        _state = ResultsCari.hasData;
        _searchResults = results;
      }
    } on SocketException {
      _state = ResultsCari.error;
      notifyListeners();
      _message = '404';
    } catch (e) {
      _state = ResultsCari.error;
      _message = 'Error --> $e';
    }
    notifyListeners();
  }
}
