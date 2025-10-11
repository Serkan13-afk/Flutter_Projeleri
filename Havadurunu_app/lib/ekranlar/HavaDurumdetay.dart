import 'package:flutter/material.dart';
import 'package:havadurumu_app/Providerler.dart';
import 'package:provider/provider.dart';

import '../HavaDurumuModel/HavadurumuModel.dart';

class Havadurumdetay extends StatefulWidget {
  final HavadurumuModel model;
  final String sehirIsmi;

  Havadurumdetay(this.model, this.sehirIsmi);

  @override
  State<Havadurumdetay> createState() => _HavadurumdetayState();
}

class _HavadurumdetayState extends State<Havadurumdetay> {
  String arkaplanturu() {
    String durum = widget.model.durum
        .toLowerCase()
        .trim(); // küçük harfe çevir ve boşlukları temizle

    if (durum.contains("açık")) {
      return "https://i.imgur.com/HsRVagn.jpeg"; // Açık
    } else if (durum.contains("hafif yağmur")) {
      return "https://i.imgur.com/voyGCp1.png"; // Hafif yağmur
    } else if (durum.contains("parçalı bulutlu")) {
      return "https://i.imgur.com/cixsWbK.png"; // Parçalı bulutlu
    } else if (durum.contains("az bulutlu") ||
        durum.contains("az parçalı bulutlu")) {
      return "https://i.imgur.com/cixsWbK.png"; // Az bulutlu
    } else if (durum.contains("kapalı") ||
        durum.contains("çok bulutlu") ||
        durum.contains("overcast")) {
      return "https://i.imgur.com/JAgMTQU.png"; // Kapalı
    } else if (durum.contains("orta şiddetli yağmur") ||
        durum.contains("yağmur")) {
      return "https://i.imgur.com/z3TTiNz.png"; // Yağmurlu
    } else if (durum.contains("sağanak yağmur") || durum.contains("showers")) {
      return "https://i.imgur.com/z3TTiNz.png"; // Sağanak yağmur
    } else if (durum.contains("kar")) {
      return "https://i.imgur.com/7tokAoU.png"; // Kar yağışlı
    } else if (durum.contains("sis") ||
        durum.contains("fog") ||
        durum.contains("pus")) {
      return "https://i.imgur.com/pqc3mYZ.png"; // Sisli / puslu
    }

    // default resim
    return "https://i.imgur.com/H7a3hcP.png";
  }

  @override
  void initState() {
    super.initState();
    arkaplanturu();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TemaOkuma>(
      builder: (context, temaNesne, child) {
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(arkaplanturu()),
                fit: BoxFit.cover,
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // 🔹 ÜST KISIM
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text(
                          widget.model.gun,
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Image.network(
                          widget.model.ikon,
                          width: 100,
                          height: 100,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "${widget.model.derece}°",
                          style: const TextStyle(
                            fontSize: 60,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          widget.model.durum,
                          style: const TextStyle(
                            fontSize: 22,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // 🔹 ALT KISIM - KART DETAYLARI
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(30),
                      ),
                      gradient: LinearGradient(
                        colors: temaNesne.temaOku()
                            ? [Colors.white, Colors.cyanAccent]
                            : [Colors.black, Colors.cyanAccent],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _detayKart("Min", "${widget.model.min}°"),
                            _detayKart("Max", "${widget.model.max}°"),
                            _detayKart("Gece", "${widget.model.gece}°"),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _detayKart("Nem", "%${widget.model.nem}"),
                            _detayKart("Tarih", widget.model.tarih),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _detayKart(String baslik, String deger) {
    return Column(
      children: [
        Text(
          baslik,
          style: const TextStyle(fontSize: 16, color: Colors.black54),
        ),
        const SizedBox(height: 5),
        Text(
          deger,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
