import 'package:flutter/material.dart';

class Entity with ChangeNotifier {
  double? rating;

  void updateRating(double rating) {
    rating = rating;
    notifyListeners();
  }
}
