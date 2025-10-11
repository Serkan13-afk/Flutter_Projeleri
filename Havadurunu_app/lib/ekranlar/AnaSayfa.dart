import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:havadurumu_app/HavaDurumuModel/HavadurumuModel.dart';
import 'package:havadurumu_app/Providerler.dart';
import 'package:havadurumu_app/ekranlar/GrafikSayfa.dart';
import 'package:havadurumu_app/ekranlar/HavaDurumdetay.dart';
import 'package:havadurumu_app/ekranlar/Login.dart';
import 'package:havadurumu_app/servisler/HavaDurumuServis.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import 'KareKodSayfa.dart';

class Anasayfa extends StatefulWidget {
  late User kisi;

  Anasayfa(this.kisi);

  @override
  State<Anasayfa> createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {
  var sehirIsmi;
  late TextEditingController textEditingController;
  List<HavadurumuModel> veriler = [];
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late double genislik = MediaQuery.of(context).size.width;
  late double yukseklik = MediaQuery.of(context).size.width;
  var kayitButtonunabasildiMi = false;

  Future<void> _mailGonder() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'infoapp686@gmail.com', // alıcı adresi
      queryParameters: {
        'subject': 'Flutter Mail',
        'body': 'Merhaba Serkan, Flutter’dan mail gönderiyorum!',
      },
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      throw 'E-posta uygulaması açılamadı!';
    }
  }

  Future<void> sehirAdi() async {
    String sehirIsmi1 = await HavaDurumuServis().konumGetir();
    setState(() {
      sehirIsmi = sehirIsmi1;
    });
  }

  Future<void> konumKayitEtme(String kisiAd, String kayitedilecekSehir) async {
    QuerySnapshot snapshot = await firestore
        .collection("savelocations")
        .doc(widget.kisi.uid)
        .collection("locations")
        .get();

    bool konumVarMi = false;

    snapshot.docs.forEach((doc) {
      if (doc['savecity'] == kayitedilecekSehir) {
        konumVarMi = true; // Aynı şehir bulundu
      }
    });

    if (konumVarMi) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Konum zaten kayıtlı")));

      return;
    }

    await firestore
        .collection("savelocations")
        .doc(widget.kisi.uid)
        .collection("locations")
        .add({
          "name": kisiAd,
          "savecity": kayitedilecekSehir,
          "timestamp": FieldValue.serverTimestamp(),
        });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Konum başarılı bir şeklilde kayıtlı listesine eklendi"),
      ),
    );
  }

  Widget listIlkeleman() {
    if (veriler.isEmpty) {
      return Consumer<TemaOkuma>(
        builder: (context, temaNesne, child) {
          return Center(
            child: Shimmer.fromColors(
              baseColor: temaNesne.temaOku() ? Colors.black38 : Colors.white30,
              highlightColor: temaNesne.temaOku() ? Colors.black : Colors.white,
              child: Card(
                margin: EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // Card boyutunu içerikle sınırla
                      children: [],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
    }

    HavadurumuModel veri = veriler[0];
    return ListView(
      shrinkWrap: true,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Havadurumdetay(veri, sehirIsmi),
              ),
            );
          },
          child: Card(
            color: Colors.cyan,
            margin: EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                // Card boyutunu içerikle sınırla
                children: [
                  Image.network(veri.ikon, height: 100),
                  SizedBox(height: 10),
                  Text("${veri.tarih} / Bugün", textAlign: TextAlign.center),
                  SizedBox(height: 5),
                  Align(
                    alignment: Alignment.center,
                    child: Text("Derece :${veri.derece}° C"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget tumeleman() {
    if (veriler.isEmpty) {
      return Consumer<TemaOkuma>(
        builder: (context, temaNesne, child) {
          return Center(
            child: Shimmer.fromColors(
              baseColor: temaNesne.temaOku() ? Colors.black38 : Colors.white30,
              highlightColor: temaNesne.temaOku() ? Colors.black : Colors.white,

              child: Card(
                margin: EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: veriler.length,
      itemBuilder: (context, index) {
        HavadurumuModel veri = veriler[index];
        return SizedBox(
          width: 250, // Card genişliği optimize edildi
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Havadurumdetay(veri, sehirIsmi),
                ),
              );
            },
            child: Card(
              margin: EdgeInsets.all(10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.network(veri.ikon, height: 80, width: 150),
                    SizedBox(height: 10),
                    Text(
                      "${veri.tarih} / ${veri.gun}",
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 5),
                    Align(
                      alignment: Alignment.center,
                      child: Text("Derece :${veri.derece}° C"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> gelenVeriler2() async {
    veriler = await HavaDurumuServis().havadurumuVerileri();

    setState(() {});
  }

  Widget textField() {
    return Container(
      width: double.infinity, // ekran genişliği kadar
      height: 60,
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: textEditingController,
        keyboardType: TextInputType.text,
        onSubmitted: (value) {
          setState(() {
            textEditingController.text = value;
          });
        },
        decoration: InputDecoration(
          hintText: "Şehir girin",
          filled: true,
          fillColor: Colors.pinkAccent,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none, // sadece arka planlı
          ),
          suffixIcon: IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () async {
              String girilenSehir = textEditingController.text.trim();

              if (girilenSehir.isNotEmpty) {
                try {
                  // Loading state
                  setState(() {
                    veriler = []; // Önce listeyi temizle
                  });

                  List<HavadurumuModel> yeniVeriler = await HavaDurumuServis()
                      .havadurumuVerileriSehir(girilenSehir);

                  if (yeniVeriler.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Şehir bulunamadı veya veri alınamadı"),
                      ),
                    );
                    return;
                  }

                  setState(() {
                    veriler = yeniVeriler;
                    sehirIsmi = girilenSehir;
                  });
                } catch (e) {
                  print("Arama hatası: $e");
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Bir hata oluştu: $e")),
                  );
                }
              } else {
                setState(() {
                  veriler = [];
                  gelenVeriler2();
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Lütfen bir şehir adı girin")),
                );
              }
            },
          ),
        ),
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
    sehirAdi().then((_) {
      // dedikki ilk önce konum sonra veriler gelsin
      gelenVeriler2();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TemaOkuma>(
      builder: (context, temaNesne, child) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(100),
            child: AppBar(
              backgroundColor: Colors.lightBlueAccent,
              automaticallyImplyLeading: true,
              title: Align(
                alignment: Alignment.center,
                child: Text("AnaSayfa", style: TextStyle(color: Colors.white)),
              ),
              actions: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: IconButton(
                    onPressed: () {
                      konumKayitEtme("${widget.kisi.displayName}", sehirIsmi);
                    },
                    icon: Icon(Icons.save_outlined, size: 35),
                  ),
                ),
              ],
            ),
          ),
          drawer: Drawer(
            backgroundColor: Colors.blueGrey,
            child: Padding(
              padding: EdgeInsets.zero,
              child: ListView(
                children: [
                  UserAccountsDrawerHeader(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("resimler/drawergorsel.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    accountName: Text(
                      widget.kisi.displayName ?? "Kullanıcı Adı Yok",
                      style: TextStyle(color: Colors.white),
                    ),
                    accountEmail: Text(
                      widget.kisi.email ?? "E-posta Yok",
                      style: TextStyle(color: Colors.white),
                    ),
                    currentAccountPicture: CircleAvatar(
                      backgroundColor: Colors.purple,
                      child: Text(
                        widget.kisi.displayName != null
                            ? widget.kisi.displayName![0].toUpperCase()
                            : "?",
                        style: TextStyle(fontSize: 24, color: Colors.white),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      shape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.tealAccent,
                          width: 1.5,
                        ),
                      ),
                      onTap: () {
                        if (veriler.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Henüz grafik verisi yüklenmedi."),
                            ),
                          );
                          return;
                        }

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Grafiksayfa(veriler),
                          ),
                        );
                      },
                      leading: Icon(Icons.qr_code_2),
                      title: Text("Grafikler"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      shape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.tealAccent,
                          width: 1.5,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => KareKodSayfa(),
                          ),
                        );
                      },
                      leading: Icon(Icons.qr_code_2),
                      title: Text("Kare Kod"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      shape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.tealAccent,
                          width: 1.5,
                        ),
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              shape: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.tealAccent,
                                  width: 1.5,
                                ),
                              ),
                              title: Text("Bilgilendirme"),
                              content: Text(
                                "Mail gönderme sayfasına iletileceksiniz !",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "İptal",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),

                                TextButton(
                                  onPressed: () {
                                    _mailGonder();
                                  },
                                  child: Text(
                                    "Devam",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      leading: Icon(Icons.mail_outline_outlined),
                      title: Text("Mail"),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      shape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.tealAccent,
                          width: 1.5,
                        ),
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              backgroundColor: Colors.grey[800],
                              shape: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.lightBlueAccent,
                                  width: 1.5,
                                ),
                              ),
                              title: Text("Çıkış sayfası"),
                              content: Text(
                                "Çıkmak istediğinize emin misiniz ?",
                              ),
                              actions: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        "İptal",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),

                                    TextButton(
                                      onPressed: () {
                                        auth.signOut();
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => Login(),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        "Onayla",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        );
                      },

                      leading: Icon(Icons.logout),
                      title: Text("Çıkış"),
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: temaNesne.temaOku()
                    ? [Colors.white, Colors.cyanAccent]
                    : [Colors.black, Colors.cyanAccent],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
            child: SingleChildScrollView(
              child: Consumer<TemaOkuma>(
                builder: (context, temaNesne, child) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 20),
                        textField(),
                        SizedBox(height: 10),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 70,
                              width: 220,
                              child: Card(
                                shape: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                color: Colors.white30,
                                margin: EdgeInsets.all(5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(width: 2),
                                    Icon(
                                      Icons.location_on_outlined,
                                      color: Colors.redAccent,
                                      size: 25,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      "$sehirIsmi",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Container(height: 200, child: listIlkeleman()),
                        SizedBox(height: 20),
                        SizedBox(height: 200, child: tumeleman()),
                        SizedBox(height: 50),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

/*

 */
