import 'package:flutter/material.dart';

class Entity with ChangeNotifier {
  double? _rating;
  String _id;
  String _title;
  Image? _cover;
  String? _coverUrl;

  String? get coverUrl => _coverUrl;
  set coverUrl(String? url) {
    _coverUrl = url;
    notifyListeners();
  }

  Image? get cover => _cover;
  set cover(Image? cover) {
    _cover = cover;
    notifyListeners();
  }

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

  Entity({required String id, required String title, String? coverUrl, Image? cover, double? rating = 0.0})
    : _id = id,
      _title = title,
      _coverUrl = coverUrl,
      _cover = cover,
      _rating = rating;
  set rating(double? rating) {
    _rating = rating;
    notifyListeners();
  }

  double? get rating => _rating;

  
}
