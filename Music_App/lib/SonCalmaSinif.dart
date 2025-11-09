import 'package:shared_preferences/shared_preferences.dart';

class SonCalmaSinif {
  // Şarkı ekleme (örnek: isim, sanatçı, süre)
  static Future<void> sarkiEkle(
    String sarkiAd,
    String sanatciAd,
    String sure,
    String dosyaYolu,
  ) async {
    final pref = await SharedPreferences.getInstance();

    // Eski listeyi al
    List<String> mevcutListe = pref.getStringList("sonCalinan") ?? [];

    // Yeni şarkıyı JSON benzeri bir string olarak kaydedelim
    String yeniSarki = "$sarkiAd-$sanatciAd-$sure-$dosyaYolu";

    // Listeye ekle
    mevcutListe.add(yeniSarki);

    // Kaydet
    await pref.setStringList("sonCalinan", mevcutListe);
  }

  // Şarkıları oku
  static Future<List<String>> sarkiOku() async {
    final pref = await SharedPreferences.getInstance();
    List<String> sonCalinan = pref.getStringList("sonCalinan") ?? [];
    return sonCalinan;
  }
}

class FavoriSinif {
  // Şarkı ekleme (örnek: isim, sanatçı, süre)
  static Future<void> favoriEkle(
    String sarkiAd,
    String sanatciAd,
    String sure,
    String dosyaYolu,
  ) async {
    final pref = await SharedPreferences.getInstance();

    // Eski listeyi al
    List<String> mevcutListe = pref.getStringList("favoriListe") ?? [];

    // Yeni şarkıyı JSON benzeri bir string olarak kaydedelim
    String yeniSarki = "$sarkiAd-$sanatciAd-$sure-$dosyaYolu";

    // Listeye ekle
    mevcutListe.add(yeniSarki);

    // Kaydet
    await pref.setStringList("favoriListe", mevcutListe);
  }

  // Şarkıları oku
  static Future<List<String>> favoriOku() async {
    final pref = await SharedPreferences.getInstance();
    List<String> sonCalinan = pref.getStringList("favoriListe") ?? [];
    return sonCalinan;
  }

  static Future<void> favoriSil(String sarkiAd) async {
    final pref = await SharedPreferences.getInstance();
    List<String> liste = await favoriOku();

    // Şarkı adını içeren favoriyi bul ve kaldır
    liste.removeWhere((element) => element.startsWith("$sarkiAd"));

    // Güncellenmiş listeyi kaydet
    await pref.setStringList("favoriListe", liste);
  }
}
