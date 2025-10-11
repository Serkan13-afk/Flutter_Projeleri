import 'package:flutter/material.dart';

class TemaOkuma extends ChangeNotifier {
  var koyuMu = false;

  bool temaOku() {
    return koyuMu;
  }

  void temaDegistir() {
    koyuMu = !koyuMu;
    notifyListeners();
  }
}

class DilOkuma extends ChangeNotifier {
  Locale varsayilanDil = Locale("tr");

  Locale dilOku() {
    return varsayilanDil;
  }

  void dilDegistir(Locale secilenDil) {
    varsayilanDil = secilenDil;
    notifyListeners();
  }
}
