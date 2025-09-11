import 'package:flutter/material.dart';

class TemaOkuma extends ChangeNotifier {
  bool temaKoyumu = true;

  bool temaOku() {
    return temaKoyumu;
  }

  void temaDegistir() {
    temaKoyumu = !temaKoyumu;
    notifyListeners();
  }
}

class DilOkuma extends ChangeNotifier {
  Locale varsayilanDil = Locale("tr");

  Locale guncelDilOku() {
    return varsayilanDil;
  }

  void dilDegis(Locale secilenDil) {
    varsayilanDil = secilenDil;
    notifyListeners();
  }
}
