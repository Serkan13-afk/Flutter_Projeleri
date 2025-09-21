import 'package:flutter/material.dart';

class TemaOkuma extends ChangeNotifier {
  var temaKoyuMu = true;

  bool temaOku() {
    return temaKoyuMu;
  }

  void temaDegis() {
    temaKoyuMu = !temaKoyuMu;
    notifyListeners();
  }
}

class DilOkuma extends ChangeNotifier {
  Locale varsayilan = Locale("tr");

  Locale dilOku() {
    return varsayilan;
  }

  void dilDegistir(Locale locale) {
    varsayilan = locale;
    notifyListeners();
  }
}
