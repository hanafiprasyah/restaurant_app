import 'package:flutter/material.dart';

class SelectedHomePageProvider with ChangeNotifier {
  int _index = 0;
  int get index => _index;
  void onTabChangeSelectedIndex(int indexPage) {
    _index = indexPage;
    notifyListeners();
  }
}
