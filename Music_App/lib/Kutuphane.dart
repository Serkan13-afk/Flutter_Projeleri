import 'package:flutter/material.dart';
import 'package:muzikcalar_app/MuzikSinif.dart';
import 'package:muzikcalar_app/SonCalmaSinif.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Kutuphane extends StatefulWidget {
  const Kutuphane({super.key});

  @override
  State<Kutuphane> createState() => _KutuphaneState();
}

class _KutuphaneState extends State<Kutuphane> {
  int seciliIndex = 0;
  List<Widget> sayfalar = [
    const Favoriler(),
    const CalmaGecmisi(),
  ];

  @override
  Widget build(BuildContext context) {
    double genislik = MediaQuery.of(context).size.width;
    double yukseklik = MediaQuery.of(context).size.height;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF134E5E), Color(0xFF71B280)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 100),
            controlContainer(genislik, yukseklik),
            Expanded(child: sayfalar[seciliIndex]),
          ],
        ),
      ),
    );
  }

  Widget controlContainer(double genislik, double yukseklik) {
    List<IconData> ikonlar = [
      Icons.favorite,
      Icons.history,
    ];

    return Container(
      width: genislik * 0.65,
      height: yukseklik * 0.08,
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(ikonlar.length, (index) {
          bool aktif = seciliIndex == index;

          return InkWell(
            onTap: () {
              setState(() {
                seciliIndex = index;
              });
            },
            borderRadius: BorderRadius.circular(12),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: genislik * 0.28,
              height: yukseklik * 0.06,
              decoration: BoxDecoration(
                color: aktif ? Colors.greenAccent : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: aktif ? Colors.white : Colors.white54,
                  width: 1,
                ),
                boxShadow: aktif
                    ? [
                  BoxShadow(
                    color: Colors.greenAccent.withOpacity(0.6),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ]
                    : [],
              ),
              child: Icon(
                ikonlar[index],
                color: aktif ? Colors.black : Colors.white70,
                size: aktif ? 30 : 26,
              ),
            ),
          );
        }),
      ),
    );
  }
}



class Favoriler extends StatefulWidget {
  const Favoriler({super.key});

  @override
  State<Favoriler> createState() => _FavorilerState();
}

class _FavorilerState extends State<Favoriler> with TickerProviderStateMixin {
  List<List> nihaiListe = [];
  late AnimationController controller;
  late Animation<double> animation;

  int secilenIndex = -1;

  // 🔹 Favori listesini SharedPreferences'tan okur
  Future<dynamic> sonCalanListeOku() async {
    final liste = await FavoriSinif.favoriOku();

    setState(() {
      nihaiListe = liste.map((sarki) => sarki.split("-")).toList();
    });

    return nihaiListe;
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    animation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOutBack,
    );
    controller.forward();
    sonCalanListeOku();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 2 / 3,
            crossAxisCount: 2,
          ),
          itemCount: nihaiListe.length,
          itemBuilder: (context, index) {
            var muzik = nihaiListe[index];
            bool aktifmi = secilenIndex == index;

            return AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 6,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 120,
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: const DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage("resimler/log.png"),
                          ),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              right: 7,
                              bottom: 7,
                              child: SizedBox(
                                width: 30,
                                height: 30,
                                child: FloatingActionButton(
                                  backgroundColor: aktifmi
                                      ? Colors.redAccent
                                      : Colors.greenAccent,
                                  onPressed: () {
                                    setState(() {
                                      secilenIndex = index;
                                    });
                                  },
                                  child: Icon(
                                    aktifmi
                                        ? Icons.pause_circle_outline
                                        : Icons.play_arrow,
                                    size: 30,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        muzik[0],
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        muzik[1],
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        muzik[2],
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),

                  // 🔹 Sağ üst köşedeki "Kaldır" butonu
                  Positioned(
                    top: 6,
                    right: 6,
                    child: GestureDetector(
                      onTap: () async {
                        String sarkiAdi = muzik[0]; // Silinecek şarkının adı
                        await FavoriSinif.favoriSil(sarkiAdi);

                        setState(() {
                          nihaiListe.clear(); // listeyi sıfırla
                        });

                        await sonCalanListeOku(); // yeniden yükle
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          "Kaldır",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        if (secilenIndex != -1)
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: AnimatedContainer(
              width: 300,
              height: 100,
              curve: Curves.easeInOutBack,
              duration: const Duration(milliseconds: 800),
              decoration: const BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 5, left: 35),
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          secilenIndex = -1;
                        });
                      },
                      icon: const Icon(
                        Icons.pause_circle_outline_outlined,
                        color: Colors.red,
                        size: 40,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Text(
                      "${nihaiListe[secilenIndex][0]}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class CalmaGecmisi extends StatefulWidget {
  const CalmaGecmisi({super.key});

  @override
  State<CalmaGecmisi> createState() => _CalmaGecmisiState();
}

class _CalmaGecmisiState extends State<CalmaGecmisi> {

  List<List> nihaiList = [];

  Future<dynamic> sonCalanListeOku() async {
    final liste = await SonCalmaSinif.sarkiOku();

    liste.forEach((sarki) {
      nihaiList.add(sarki.split("-"));
    });

    return nihaiList;
  }

  Widget sonCalmaListesi() {
    return FutureBuilder(
      future: sonCalanListeOku(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: CircularProgressIndicator(color: Colors.white),
          );
        } else if (snapshot.hasError) {
          return Text(
            "Bir hata oluştu!",
            style: TextStyle(color: Colors.red, fontSize: 18),
          );
        } else {
          var liste = snapshot.data ?? [];

          if (liste.isEmpty) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Son çalma listesi boş !",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            );
          }

          return ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: liste.length,
            itemBuilder: (context, index) {
              var muzik = liste[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                child: Container(
                  width: 200,
                  height: 100,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF7F00FF), Color(0xFFE100FF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: Offset(2, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: Icon(Icons.music_note, color: Colors.black, size: 30),
                      title: Text(
                        muzik[0],
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        muzik[1],
                        style: TextStyle(color: Colors.white70),
                      ),
                      trailing: Text(
                        "${muzik[2]} dk",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: sonCalmaListesi(),
      backgroundColor: Colors.transparent,
    );
  }
}

