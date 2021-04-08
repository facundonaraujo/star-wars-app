import 'package:flutter/material.dart';

class StatusModel with ChangeNotifier {
  bool _status = false;

  bool get status => this._status;
  set status(bool valor) {
    this._status = valor;
    notifyListeners();
  }
}
