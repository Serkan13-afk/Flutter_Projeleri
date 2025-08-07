import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:futbol_takipuyg/Takim.dart';
import 'package:futbol_takipuyg/DetaySayfasi.dart';
import 'package:futbol_takipuyg/VeriCevap.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';

import 'Veri.dart';

class Takimarama extends StatefulWidget {
  const Takimarama({super.key});

  @override
  State<Takimarama> createState() => _TakimaramaState();
}

class _TakimaramaState extends State<Takimarama> with TickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animationDegerler;
  List<String> takimUrlleri = [];
  List<Takim> takimListe = [];
  var aramaController = TextEditingController();
  String aramaMetni = "";

  List<Veri> verilerParse(String cevap) {
    var jsonVeri = json.decode(cevap);
    return Vericevap.fromJson(jsonVeri).takimListesi;
  }

  Future<List<Veri>> tumTakim() async {
    var url = Uri.parse("http://10.0.2.2/FutbolVerileri/tum_bilgiler.php");
    var cevap = await http.get(url);
    return verilerParse(cevap.body);
  }

  Future<void> urlDoldur() async {
    var veri = await tumTakim();
    for (var yaz in veri) {
      takimUrlleri.add(yaz.url); // Takım urlleri alındı
    }
    print(takimUrlleri);

    await TumTakimlar();
  }

  Future<Takim?> takimGetir(String url) async {
    final cevap = await http.get(Uri.parse(url));
    if (cevap.statusCode == 200) {
      final jsonData = json.decode(cevap.body);
      final teams = jsonData["teams"];
      if (teams != null && teams.isNotEmpty) {
        return Takim.fromJson(teams[0]);
      }
    } else {
      return null;
    }
  }

  Future<void> TumTakimlar() async {
    List<Takim> gelenTakimlar = [];
    for (var url in takimUrlleri) {
      var takim = await takimGetir(url);
      if (takim != null) {
        gelenTakimlar.add(takim);
      }
    }

    setState(() {
      takimListe = gelenTakimlar;
    });
  }

  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2000),
    );
    animationDegerler = Tween(begin: 100.0, end: 0.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeOut),
    )..addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
    animationController.forward();
    urlDoldur();
  }

  @override
  Widget build(BuildContext context) {
    List<Takim> filtreListe = [];
    for (var takim in takimListe) {
      if ((takim.takimAdi ?? '').toLowerCase().contains(
        aramaMetni.toLowerCase(),
      )) {
        filtreListe.add(takim);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Shimmer.fromColors(
          baseColor: Colors.cyan,
          highlightColor: Colors.black,
          child: Align(
            alignment: Alignment.center,
            child: Text(
              'Takım Arama',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,

              ),
            ),
          ),
        ),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10,left: 20,right: 20),
            child: TextField(
              controller: aramaController,
              onChanged: (value) {
                setState(() {
                  aramaMetni = value;
                });
              },
              decoration: InputDecoration(
                label: Text(
                  'Takım Ara...',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
                fillColor: Colors.indigo,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          Expanded(
            child:
                takimListe.isEmpty
                    ?  Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 200,
                        height: 200,
                        child: Lottie.asset("iconlar/anima.json"),
                      ),
                      SizedBox(height: 40),
                      Shimmer.fromColors(
                        baseColor: Colors.cyan,
                        highlightColor: Colors.black,
                        child: Text(
                          'Takımlar yükleniyor...',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                )
                    : Transform.translate(
                      offset: Offset(0, animationDegerler.value),
                      child: ListView.builder(
                        itemCount: filtreListe.length,
                        itemBuilder: (context, index) {
                          var takim = filtreListe[index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              shape: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              tileColor: Colors.purple,
                              leading:
                                  takim.armasi != null &&
                                          takim.armasi!.isNotEmpty
                                      ? Image.network(
                                        takim.armasi!,
                                        width: 50,
                                        height: 50,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Icon(Icons.broken_image),
                                      )
                                      : Icon(Icons.image_not_supported),
                              title: Text(
                                takim.takimAdi ?? "Bilinmeyen Takım",
                                style: TextStyle(color: Colors.white),
                              ),
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context)=> Detaysayfasi(takim)));

                              },
                            ),
                          );
                        },
                      ),
                    ),
          ),
        ],
      ),
    );

  }
}
