import 'dart:async';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:muzikcalar_app/SonCalmaSinif.dart';
import 'package:shimmer/shimmer.dart';
import 'MuzikSinif.dart';
import 'dart:math' as math;

class Aramasayfa extends StatefulWidget {
  const Aramasayfa({super.key});

  @override
  State<Aramasayfa> createState() => _AramasayfaState();
}

class _AramasayfaState extends State<Aramasayfa> {
  late AudioPlayer muzikCalar;
  late TextEditingController searcbarIcerik;
  List<MuzikSinif> muzikListe = [];
  List<MuzikSinif> filtreliListe = [];
  int? suanCalanIndex;
  late double genislik = MediaQuery.of(context).size.width;
  late double yukseklik = MediaQuery.of(context).size.height;

  @override
  void initState() {
    super.initState();
    muzikCalar = AudioPlayer();
    searcbarIcerik = TextEditingController();

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

    filtreliListe = List.from(muzikListe);
  }

  @override
  void dispose() {
    muzikCalar.dispose();
    searcbarIcerik.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var yukseklik = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFD30A6F), Color(0xff0ae1e1), Color(0xFF0f3460)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            // 🔹 ANA İÇERİK (üstteki liste ve arama barı)
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                const Text(
                  "ŞARKI ARAYIN 🎵",
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 27,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                aramaBar(),
                const SizedBox(height: 20),
                Expanded(child: aramaSonucu()),
              ],
            ),

            // 🔹 ALTTAN ÇIKAN KÜÇÜK PANEL
            if (suanCalanIndex != null)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.8),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.white24,
                        blurRadius: 8,
                        offset: Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 10),
                      Icon(Icons.music_note, color: Colors.white, size: 40),
                      Expanded(
                        child: Text(
                          filtreliListe[suanCalanIndex!].muzikAd,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          setState(() => suanCalanIndex = null);
                          await muzikCalar.stop();
                        },
                        icon: const Icon(
                          Icons.pause_circle_filled,
                          color: Colors.pinkAccent,
                          size: 40,
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
    ;
  }

  Widget aramaBar() {
    var genislik = MediaQuery.of(context).size.width;
    var yukseklik = MediaQuery.of(context).size.height;

    return Container(
      width: genislik * 0.9,
      height: yukseklik * 0.07,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF00B4DB), Color(0xFF0083B0)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Colors.white, blurRadius: 12, offset: Offset(0, 5)),
        ],
      ),
      child: TextField(
        controller: searcbarIcerik,
        onChanged: (value) {
          setState(() {
            filtreliListe = muzikListe
                .where(
                  (muzik) =>
                      muzik.muzikAd.toLowerCase().contains(
                        value.toLowerCase(),
                      ) ||
                      muzik.muzikSanatci.toLowerCase().contains(
                        value.toLowerCase(),
                      ),
                )
                .toList();
          });
        },
        style: const TextStyle(color: Colors.white, fontSize: 16),
        cursorColor: Colors.white,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search, color: Colors.white),
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                searcbarIcerik.clear();
                filtreliListe = List.from(muzikListe);
              });
            },
            icon: const Icon(Icons.cancel, color: Colors.redAccent),
          ),
          hintText: "Şarkı ara...",
          hintStyle: const TextStyle(color: Colors.white70, fontSize: 15),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 15,
          ),
        ),
      ),
    );
  }

  Widget aramaSonucu() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      itemCount: filtreliListe.length,
      itemBuilder: (context, index) {
        var muzik = filtreliListe[index];

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white.withOpacity(0.85), Colors.grey.shade300],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [
              BoxShadow(
                color: Colors.black54,
                blurRadius: 6,
                offset: Offset(2, 3),
              ),
            ],
          ),
          child: ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MuzikDetay(
                    muzik.muzikAd,
                    muzik.muzikSanatci,
                    muzik.muzikDk,
                    muzik.dosyaYolu,
                  ),
                ),
              );
              SonCalmaSinif.sarkiEkle(
                muzik.muzikAd,
                muzik.muzikSanatci,
                muzik.muzikDk,
                muzik.dosyaYolu,

              );
            },
            leading: Icon(Icons.music_note, color: Colors.black87),
            trailing: IconButton(
              onPressed: () {
                setState(() {
                  suanCalanIndex = index;
                });

                muzikCalar.setAsset(muzik.dosyaYolu);
                muzikCalar.play();
                SonCalmaSinif.sarkiEkle(
                  muzik.muzikAd,
                  muzik.muzikSanatci,
                  muzik.muzikDk,
                  muzik.dosyaYolu,

                );
              },
              icon: suanCalanIndex == index
                  ? Icon(
                      Icons.pause_circle_outline,
                      color: Colors.red,
                      size: 30,
                    )
                  : Icon(
                      Icons.play_circle_outline,
                      color: Colors.green,
                      size: 30,
                    ),
            ),
            title: Text(
              muzik.muzikAd,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text("${muzik.muzikSanatci} • ${muzik.muzikDk}"),
          ),
        );
      },
    );
  }
}

class MuzikDetay extends StatefulWidget {
  final String sarkiismi;
  final String sanatciismi;
  final String sarkiuzunlugu;
  final String dosyayolu;

  const MuzikDetay(
    this.sarkiismi,
    this.sanatciismi,
    this.sarkiuzunlugu,
    this.dosyayolu, {
    super.key,
  });

  @override
  State<MuzikDetay> createState() => _MuzikDetayState();
}

class _MuzikDetayState extends State<MuzikDetay> with TickerProviderStateMixin {
  late AudioPlayer muzikCalar;
  late AnimationController animationController;
  double sure = 0.0;
  double toplamSure = 1;
  bool oynatiliyorMu = false;
  bool tekrarOynatilsinMi = false;
  bool kayitlimi = false;

  @override
  void initState() {
    super.initState();
    muzikCalar = AudioPlayer();

    // 🌀 CD Animasyonu
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    );

    animationController.repeat();

    _muzikHazirla();
  }

  Future<void> _muzikHazirla() async {
    try {
      await muzikCalar.setAsset(widget.dosyayolu);
      toplamSure = (await muzikCalar.duration)?.inSeconds.toDouble() ?? 0;
      await muzikCalar.play();
      setState(() => oynatiliyorMu = true);

      // Pozisyon değiştikçe güncelle
      muzikCalar.positionStream.listen((pos) {
        setState(() {
          sure = pos.inSeconds.toDouble();
        });
      });

      muzikCalar.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          if (tekrarOynatilsinMi) {
            muzikCalar.seek(Duration.zero);
            muzikCalar.play();
          } else {
            setState(() {
              oynatiliyorMu = false;
              animationController.stop();
            });
          }
        }
      });
    } catch (e) {
      print("⚠️ Ses dosyası yüklenemedi: $e");
    }
  }

  String formatSure(double saniye) {
    int dakika = saniye ~/ 60;
    int sn = (saniye % 60).toInt();
    return "${dakika.toString().padLeft(2, '0')}:${sn.toString().padLeft(2, '0')}";
  }

  @override
  void dispose() {
    muzikCalar.dispose();
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var genislik = MediaQuery.of(context).size.width;
    var yukseklik = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: genislik,
        height: yukseklik,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFD30A6F), Color(0xff0ae1e1), Color(0xFF0f3460)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: animationController,
              builder: (context, child) {
                return Transform.rotate(
                  angle: animationController.value * 2 * math.pi,
                  child: child,
                );
              },
              child: CircleAvatar(
                radius: 90,
                backgroundColor: Colors.white,
                child: ClipOval(
                  child: Image.asset("resimler/log.png", fit: BoxFit.cover),
                ),
              ),
            ),
            const SizedBox(height: 40),
            Text(
              widget.sarkiismi,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              widget.sanatciismi,
              style: const TextStyle(color: Colors.white70, fontSize: 20),
            ),
            const SizedBox(height: 30),
            Container(
              width: genislik * 0.9,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Slider(
                    value: sure,
                    min: 0,
                    max: toplamSure > 0 ? toplamSure : 1,
                    activeColor: Colors.pinkAccent,
                    inactiveColor: Colors.white24,
                    onChanged: (value) async {
                      await muzikCalar.seek(Duration(seconds: value.toInt()));
                      setState(() => sure = value);
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        formatSure(sure),
                        style: const TextStyle(color: Colors.white70),
                      ),
                      Text(
                        formatSure(toplamSure),
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Repeat
                      IconButton(
                        onPressed: () {
                          setState(
                            () => tekrarOynatilsinMi = !tekrarOynatilsinMi,
                          );
                        },
                        icon: Icon(
                          Icons.repeat_one,
                          color: tekrarOynatilsinMi
                              ? Colors.white
                              : Colors.white60,
                          size: 40,
                        ),
                      ),
                      // Play/Pause
                      IconButton(
                        iconSize: 60,
                        icon: Icon(
                          oynatiliyorMu
                              ? Icons.play_circle
                              : Icons.pause_circle,
                          color: oynatiliyorMu ? Colors.green : Colors.red,
                        ),
                        onPressed: () async {
                          setState(() => oynatiliyorMu = !oynatiliyorMu);

                          if (oynatiliyorMu) {
                            await muzikCalar.pause();
                            animationController.stop();
                          } else {
                            await muzikCalar.play();
                            animationController.repeat();
                          }
                        },
                      ),
                      // Favorite
                      IconButton(
                        onPressed: () {
                          setState(() => kayitlimi = !kayitlimi);
                          kayitlimi
                              ? FavoriSinif.favoriEkle(
                                  widget.sarkiismi,
                                  widget.sanatciismi,
                                  widget.sarkiuzunlugu,
                                  widget.dosyayolu,
                                )
                              : FavoriSinif.favoriSil(widget.dosyayolu);
                        },
                        icon: Icon(
                          Icons.favorite,
                          color: kayitlimi ? Colors.red : Colors.white,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
