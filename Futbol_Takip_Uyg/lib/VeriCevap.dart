import 'Veri.dart';

class Vericevap {
  late int success;
  late List<Veri> takimListesi;

  Vericevap(this.success, this.takimListesi);

  factory Vericevap.fromJson(Map<String, dynamic> json) {
    var jsonArray = json["takimurlleri3"] as List;

    List<Veri> takimListesi =
    jsonArray
        .map((jsonArrayNesnesi) => Veri.fromJson(jsonArrayNesnesi))
        .toList();
    return Vericevap(json["success"] as int, takimListesi);
  }
}