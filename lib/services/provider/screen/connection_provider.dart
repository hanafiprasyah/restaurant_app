import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

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
