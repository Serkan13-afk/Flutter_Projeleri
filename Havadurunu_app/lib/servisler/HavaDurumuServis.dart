import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:dio/dio.dart';
import 'package:havadurumu_app/HavaDurumuModel/HavadurumuModel.dart';

class HavaDurumuServis {
  // Konumu alıyoruz
  Future<String> konumGetir() async {
    bool servisAktifMi = await Geolocator.isLocationServiceEnabled();
    if (!servisAktifMi) {
      return Future.error("Konum servis aktif değil");
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("Konum izni verilmedi");
      }
    }

    Position konum = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    List<Placemark> enlemBoylam = await placemarkFromCoordinates(
      konum.latitude,
      konum.longitude,
    );

    String? sehir = enlemBoylam[0].locality;

    if (sehir == null) return Future.error("Şehir bulunamadı");

    return normalizeSehir(sehir);
  }

  Future<List<HavadurumuModel>> havadurumuVerileri() async {
    try {
      final String sehir = await konumGetir();
      print("API'ye gönderilen şehir: $sehir");

      final String url =
          "https://api.collectapi.com/weather/getWeather?lang=tr&city=$sehir";

      final Map<String, dynamic> basliklar = {
        "authorization": "apikey 4DMJszDqOzVJUbUHEZoGV6:7xuZ8ALeyh99ztwklo1Pjb",
        "content-type": "application/json",
      };

      final dio = Dio();
      final cevap = await dio.get(url, options: Options(headers: basliklar));

      print("API Yanıtı: ${cevap.data}");
      print("Yanıt tipi: ${cevap.data.runtimeType}");

      // API yanıt yapısını kontrol et
      List<dynamic> list;
      if (cevap.data is List<dynamic>) {
        list = cevap.data as List<dynamic>;
      } else if (cevap.data is Map<String, dynamic> &&
          cevap.data["result"] is List<dynamic>) {
        list = cevap.data["result"] as List<dynamic>;
      } else {
        print("Beklenmeyen yanıt yapısı: ${cevap.data}");
        return [];
      }

      print("Liste uzunluğu: ${list.length}");

      final List<HavadurumuModel> havaListesi = list
          .map((e) => HavadurumuModel.fromjson(e as Map<String, dynamic>))
          .toList();

      return havaListesi;
    } catch (e) {
      print("Hata oluştu: $e");
      return [];
    }
  }

  Future<List<HavadurumuModel>> havadurumuVerileriSehir(String sehir) async {
    try {
      final String normalized = normalizeSehir(sehir);
      print("API'ye gönderilen normalize edilmiş şehir: $normalized");

      final String url =
          "https://api.collectapi.com/weather/getWeather?lang=tr&city=$normalized";

      final Map<String, dynamic> basliklar = {
        "authorization": "apikey 4DMJszDqOzVJUbUHEZoGV6:7xuZ8ALeyh99ztwklo1Pjb",
        "content-type": "application/json",
      };

      final dio = Dio();
      final cevap = await dio.get(url, options: Options(headers: basliklar));

      print("API Yanıtı (şehir): ${cevap.data}");
      print("Yanıt tipi (şehir): ${cevap.data.runtimeType}");

      // API yanıt yapısını kontrol et
      List<dynamic> list;
      if (cevap.data is List<dynamic>) {
        list = cevap.data as List<dynamic>;
      } else if (cevap.data is Map<String, dynamic> &&
          cevap.data["result"] is List<dynamic>) {
        list = cevap.data["result"] as List<dynamic>;
      } else {
        print("Beklenmeyen yanıt yapısı (şehir): ${cevap.data}");
        return [];
      }

      print("Liste uzunluğu (şehir): ${list.length}");

      return list
          .map((e) => HavadurumuModel.fromjson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print("Hata oluştu (şehir): $e");
      return [];
    }
  }

  // Şehir ismini normalize ediyoruz (Türkçe karakterler)
  String normalizeSehir(String sehir) {
    return sehir
        .replaceAll('İ', 'I')
        .replaceAll('ı', 'i')
        .replaceAll('Ş', 'S')
        .replaceAll('ş', 's')
        .replaceAll('Ç', 'C')
        .replaceAll('ç', 'c')
        .replaceAll('Ö', 'O')
        .replaceAll('ö', 'o')
        .replaceAll('Ü', 'U')
        .replaceAll('ü', 'u')
        .replaceAll('Ğ', 'G')
        .replaceAll('ğ', 'g');
  }
}
