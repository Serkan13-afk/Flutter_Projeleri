import 'package:flutter/widgets.dart';

class SepetSayac extends ChangeNotifier {
  int komplesepetsayac = 0;
  Map<int, int> urunid_urundegeri = {};



  int urunSayaciOku(int id) {
    return urunid_urundegeri[id] ?? 0;
  }

  void sayacSifirlama() {
    komplesepetsayac = 0;
    urunid_urundegeri.clear();
    notifyListeners();
  }

  int komplesayacOku() {
    return komplesepetsayac;
  }

  void urunEkle(int urunid) {
    urunid_urundegeri[urunid] = (urunid_urundegeri[urunid] ?? 0) + 1;
    komplesepetsayac += 1;
    notifyListeners();
  }

  void urunSil(int urunid) {
    if ((urunid_urundegeri[urunid] ?? 0) > 0) {
      urunid_urundegeri[urunid] = urunid_urundegeri[urunid]! - 1;
      komplesepetsayac -= 1;
      notifyListeners();
    }
    notifyListeners();
  }
}
