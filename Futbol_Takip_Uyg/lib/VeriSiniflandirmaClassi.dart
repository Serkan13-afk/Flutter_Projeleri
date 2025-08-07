import 'package:futbol_takipuyg/Veri.dart';
import 'package:futbol_takipuyg/VeriCevap.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class VeriAl {


  List<Veri> verilerParse(String veri) {
    var jsonVeri = json.decode(veri);
    return Vericevap.fromJson(jsonVeri).takimListesi;
  }

  Future<List<Veri>> siflandirma(String tur) async {
    var url = Uri.parse(
      "http://10.0.2.2/FutbolVerileri/tum_bilgiler_arama.php",
    );
    var cevap = await http.post(url, body: {"tur": tur});
    return verilerParse(cevap.body);
  }
}
