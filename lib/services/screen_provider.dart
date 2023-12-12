import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

class SelectedHomePageProvider with ChangeNotifier {
  int _index = 0;
  int get index => _index;
  void onTabChangeSelectedIndex(int indexPage) {
    _index = indexPage;
    notifyListeners();
  }
}

class ConnectivityListenerProvider with ChangeNotifier {
  bool _offline = false;

  bool get offline => _offline;

  void setOffline(ConnectivityResult result) {
    _offline = true;
    notifyListeners();
  }

  void setOnline(ConnectivityResult result) {
    _offline = false;
    notifyListeners();
  }
}

class SelectViewHomeProvider with ChangeNotifier {
  // Set listview as default UI of Home Page by false this value
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
