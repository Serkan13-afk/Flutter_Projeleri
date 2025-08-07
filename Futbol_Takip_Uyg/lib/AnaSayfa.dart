import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:futbol_takipuyg/FavoriTakimDetaySayfasi.dart';
import 'package:futbol_takipuyg/Kisiler.dart';
import 'package:futbol_takipuyg/VeriSiniflandirmaClassi.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import 'DetaySayfasi.dart';
import 'Takim.dart';

class Anasayfa extends StatefulWidget {
  late Kisiler kisiler;

  Anasayfa(this.kisiler);

  @override
  State<Anasayfa> createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> with TickerProviderStateMixin {
  final karekodMesaji =
      "https://drive.google.com/file/d/1c_QrX9i5hduN9anV58u5nx8kMg-8O5Zk/view?usp=sharing";
  late TabController tabController;
  final Uri mailUrl = Uri(
    scheme: "mailto",
    path: "serko.131215@gmail.com",
    queryParameters: {
      'subject': 'Futbol Takip Uygulaması Geri Bildirim',
      'body': 'Merhaba, uygulamanızla ilgili geri bildirimim şudur:',
    },
  );

  Future<void> mailControl() async {
    if (await canLaunchUrl(mailUrl)) {
      // yukarıdaki nesneye bakıyor sorun varmı yoksa gir
      await launchUrl(
        mailUrl,
        mode: LaunchMode.externalApplication,
      ); // sonrada bilgileri al gönder
    } else {
      print("Mail gönderilemiyor");
    }
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 6, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SayacDinleme(),
      child: Scaffold(
        appBar: AppBar(
          title: Shimmer.fromColors(
            baseColor: Colors.cyan,
            highlightColor: Colors.black87,
            child: Align(
              alignment: Alignment.center,
              child: Text(
                "Ana Sayfa",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          backgroundColor: Colors.black,
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(""),
                accountEmail: Shimmer.fromColors(
                  baseColor: Colors.white,
                  highlightColor: Colors.black,
                  child: Text(
                    "${widget.kisiler.kulaniciAdi}",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: AssetImage("resimler/indir.png"),
                ),
                decoration: BoxDecoration(color: Colors.indigo),
              ),
              ListTile(
                leading: Icon(Icons.home),
                title: Text("Ana Sayfa"),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.qr_code),
                title: Text("Kare Kod"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => Scaffold(
                            appBar: AppBar(
                              title: Align(
                                alignment: Alignment.center,
                                child: Shimmer.fromColors(
                                  baseColor: Colors.cyan,
                                  highlightColor: Colors.black,
                                  child: Text(
                                    "Kare Kod Sayfasi",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30,
                                    ),
                                  ),
                                ),
                              ),
                              backgroundColor: Colors.black,
                            ),
                            backgroundColor: Colors.white,
                            body: Center(
                              child: QrImageView(
                                data: karekodMesaji,
                                // Qr kod içerisine gönderilecek veri
                                version: QrVersions.auto,
                                //versiyon otomotik ayarlansın
                                size: 250,
                                // boyutu
                                gapless: false, // kareler arası boşluk var
                              ),
                            ),
                          ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.info_outline),
                title: Text("Hakkında"),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(
                          "Uygulama Hakkında Bilgilendirme",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        content: Shimmer.fromColors(
                          baseColor: Colors.white54,
                          highlightColor: Colors.white,
                          child: Text(
                            'Bu uygulama, güncel kripto para fiyatlarını takip etmenizi sağlar. '
                            'Favori coinlerinizi listeleyebilir, fiyat grafiklerini inceleyebilir ve market sıralamalarını görüntüleyebilirsiniz.\n\n'
                            'Veriler CoinGecko API üzerinden alınmakta olup yatırım tavsiyesi içermez.',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                        ),
                        actions: [
                          TextButton(
                            child: Text(
                              'Kapat',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                        backgroundColor: Colors.black26,
                      );
                    },
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.outgoing_mail),
                title: Text("Geri Bildirim"),
                onTap: () {
                  mailControl();
                },
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text("Çıkış"),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(
                          "Uygulama Hakkında Bilgilendirme",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 21,
                            color: Colors.blue,
                          ),
                        ),
                        content: Shimmer.fromColors(
                          baseColor: Colors.white54,
                          highlightColor: Colors.white,
                          child: Text(
                            "Uygulamadan çıkmak istiyor musunuz?",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        actions: [
                          TextButton(
                            child: Text(
                              'İptal',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),

                          TextButton(
                            child: Text(
                              'Çık',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () {
                              SystemNavigator.pop();
                            },
                          ),
                        ],
                        backgroundColor: Colors.black26,
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
        backgroundColor: Colors.teal,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              TabBar(
                controller: tabController,
                isScrollable: true,
                labelColor: Colors.greenAccent,
                unselectedLabelColor: Colors.white,
                indicatorColor: Colors.greenAccent,
                tabs: const [
                  Tab(text: "Süper Lig"),
                  Tab(text: "Premier Lig"),
                  Tab(text: "La Liga"),
                  Tab(text: "Bundesliga"),
                  Tab(text: "Serie A"),
                  Tab(text: "Ligue 1"),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: tabController,
                  children: [
                    SuperLig(),
                    Premier(),
                    LaLiga(),
                    Bundesliga(),
                    SerieA(),
                    Ligue1(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SuperLig extends StatefulWidget {
  const SuperLig({super.key});

  @override
  State<SuperLig> createState() => _SuperLigState();
}

class _SuperLigState extends State<SuperLig> {
  List<String> urlListesi = [];
  List<Takim> gelenTakimlar = [];
  List<Takim> takimListe = [];

  var superligUrl = VeriAl();

  Future<void> urlDoldur() async {
    var veri = await superligUrl.siflandirma("1");
    for (var yaz in veri) {
      urlListesi.add(yaz.url); // Takım urlleri alındı
    }
    print(urlListesi);

    await TumTakimlar();
  }

  Future<Takim?> takimGetir(String url) async {
    final cevap = await http.get(Uri.parse(url));
    if (cevap.statusCode == 200) {
      final jsonData = json.decode(cevap.body);
      final teams = jsonData["teams"];
      print("Veri alınıyor: $url");
      print("Cevap kodu: ${cevap.statusCode}");
      if (teams != null && teams.isNotEmpty) {
        return Takim.fromJson(teams[0]);
      }
    } else {
      return null;
    }
  }

  Future<void> TumTakimlar() async {
    List<Takim> gelenTakimlar = [];
    for (var url in urlListesi) {
      var takim = await takimGetir(url);
      if (takim != null) {
        gelenTakimlar.add(takim);
      }
    }

    setState(() {
      takimListe = gelenTakimlar;
    });
  }

  @override
  void initState() {
    super.initState();
    urlDoldur();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          takimListe.isEmpty
              ? Center(
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
                        'Süper lig Takımları Yükleniyor...',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              )
              : ListView.builder(
                itemCount: takimListe.length,
                itemBuilder: (context, index) {
                  var takim = takimListe[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      shape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      tileColor: Colors.purple,
                      leading:
                          takim.armasi != null && takim.armasi!.isNotEmpty
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Detaysayfasi(takim),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
    );
  }
}

class Premier extends StatefulWidget {
  const Premier({super.key});

  @override
  State<Premier> createState() => _PremierState();
}

class _PremierState extends State<Premier> {
  List<String> urlListesi = [];
  List<Takim> gelenTakimlar = [];
  List<Takim> takimListe = [];

  var superligUrl = VeriAl();

  Future<void> urlDoldur() async {
    var veri = await superligUrl.siflandirma("2");
    for (var yaz in veri) {
      urlListesi.add(yaz.url); // Takım urlleri alındı
    }
    print(urlListesi);

    await TumTakimlar();
  }

  Future<Takim?> takimGetir(String url) async {
    final cevap = await http.get(Uri.parse(url));
    if (cevap.statusCode == 200) {
      final jsonData = json.decode(cevap.body);
      final teams = jsonData["teams"];
      print("Veri alınıyor: $url");
      print("Cevap kodu: ${cevap.statusCode}");
      if (teams != null && teams.isNotEmpty) {
        return Takim.fromJson(teams[0]);
      }
    } else {
      return null;
    }
  }

  Future<void> TumTakimlar() async {
    List<Takim> gelenTakimlar = [];
    for (var url in urlListesi) {
      var takim = await takimGetir(url);
      if (takim != null) {
        gelenTakimlar.add(takim);
      }
    }

    setState(() {
      takimListe = gelenTakimlar;
    });
  }

  @override
  void initState() {
    super.initState();
    urlDoldur();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          takimListe.isEmpty
              ? Center(
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
                        'Premier Lig Takimları Yükleniyor...',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              )
              : ListView.builder(
                itemCount: takimListe.length,
                itemBuilder: (context, index) {
                  var takim = takimListe[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      shape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      tileColor: Colors.purple,
                      leading:
                          takim.armasi != null && takim.armasi!.isNotEmpty
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Detaysayfasi(takim),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
    );
  }
}

class LaLiga extends StatefulWidget {
  const LaLiga({super.key});

  @override
  State<LaLiga> createState() => _LaLigaState();
}

class _LaLigaState extends State<LaLiga> {
  List<String> urlListesi = [];
  List<Takim> gelenTakimlar = [];
  List<Takim> takimListe = [];

  var superligUrl = VeriAl();

  Future<void> urlDoldur() async {
    var veri = await superligUrl.siflandirma("3");
    for (var yaz in veri) {
      urlListesi.add(yaz.url); // Takım urlleri alındı
    }
    print(urlListesi);

    await TumTakimlar();
  }

  Future<Takim?> takimGetir(String url) async {
    final cevap = await http.get(Uri.parse(url));
    if (cevap.statusCode == 200) {
      final jsonData = json.decode(cevap.body);
      final teams = jsonData["teams"];
      print("Veri alınıyor: $url");
      print("Cevap kodu: ${cevap.statusCode}");
      if (teams != null && teams.isNotEmpty) {
        return Takim.fromJson(teams[0]);
      }
    } else {
      return null;
    }
  }

  Future<void> TumTakimlar() async {
    List<Takim> gelenTakimlar = [];
    for (var url in urlListesi) {
      var takim = await takimGetir(url);
      if (takim != null) {
        gelenTakimlar.add(takim);
      }
    }

    setState(() {
      takimListe = gelenTakimlar;
    });
  }

  @override
  void initState() {
    super.initState();
    urlDoldur();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          takimListe.isEmpty
              ? Center(
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
                        'La Liga Takimları Yükleniyor...',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              )
              : ListView.builder(
                itemCount: takimListe.length,
                itemBuilder: (context, index) {
                  var takim = takimListe[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      shape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      tileColor: Colors.purple,
                      leading:
                          takim.armasi != null && takim.armasi!.isNotEmpty
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Detaysayfasi(takim),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
    );
  }
}

class Bundesliga extends StatefulWidget {
  const Bundesliga({super.key});

  @override
  State<Bundesliga> createState() => _BundesligaState();
}

class _BundesligaState extends State<Bundesliga> {
  List<String> urlListesi = [];
  List<Takim> gelenTakimlar = [];
  List<Takim> takimListe = [];

  var superligUrl = VeriAl();

  Future<void> urlDoldur() async {
    var veri = await superligUrl.siflandirma("4");
    for (var yaz in veri) {
      urlListesi.add(yaz.url); // Takım urlleri alındı
    }
    print(urlListesi);

    await TumTakimlar();
  }

  Future<Takim?> takimGetir(String url) async {
    final cevap = await http.get(Uri.parse(url));
    if (cevap.statusCode == 200) {
      final jsonData = json.decode(cevap.body);
      final teams = jsonData["teams"];
      print("Veri alınıyor: $url");
      print("Cevap kodu: ${cevap.statusCode}");
      if (teams != null && teams.isNotEmpty) {
        return Takim.fromJson(teams[0]);
      }
    } else {
      return null;
    }
  }

  Future<void> TumTakimlar() async {
    List<Takim> gelenTakimlar = [];
    for (var url in urlListesi) {
      var takim = await takimGetir(url);
      if (takim != null) {
        gelenTakimlar.add(takim);
      }
    }

    setState(() {
      takimListe = gelenTakimlar;
    });
  }

  @override
  void initState() {
    super.initState();
    urlDoldur();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          takimListe.isEmpty
              ? Center(
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
                        'Bundesliga Takimları Yükleniyor...',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              )
              : ListView.builder(
                itemCount: takimListe.length,
                itemBuilder: (context, index) {
                  var takim = takimListe[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      shape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      tileColor: Colors.purple,
                      leading:
                          takim.armasi != null && takim.armasi!.isNotEmpty
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Detaysayfasi(takim),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
    );
  }
}

class SerieA extends StatefulWidget {
  const SerieA({super.key});

  @override
  State<SerieA> createState() => _SerieAState();
}

class _SerieAState extends State<SerieA> {
  List<String> urlListesi = [];
  List<Takim> gelenTakimlar = [];
  List<Takim> takimListe = [];

  var superligUrl = VeriAl();

  Future<void> urlDoldur() async {
    var veri = await superligUrl.siflandirma("5");
    for (var yaz in veri) {
      urlListesi.add(yaz.url); // Takım urlleri alındı
    }
    print(urlListesi);

    await TumTakimlar();
  }

  Future<Takim?> takimGetir(String url) async {
    final cevap = await http.get(Uri.parse(url));
    if (cevap.statusCode == 200) {
      final jsonData = json.decode(cevap.body);
      final teams = jsonData["teams"];
      print("Veri alınıyor: $url");
      print("Cevap kodu: ${cevap.statusCode}");
      if (teams != null && teams.isNotEmpty) {
        return Takim.fromJson(teams[0]);
      }
    } else {
      return null;
    }
  }

  Future<void> TumTakimlar() async {
    List<Takim> gelenTakimlar = [];
    for (var url in urlListesi) {
      var takim = await takimGetir(url);
      if (takim != null) {
        gelenTakimlar.add(takim);
      }
    }

    setState(() {
      takimListe = gelenTakimlar;
    });
  }

  @override
  void initState() {
    super.initState();
    urlDoldur();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          takimListe.isEmpty
              ? Center(
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
                        'Serie A Takimları Yükleniyor...',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              )
              : ListView.builder(
                itemCount: takimListe.length,
                itemBuilder: (context, index) {
                  var takim = takimListe[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      shape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      tileColor: Colors.purple,
                      leading:
                          takim.armasi != null && takim.armasi!.isNotEmpty
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Detaysayfasi(takim),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
    );
  }
}

class Ligue1 extends StatefulWidget {
  const Ligue1({super.key});

  @override
  State<Ligue1> createState() => _Ligue1State();
}

class _Ligue1State extends State<Ligue1> {
  List<String> urlListesi = [];
  List<Takim> gelenTakimlar = [];
  List<Takim> takimListe = [];

  var superligUrl = VeriAl();

  Future<void> urlDoldur() async {
    var veri = await superligUrl.siflandirma("6");
    for (var yaz in veri) {
      urlListesi.add(yaz.url); // Takım urlleri alındı
    }
    print(urlListesi);

    await TumTakimlar();
  }

  Future<Takim?> takimGetir(String url) async {
    final cevap = await http.get(Uri.parse(url));
    if (cevap.statusCode == 200) {
      final jsonData = json.decode(cevap.body);
      final teams = jsonData["teams"];
      print("Veri alınıyor: $url");
      print("Cevap kodu: ${cevap.statusCode}");
      if (teams != null && teams.isNotEmpty) {
        return Takim.fromJson(teams[0]);
      }
    } else {
      return null;
    }
  }

  Future<void> TumTakimlar() async {
    List<Takim> gelenTakimlar = [];
    for (var url in urlListesi) {
      var takim = await takimGetir(url);
      if (takim != null) {
        gelenTakimlar.add(takim);
      }
    }

    setState(() {
      takimListe = gelenTakimlar;
    });
  }

  @override
  void initState() {
    super.initState();
    urlDoldur();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          takimListe.isEmpty
              ? Center(
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
                        'Ligue 1 Takimları Yükleniyor...',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              )
              : ListView.builder(
                itemCount: takimListe.length,
                itemBuilder: (context, index) {
                  var takim = takimListe[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      shape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      tileColor: Colors.purple,
                      leading:
                          takim.armasi != null && takim.armasi!.isNotEmpty
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Detaysayfasi(takim),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
    );
  }
}
