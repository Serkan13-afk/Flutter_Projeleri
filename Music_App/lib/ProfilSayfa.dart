import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:muzikcalar_app/DilSinif.dart';
import 'package:muzikcalar_app/main.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:muzikcalar_app/generated/l10n.dart';

class Profilsayfa extends StatefulWidget {
  late User user;

  Profilsayfa(this.user);

  @override
  State<Profilsayfa> createState() => _ProfilsayfaState();
}

class _ProfilsayfaState extends State<Profilsayfa> {
  final prefs = SharedPreferences.getInstance();
  Locale locale = const Locale("tr");
  FirebaseAuth auth = FirebaseAuth.instance;
  final ImagePicker imagePicker = ImagePicker();
  File? resim;

  @override
  void initState() {
    super.initState();
    yuklenenResmiGetir();
  }

  void dildegis(String dil_kod) {
    DilSinif.dilKayit(dil_kod);
    setState(() {});
  }

  void mesaj(String gelenyazi) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Sistem dili ${gelenyazi} olarak ayarlandı !\nYeni dilde uygulamayı denemek için tekrar uygulamaya giriş yapın ",
        ),
      ),
    );
  }

  Future<void> cikisYap() async {
    try {
      await auth.signOut();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Çıkış işlmeinde sorun oluştu !")));
    }
  }

  Future<void> resimSec(ImageSource source) async {
    final secilen = await imagePicker.pickImage(source: source);
    if (secilen != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("profilfoto", secilen.path);

      setState(() {
        resim = File(secilen.path);
      });
    }
  }

  Future<void> resimSil() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("profilfoto");

    setState(() {
      resim = null;
    });
  }

  Future<void> yuklenenResmiGetir() async {
    final prefs = await SharedPreferences.getInstance();
    final yol = prefs.getString('profilfoto');
    if (yol != null && File(yol).existsSync()) {
      setState(() {
        resim = File(yol);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var genislik = MediaQuery.of(context).size.width;
    var yukseklik = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xfffff100), Color(0xff0098ff), Color(0xff07ff2a)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Dairesel profil alanı
                    Container(
                      width: genislik * 0.5,
                      height: genislik * 0.5,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.4),
                            blurRadius: 10,
                            offset: const Offset(2, 3),
                          ),
                        ],
                        image: resim != null
                            ? DecorationImage(
                                image: FileImage(resim!),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: resim == null
                          ? const Icon(
                              Icons.person_outline,
                              size: 120,
                              color: Colors.grey,
                            )
                          : null,
                    ),

                    // Kamera ikonu sağ alt köşede
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,

                            builder: (context) => _secenekMenusu(),
                          );
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue,
                          ),
                          padding: const EdgeInsets.all(8),
                          child: const Icon(
                            Icons.camera_alt_outlined,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: yukseklik * 0.1),
                listTile("${widget.user.displayName}", Icons.person),
                SizedBox(height: yukseklik * 0.015),
                listTile("${widget.user.email}", Icons.mail_outline_outlined),
                SizedBox(height: yukseklik * 0.015),
                listTile("Kare Kod", Icons.qr_code_2_rounded),
                SizedBox(height: yukseklik * 0.015),
                listTile("Uygulama dili", Icons.language),
                SizedBox(height: yukseklik * 0.015),

                listTile("Çıkış", Icons.logout),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget listTile(String icerik, IconData icon) {
    var genislik = MediaQuery.of(context).size.width;
    var yukseklik = MediaQuery.of(context).size.height;
    return Container(
      width: genislik * 0.90,
      height: yukseklik * 0.07,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black, blurRadius: 5, offset: Offset(2, 3)),
        ],
      ),
      child: ListTile(
        onTap: () {
          if (icerik == "Kare Kod") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => KarekodSayfa()),
            );
          } else if (icerik == "Çıkış") {
            showModalBottomSheet(
              context: context,
              builder: (context) => cikis(),
            );
          } else if (icerik == "Uygulama dili") {
            showModalBottomSheet(
              context: context,
              builder: (context) => secenekDil(),
            );
          }
        },
        contentPadding: EdgeInsets.only(left: 20, top: 5),
        leading: Icon(icon, size: 40),
        title: Text(
          "${icerik}",
          style: TextStyle(fontStyle: FontStyle.italic, fontSize: 20),
        ),
      ),
    );
  }

  // 📸 Alt menü (kamera / galeri seçimi)
  Widget _secenekMenusu() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Center(
            child: Text(
              "Bir Yöntem Seçiniz",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.photo_camera),
            title: const Text("Kameradan çek"),
            onTap: () {
              Navigator.pop(context);
              resimSec(ImageSource.camera);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text("Galeriden seç"),
            onTap: () {
              Navigator.pop(context);
              resimSec(ImageSource.gallery);
            },
          ),
          if (resim != null)
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text("Fotoğrafı sil"),
              onTap: () {
                Navigator.pop(context);
                resimSil();
              },
            ),
        ],
      ),
    );
  }

  Widget cikis() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Center(
            child: Text(
              "Çıkış Yapınız",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: () {
              cikisYap();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MyHomePage()),
              );
            },
            child: Text(
              "${S.of(context).logout}",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pink,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget secenekDil() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        // 👈 Bottom sheet yüksekliğini içeriğe göre ayarlar
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: ListTile(
              leading: Icon(
                Icons.language_sharp,
                color: Colors.green,
                size: 40,
              ),
              title: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Dil Seçiniz",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Divider(),
          ListTile(
            title: const Text("🇹🇷   Türkçe", style: TextStyle(fontSize: 22)),
            onTap: () {
              dildegis("tr");
              mesaj("Türkçe");

              Navigator.pop(context);
              // burada dil ayarı işlemi yapılabilir
            },
          ),
          ListTile(
            title: const Text(
              "🇬🇧   İngilizce",
              style: TextStyle(fontSize: 22),
            ),
            onTap: () {
              dildegis("en");
              mesaj("İngilizce");

              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text("🇩🇪   Almanca", style: TextStyle(fontSize: 22)),
            onTap: () {
              dildegis("de");
              mesaj("Almanca");

              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text(
              "🇫🇷   Fransızca",
              style: TextStyle(fontSize: 22),
            ),
            onTap: () {
              dildegis("fr");
              mesaj("Fransızca");
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class KarekodSayfa extends StatelessWidget {
  const KarekodSayfa({super.key});

  final karekodurl = "";

  @override
  Widget build(BuildContext context) {
    var genislik = MediaQuery.of(context).size.width;
    var yukseklik = MediaQuery.of(context).size.height;
    return Container(
      width: genislik,
      height: yukseklik,
      decoration: BoxDecoration(color: Colors.black),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            QrImageView(
              data: karekodurl,
              version: QrVersions.auto,
              size: 300,
              foregroundColor: Colors.white,
              gapless: true,
            ),
          ],
        ),
      ),
    );
  }
}
