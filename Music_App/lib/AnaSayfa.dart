import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:muzikcalar_app/MuzikSinif.dart';
import 'package:muzikcalar_app/SonCalmaSinif.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class Anasayfa extends StatefulWidget {
  late User user;

  Anasayfa(this.user);

  @override
  State<Anasayfa> createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa>
    with SingleTickerProviderStateMixin {
  late Timer timer;
  final ScrollController scrollController = ScrollController();
  double _scrolPosotion = 0.0;
  late double genislik = MediaQuery.of(context).size.width;
  late double yukseklik = MediaQuery.of(context).size.height;
  List<String> turlerListe = [
    "💖 Pop Mix",
    "🔥 Rock Rüzgarı",
    "🌙 Lo-Fi Beats",
    "🕶️ Rap Zone",
  ];

  List<MuzikSinif> muzikListe = [];
  List<List> nihaiList = [];

  List<String> trendList = [
    "resimler/semicenk.png",
    "resimler/ordinary.jpeg",
    "resimler/golden.jpeg",
    "resimler/sonbahar.jpeg",
    "resimler/diewith.jpeg",
  ];
  List<List> trendlist = [
    [
      "resimler/semicenk.png",
      "https://soundcloud.com/user-595604511-859742846/semicenk-kalpsiz?utm_source=clipboard&utm_medium=text&utm_campaign=social_sharing",
    ],
    [
      "resimler/ordinary.jpeg",
      "https://soundcloud.com/alexwaarren/ordinary?utm_source=clipboard&utm_medium=text&utm_campaign=social_sharing",
    ],
    [
      "resimler/golden.jpeg",
      "https://soundcloud.com/jeonghyeonmusic/golden-final?utm_source=clipboard&utm_medium=text&utm_campaign=social_sharing",
    ],
    [
      "resimler/sonbahar.jpeg",
      "https://soundcloud.com/poizi/sonbahar?utm_source=clipboard&utm_medium=text&utm_campaign=social_sharing",
    ],
    [
      "resimler/diewith.jpeg",
      "https://soundcloud.com/ilya-bokarev/lady-gaga-bruno-mars-die-with?utm_source=clipboard&utm_medium=text&utm_campaign=social_sharing",
    ],
  ];

  Future<dynamic> sonCalanListeOku() async {
    final liste = await SonCalmaSinif.sarkiOku();

    liste.forEach((sarki) {
      nihaiList.add(sarki.split("-"));
    });

    return nihaiList;
  }

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(milliseconds: 50), (_) {
      if (scrollController.hasClients) {
        // liste hazır ise
        _scrolPosotion += 2; // her seferinde 2 px ileri
      }

      if (_scrolPosotion >= scrollController.position.maxScrollExtent) {
        // eğer sona geldi ise başa sar
        _scrolPosotion = 0;
      }

      scrollController.jumpTo(_scrolPosotion); // zıplayarak ilerlersin
    });

    muzikListe.addAll([
      MuzikSinif(
        "Aşkın Olayım",
        "3:14",
        "Simge Sağın",
        "muzikler/askin_olayim.mp3",
      ),
      MuzikSinif("Dilize", "3:14", "Bedelcan", "muzikler/dilize.mp3"),
      MuzikSinif(
        "Grani 2019",
        "3:14",
        "Burhan Toprak",
        "muzikler/grani_2019.mp3",
      ),
      MuzikSinif("Aşk Olsun", "3:14", "Çakal", "muzikler/ask_olsun.mp3"),
      MuzikSinif(
        "Cevapsız Çınlama",
        "3:14",
        "Emrah Karaduman",
        "muzikler/cevapsiz_cinlama.mp3",
      ),
      MuzikSinif(
        "Golden Age of EDM",
        "3:14",
        "Krimsonn - Expanded",
        "muzikler/golden_age_of_edm.mp3",
      ),
      MuzikSinif("Bodrum", "3:14", "Hande Yener", "muzikler/bodrum.mp3"),
      MuzikSinif(
        "Efkarım Var",
        "3:14",
        "Ziynet Sali",
        "muzikler/efkarim_var.mp3",
      ),
    ]);
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: genislik,
      height: yukseklik,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF7F00FF), Color(0xFFE100FF), Color(0xFFFFC1E3)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: yukseklik * 0.1),

              /// 🔹 Hoş geldin yazısı
              Shimmer.fromColors(
                baseColor: Colors.white70,
                highlightColor: Colors.white,
                child: Padding(
                  padding: EdgeInsets.only(left: 25),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "👋 Hoş Geldin ${widget.user!.displayName}",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                        shadows: [
                          Shadow(
                            color: Colors.black45,
                            offset: Offset(2, 2),
                            blurRadius: 5,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: yukseklik * 0.1),

              /// 🔹 Öneri Kartı
              Container(
                width: genislik * 0.9,
                height: yukseklik * 0.22,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF00B4DB),
                      Color(0xFF0083B0),
                      Color(0xFF005f73),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    const BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [Colors.white, Color(0xFFFFE57F)],
                        ).createShader(bounds),
                        child: const Text(
                          "🔥 Senin için özel",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Bu hafta en çok dinlediğin türler 🎧",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 18,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      SizedBox(height: yukseklik * 0.03),
                      Padding(
                        padding: const EdgeInsets.only(right: 150),
                        child: InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return ScaleAnimation1(
                                  "https://soundcloud.com/",
                                );
                              },
                            );
                          },
                          child: Container(
                            width: genislik * 0.33,
                            height: yukseklik * 0.06,
                            decoration: BoxDecoration(
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black,
                                  blurRadius: 10,
                                  offset: Offset(0, 3),
                                ),
                              ],
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white,
                            ),
                            child: const Center(
                              child: Text(
                                "Keşfet",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: yukseklik * 0.05),
              Align(
                alignment: Alignment.center,
                child: Text(
                  "Trendler 🔥",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),

              trendler(genislik, yukseklik),
              SizedBox(height: yukseklik * 0.05),

              /// 🔹 Çalma Listesi Başlığı
              Align(
                alignment: Alignment.center,
                child: Text(
                  "Türler ✨",
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),

              SizedBox(height: yukseklik * 0.02),

              /// 🔹 Çalma Listesi Kartları
              Container(
                width: genislik * 0.90,
                height: yukseklik * 0.35,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [turler()],
                ),
              ),

              SizedBox(height: yukseklik * 0.05),


            ],
          ),
        ),
      ),
    );
  }

  Widget turler() {
    return SizedBox(
      height: yukseklik * 0.35, // GridView için sabit yükseklik
      child: GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        // Column ile çakışmayı önler
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 30),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2 sütun
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 3 / 2, // Kart boyutunu ayarla
        ),
        itemCount: turlerListe.length,
        itemBuilder: (context, index) {
          var tur = turlerListe[index];
          return InkWell(
            onTap: () {},
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.purple.withOpacity(0.6),
                    Colors.pink.withOpacity(0.6),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 5,
                    offset: Offset(2, 4),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  tur,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black45,
                        offset: Offset(1, 2),
                        blurRadius: 3,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget trendler(double genislik, double yukseklik) {
    return SizedBox(
      height: yukseklik * 0.25, // Yatay liste için sabit yükseklik şart
      child: ListView.builder(
        controller: scrollController,
        scrollDirection: Axis.horizontal, // 🔥 yatay kaydırma yönü
        itemCount: 5,
        itemBuilder: (context, index) {
          var veri = trendlist[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: genislik * 0.6,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(veri[0]),
                ),
                color: Colors.black,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Stack(
                children: [
                  Positioned(
                    bottom: 15, // 🔽 alta yerleştir
                    left: 0,
                    right: 0, // 🔁 ortalamak için left + right birlikte verilir
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return ScaleAnimation1(veri[1]);
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.greenAccent,
                          shadowColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "Detaylara git",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// 🔸 Fonksiyon: Tek playlist kartı
  Widget playlistCard(
    double genislik,
    double yukseklik,
    List<Color> renkler,
    String baslik,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: genislik * 0.40,
        height: yukseklik * 0.14,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            colors: renkler,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(2, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            baslik,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
              shadows: [
                Shadow(
                  color: Colors.black45,
                  offset: Offset(1, 2),
                  blurRadius: 3,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


}

class ScaleAnimation1 extends StatefulWidget {
  late String url;

  ScaleAnimation1(this.url);

  @override
  State<ScaleAnimation1> createState() => _ScaleAnimation1State();
}

class _ScaleAnimation1State extends State<ScaleAnimation1>
    with TickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;

  Future<void> kesfetileYonlendir() async {
    final url = Uri.parse(widget.url);
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );
    animation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOutBack,
    );
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: animation,
      child: AlertDialog(
        backgroundColor: const Color(0xFF1c2b36).withOpacity(0.95),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        title: Row(
          children: [
            Icon(Icons.info_outline, color: Colors.greenAccent),
            const SizedBox(width: 8),
            Text(
              "Bilgilendirme",
              style: TextStyle(
                color: Colors.greenAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Text(
          "Web sayfasına yönlendirileceksiniz.",
          style: const TextStyle(color: Colors.white70, fontSize: 16),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              kesfetileYonlendir();
            },
            child: Text("Yönlendir", style: TextStyle(color: Colors.black)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.greenAccent,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: Colors.white, width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
