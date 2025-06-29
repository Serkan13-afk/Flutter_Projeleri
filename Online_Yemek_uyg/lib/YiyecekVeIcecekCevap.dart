import 'package:gosteris/YiyecekVeIcecek.dart';

class YiyecekVeIcecekCevap {
  late List<YiyecekVeIcecek> besinlerListesi;
  late int success;

  YiyecekVeIcecekCevap(this.success, this.besinlerListesi);

  factory YiyecekVeIcecekCevap.fromJson(Map<String, dynamic> json) {
    var jsonArray = json["besinler2"] as List; //Liasteye ulaştık
    List<YiyecekVeIcecek> besinlerListesi =
        jsonArray
            .map(
              (jsonArrayNesnesi) => YiyecekVeIcecek.fromJson(jsonArrayNesnesi),
            )
            .toList(); //Nesnelere ulaştık

    return YiyecekVeIcecekCevap(json["success"] as int, besinlerListesi);
  }
}
