import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_with_api/api/api_list_restaurants.dart';
import 'package:restaurant_with_api/model/list_restaurants.dart';
import 'package:restaurant_with_api/api/api_detail_restaurants.dart';
import 'package:restaurant_with_api/model/detail_restaurants.dart';

import '../api/api_add_reviews.dart';
import '../api/api_search_list_restaurants.dart';

enum ResulState { loading, noData, hasData, error, first }

class RestaurantsProvider extends ChangeNotifier {
  final ApiListRestaurants apiListRestaurants;
  StreamSubscription? _connectivitySubscription;

  RestaurantsProvider({required this.apiListRestaurants}) {
    _fetAllListRestaurants();
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
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

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    if (result != ConnectivityResult.none) {
      await _fetAllListRestaurants();
    }
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
      _message = 'No Internet Connection. Please check your network settings.';
    } catch (e) {
      _state = ResulState.error;
      notifyListeners();
      return _message = 'Error --> $e';
    }
  }
}

class DetailRestaurantProvider extends ChangeNotifier {
  final ApiDetailRestaurants apiDetailRestaurants;
  String? _lastRequestedId;
  StreamSubscription? _connectivitySubscription;

  DetailRestaurantProvider({required this.apiDetailRestaurants}) {
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  late DetailRestaurants _detailRestaurants;
  ResulState? _state;
  String _message = '';

  String get message => _message;
  DetailRestaurants get detail => _detailRestaurants;
  ResulState? get state => _state;

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    if (result != ConnectivityResult.none && _lastRequestedId != null) {
      await fetchDetailRestaurant(_lastRequestedId!);
    }
  }

  Future<void> fetchDetailRestaurant(String idRestaurant) async {
    _lastRequestedId = idRestaurant;
    try {
      _state = ResulState.loading;
      notifyListeners();
      final detail = await apiDetailRestaurants.fetchRestaurant(
          idRestaurants: idRestaurant);

      if (detail == null) {
        _state = ResulState.noData;
        notifyListeners();
        _message = 'No Data';
      } else {
        _state = ResulState.hasData;
        notifyListeners();
        _detailRestaurants = detail;
      }
    } on SocketException {
      _state = ResulState.error;
      notifyListeners();
      _message = '404';
    } catch (e) {
      _state = ResulState.error;

      notifyListeners();
      _message = 'Error --> $e.';
    } finally {
      notifyListeners();
    }
  }
}

class CariRestaurantsProvider extends ChangeNotifier {
  final ApiSearchListRestaurants apiSearchListRestaurants;
  String? _lastRequestedId;
  StreamSubscription? _connectivitySubscription;

  CariRestaurantsProvider({required this.apiSearchListRestaurants}) {
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  ListRestaurants? _searchResults;
  ResulState _state = ResulState.first;
  String _message = '';

  ListRestaurants? get searchResults => _searchResults;
  ResulState get state => _state;
  String get message => _message;

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    if (result != ConnectivityResult.none && _lastRequestedId != null) {
      await searchRestaurants(_lastRequestedId!);
    }
  }

  Future<void> searchRestaurants(String query) async {
    _lastRequestedId = query;
    try {
      _state = ResulState.loading;
      notifyListeners();
      final results =
          await apiSearchListRestaurants.fetctDataRestaurant(key: query);

      if (results.restaurants.isEmpty) {
        _state = ResulState.noData;
        _message = 'No results found.';
      } else {
        _state = ResulState.hasData;
        _searchResults = results;
      }
    } on SocketException {
      _state = ResulState.error;
      notifyListeners();
      _message = '404';
    } catch (e) {
      _state = ResulState.error;
      _message = 'Error --> $e';
    }
    notifyListeners();
  }
}

class ReviewsAddProviders extends ChangeNotifier {
  bool _isLoading = false;
  String _message = '';
  bool _hasError = false;

  bool get isLoading => _isLoading;
  String get message => _message;
  bool get hasError => _hasError;

  Future<void> addReview(String id, String name, String review) async {
    _isLoading = true;
    _hasError = false;
    notifyListeners();

    try {
      final response = await ApiAddReviews.InsertReviews(
          id: id, name: name, reviews: review);
      _message = response.message.toString();
      _isLoading = false;
      if (response.error != 'false') {
        _hasError = true;
      }
    } catch (e) {
      _isLoading = false;
      _hasError = true;
      _message = e.toString();
    }

    notifyListeners();
  }
}
