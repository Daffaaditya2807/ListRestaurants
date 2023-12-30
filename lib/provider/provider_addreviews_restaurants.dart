import 'package:flutter/foundation.dart';

import '../api/api_add_reviews.dart';

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
