import 'package:flutter/cupertino.dart';

class FirsatUrunFirsat extends ChangeNotifier {
  int siparisSayisi = 0;

  int siparisOku() {
    return siparisSayisi;
  }

  void urunEkle() {
    siparisSayisi += 1;
    notifyListeners();
  }

  void urunSil() {
    if (siparisOku() == 0) {
      notifyListeners();
    } else {
      siparisSayisi -= 1;
      notifyListeners();
    }
  }

  void sifirla() {
    siparisSayisi = 0;
    notifyListeners();
  }
}
