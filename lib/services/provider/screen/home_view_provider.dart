import 'package:flutter/material.dart';

class SelectViewHomeProvider with ChangeNotifier {
  /// Set listview as default UI of Home Page by false this value
  bool _isGrid = false;
  String _title = 'List View';

  bool get isGrid => _isGrid;

  String get title => _title;

  void selectView() {
    _isGrid = !_isGrid;
    if (_isGrid == true) {
      _title = 'Grid View';
    } else {
      _title = 'List View';
    }
    notifyListeners();
  }
}
