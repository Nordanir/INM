import 'package:flutter/material.dart';

class SearchProvider extends ChangeNotifier {
  bool _toggleSearchBarVisibility = false;

  final _searchBarFocusNode = FocusNode();
  FocusNode get searchFocusNode => _searchBarFocusNode;

  SearchProvider() {
    _searchBarFocusNode.addListener(() {
      if (!_searchBarFocusNode.hasFocus) {
        _toggleSearchBarVisibility = false;
        notifyListeners();
      }
    });
  }

  bool get toggleSearchBarVisibility => _toggleSearchBarVisibility;

  void toggleSearchBar() {
    _toggleSearchBarVisibility = !_toggleSearchBarVisibility;
    if (_toggleSearchBarVisibility) {
      _searchBarFocusNode.requestFocus();
    } else {
      _searchBarFocusNode.unfocus();
    }
    notifyListeners();
  }
  @override
  void dispose() {
    _searchBarFocusNode.dispose();
    super.dispose();
  }
}
