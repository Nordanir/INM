import 'package:flutter/material.dart';

class Entity with ChangeNotifier {
  double? _rating;
  String _id;
  String _title;

  String get title => _title;
  set title(String title) {
    _title = title;
    notifyListeners();
  }

  String get id => _id;
  set id(String id) {
    _id = id;
    notifyListeners();
  }

  Entity({required String id, required String title})
    : _id = id,
      _title = title;
  set rating(double? rating) {
    _rating = rating;
    notifyListeners();
  }

  double? get rating => _rating;
}
