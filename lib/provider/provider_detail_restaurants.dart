import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:restaurant_with_api/api/api_detail_restaurants.dart';

import '../database/databasehelper.dart';
import '../database/db_model_restaurants.dart';
import '../model/detail_restaurants.dart';

enum ResultDetail { loading, noData, hasData, error, first }

class DetailRestaurantProvider extends ChangeNotifier {
  final ApiDetailRestaurants apiDetailRestaurants;
  String? _lastRequestedId;
  StreamSubscription? _connectivitySubscription;

  //database
  late DatabaseHelper _databaseHelper;
  List<DbRestaurants> _dblistrestaurants = [];
  Map<String, bool> _favorites = {};

  DetailRestaurantProvider({required this.apiDetailRestaurants}) {
    _databaseHelper = DatabaseHelper();
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
    _getAllRestaurantsdb();
    _loadFavorites();
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  late DetailRestaurants _detailRestaurants;
  ResultDetail? _state;
  String _message = '';

  String get message => _message;
  DetailRestaurants get detail => _detailRestaurants;
  ResultDetail? get state => _state;
  Map<String, bool> get favorites => _favorites;
  List<DbRestaurants> get dbrest => _dblistrestaurants;

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    if (result != ConnectivityResult.none && _lastRequestedId != null) {
      await fetchDetailRestaurant(_lastRequestedId!);
    }
  }

  void _loadFavorites() async {
    // Muat status favorit dari database
    List<DbRestaurants> favRestaurants =
        await _databaseHelper.getRestaurantsFavorite();
    _favorites.clear();
    for (var rest in favRestaurants) {
      _favorites[rest.id] = true;
    }
    notifyListeners();
  }

  bool isFavoriteById(String id) {
    return _favorites[id] ?? false;
  }

  Future<void> addFavorite(DbRestaurants restaurant) async {
    await _databaseHelper.insertRestaurants(restaurant);
    _getAllRestaurantsdb();
    _loadFavorites();
    _favorites[restaurant.id] = true;
    notifyListeners();
  }

  void updateFavoriteStatus(String id, bool isFavorite) {
    _favorites[id] = isFavorite;
    isFavoriteById(id);
    notifyListeners();
  }

  void _getAllRestaurantsdb() async {
    _dblistrestaurants = await _databaseHelper.getRestaurants();
    notifyListeners();
  }

  Future<void> removeFavorite(String id) async {
    await _databaseHelper.deleteRestaurants(id);
    _favorites.remove(id);
    notifyListeners();
  }

  Future<void> fetchDetailRestaurant(String idRestaurant) async {
    _lastRequestedId = idRestaurant;
    try {
      _state = ResultDetail.loading;
      notifyListeners();

      final detail = await apiDetailRestaurants.fetchRestaurant(
          idRestaurants: idRestaurant);
      _getAllRestaurantsdb();
      _loadFavorites();

      if (detail == null) {
        _state = ResultDetail.noData;
        notifyListeners();
        _message = 'No Data';
      } else {
        _state = ResultDetail.hasData;
        notifyListeners();
        _detailRestaurants = detail;
      }
    } on SocketException {
      _state = ResultDetail.error;
      notifyListeners();
      _message = '404';
    } catch (e) {
      _state = ResultDetail.error;

      notifyListeners();
      _message = 'Error --> $e.';
    } finally {
      notifyListeners();
    }
  }
}
