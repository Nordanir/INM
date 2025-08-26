import 'package:flutter/material.dart';

class Entity with ChangeNotifier {
  double? _rating;
  String _id;

  String get id => _id;
  set id(String id) {
    _id = id;
    notifyListeners();
  }

  Entity({required String id}) : _id = id;
  set rating(double? rating) {
    _rating = rating;
    notifyListeners();
  }

  double? get rating => _rating;
}
