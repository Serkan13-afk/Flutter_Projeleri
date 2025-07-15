import 'package:kripto_uyg/Kisi.dart';

class KisiCevap {
  late int success;
  late List<Kisi> kriptoListesi;

  KisiCevap(this.success, this.kriptoListesi);

  factory KisiCevap.fromJson(Map<String, dynamic> json) {
    var jsonArray = json["kripto2"] as List;

    List<Kisi> kriptoListesi =
        jsonArray
            .map((jsonArrayNesnesi) => Kisi.fromJson(jsonArrayNesnesi))
            .toList();
    return KisiCevap(json["success"] as int, kriptoListesi);
  }
}
