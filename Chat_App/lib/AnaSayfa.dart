import 'package:chatapp13/KareKodSayfa.dart';
import 'package:chatapp13/MesajSayfasi.dart';
import 'package:chatapp13/Providerler.dart';
import 'package:chatapp13/GrupSayfa.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'generated/l10n.dart';

class Anasayfa extends StatefulWidget {
  const Anasayfa({super.key});

  @override
  State<Anasayfa> createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> with WidgetsBindingObserver {
  // online olup olmamam durumu için değişiklikten haber verir

  late TextEditingController aramaController;
  var yuklendiMi;

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Map<String, dynamic> kisimap = {};

  Future<void> mailControl() async {
    final mailIcerik = Uri(
      scheme: "mailto",
      path: "infoapp686@gmail.com", //mail adresi
      queryParameters: {
        'subject': S.of(context).mail_konu,
        'body': S.of(context).mail_dusunce,
      },
    );
    if (await canLaunchUrl(mailIcerik)) {
      // yukarıdaki nesneye bakıyor sorun varmı yoksa gir
      await launchUrl(
        mailIcerik,
        mode: LaunchMode.externalApplication,
      ); // sonrada bilgileri al gönder
    } else {
      print("Mail gönderilemiyor");
    }
  }

  String mesajOdaId(String kisi1email, String kisi2email) {
    if (kisi1email[0].toLowerCase().codeUnits[0] >
        kisi2email.toLowerCase().codeUnits[0]) {
      return "$kisi1email$kisi2email";
    }
    return "$kisi2email$kisi1email";
  }

  Future<void> kisiArama(String kisi) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    await firestore
        .collection('users')
        .where("name", isEqualTo: kisi)
        .get()
        .then((value) {
          if (value.docs.isNotEmpty) {
            setState(() {
              kisimap = value.docs[0].data();
              yuklendiMi = true;
              print("Aranan kişi:$kisimap");
            });
          } else {
            setState(() {
              kisimap = {};
              yuklendiMi = false;
            });

            print("Kişi bulanamdım");
          }
        });
  }

  Future<void> kisiOnlineMiMetodu(String status) async {
    await firestore.collection("users").doc(auth.currentUser!.uid).update({
      "status": status,
    });
  }

  @override
  void initState() {
    super.initState();
    aramaController = TextEditingController();
    WidgetsBinding.instance.addObserver(this);
    kisiOnlineMiMetodu("Cevrim ici");
  }

  @override
  void dispose() {
    aramaController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Duraklama ve değişiklik durumlarıda tetiklenir
    if (state == AppLifecycleState.resumed) {
      // Çevrim içi
      kisiOnlineMiMetodu("Cevrim ici");
    } else {
      // Çevrim dışı
      kisiOnlineMiMetodu("Cevrim disi");
    }

    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DilOkuma>(
      builder: (context, dilNesne, child) {
        return Consumer<TemaOkuma>(
          builder: (context, temaNesne, child) {
            return Scaffold(
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(90),
                child: AppBar(
                  actions: [
                    PopupMenuButton<String>(
                      color: Colors.tealAccent,
                      icon: Icon(
                        Icons.more_vert,
                        color:
                            temaNesne.temaOku() ? Colors.black : Colors.white,
                      ),
                      onSelected: (String value) {
                        if (value == "ayarlar") {
                          // Sayfalarım Falan Gelecek
                        } else if (value == "karekod") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Karekodsayfa(),
                            ),
                          );
                        } else if (value == "geribildirim") {
                          mailControl();
                        } else if (value == "bilgilendirme") {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                shape: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                    color: Colors.deepPurple[800]!,
                                    width: 1.5,
                                  ),
                                ),
                                title: Text(S.of(context).bilgilendirme),
                                content: SizedBox(
                                  height: 500,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,

                                      children: [
                                        Text("""
${S.of(context).bilgilendirme_icerik}

                                      """),
                                        SizedBox(height: 20),
                                      ],
                                    ),
                                  ),
                                ),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                     S.of(context).anladim,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.pink,
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                      itemBuilder:
                          (BuildContext context) => <PopupMenuEntry<String>>[
                            PopupMenuItem<String>(
                              value: "ayarlar",
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    S.of(context).ayarlar,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  SizedBox(width: 12),
                                  Icon(Icons.settings, color: Colors.black),
                                ],
                              ),
                            ),

                            PopupMenuItem<String>(
                              value: 'karekod',
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    S.of(context).karekod,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  SizedBox(width: 12),
                                  Icon(Icons.qr_code_2, color: Colors.black),
                                ],
                              ),
                            ),
                            PopupMenuItem<String>(
                              value: 'geribildirim',
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    S.of(context).geribildirim,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  SizedBox(width: 12),
                                  Icon(
                                    Icons.settings_backup_restore,
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: "bilgilendirme",
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    S.of(context).bilgilendirme,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  SizedBox(width: 12),
                                  Icon(
                                    Icons.info_outline_rounded,
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                            ),
                          ],
                    ),
                  ],
                  shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  title: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      S.of(context).hizlimesaj,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color:
                            temaNesne.temaOku() ? Colors.black : Colors.white,
                      ),
                    ),
                  ),
                  backgroundColor:
                      temaNesne.temaOku() ? Colors.white : Colors.black,
                ),
              ),
              body: SingleChildScrollView(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 10),
                      SizedBox(
                        width: 360,
                        height: 50,
                        child: TextField(
                          controller: aramaController,
                          onChanged: (value) {
                            yuklendiMi = false;
                            if (value.isNotEmpty) {
                              kisiArama(
                                (value[0].toUpperCase() +
                                        value.substring(1).toLowerCase())
                                    .trim(),
                              );
                            }
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            label: Text(
                              S.of(context).kisiara,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.indigo,
                          ),
                        ),
                      ),
                      SizedBox(height: 50),
                      yuklendiMi == null
                          ? SizedBox()
                          : yuklendiMi
                          ? ListTile(
                            shape: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            onTap: () {
                              String odaId = mesajOdaId(
                                auth.currentUser!.email ?? "",
                                // null ise boş string
                                kisimap["email"] as String, // dynamic → String
                              );
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => Mesajsayfasi(kisimap, odaId),
                                ),
                              );
                            },
                            leading: Icon(Icons.radio_button_checked),
                            trailing: Icon(Icons.message_outlined),
                            title: Text(
                              kisimap["name"],
                              style: TextStyle(color: Colors.black),
                            ),
                            subtitle: Text(
                              kisimap["email"],
                              style: TextStyle(color: Colors.black54),
                            ),
                            tileColor: Colors.tealAccent,
                          )
                          : Lottie.asset("iconlar/yukleniyorMu.json"),
                    ],
                  ),
                ),
              ),
              floatingActionButton: SizedBox(
                width: 60,
                height: 60,
                child: FloatingActionButton(
                  backgroundColor: Colors.deepPurple,
                  child: Icon(Icons.group_add_outlined, size: 30),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Grupsayfa()),
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
