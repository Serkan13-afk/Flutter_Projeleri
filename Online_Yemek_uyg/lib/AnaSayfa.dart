import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gosteris/Siparisler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'YiyecekVeIcecek.dart';
import 'YiyecekVeIcecekCevap.dart';
import 'DetaySayfasi.dart';

class Anasayfa extends StatefulWidget {
  const Anasayfa({super.key});

  @override
  State<Anasayfa> createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> with TickerProviderStateMixin {
  Set<int> seciliUrunler = {};
  File? profiledosyasi;

  late AnimationController animationController;
  late Animation<double> animationDegerleri;

  Future<void> resimSec() async {
    ImagePicker picker = ImagePicker();
    XFile? secilen = await picker.pickImage(source: ImageSource.gallery);
    if (secilen != null) {
      setState(() {
        profiledosyasi = File(secilen.path);
      });
    }
  }

  void profilResmeTiklandi() {
    if (profiledosyasi != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (_) => Scaffold(
                appBar: AppBar(
                  title: Shimmer.fromColors(
                    baseColor: Colors.black,
                    highlightColor: Colors.white,
                    child: Text(
                      "Profil Fotoğrafı",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                body: PhotoView(imageProvider: FileImage(profiledosyasi!)),
              ),
        ),
      );
    } else {
      resimSec();
    }
  }

  List<YiyecekVeIcecek> parseVeri(String cevap) {
    return YiyecekVeIcecekCevap.fromJson(json.decode(cevap)).besinlerListesi;
  }

  Future<List<YiyecekVeIcecek>> tumveriyiAl() async {
    var url = Uri.parse("http://10.0.2.2/YiyeceklerVeIcecekler/tumveriler.php");
    var cevap = await http.get(url);
    if (cevap.statusCode == 200) {
      return parseVeri(cevap.body);
    } else {
      throw Exception("Veri alınamadı: ${cevap.statusCode}");
    }
  }

  Future<List<YiyecekVeIcecek>> filtrele(String tur) async {
    List<YiyecekVeIcecek> tumVeriler = await tumveriyiAl();
    return tumVeriler.where((veri) => veri.tur.trim() == tur.trim()).toList();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  Widget urunGridi(Future<List<YiyecekVeIcecek>> futureVeriler) {
    return FutureBuilder<List<YiyecekVeIcecek>>(
      future: futureVeriler,
      builder: (context, kontrol) {
        if (kontrol.connectionState == ConnectionState.waiting) {
          return SizedBox(
            height: 200,
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (kontrol.hasError) {
          return SizedBox(
            height: 200,
            child: Center(child: Text("Hata oluştu")),
          );
        } else if (!kontrol.hasData || kontrol.data!.isEmpty) {
          return SizedBox(height: 200, child: Center(child: Text("Veri yok")));
        }

        var veriler = kontrol.data!;
        return SizedBox(
          height: 250,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: veriler.length,
            itemBuilder: (context, index) {
              var veri = veriler[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Detaysayfasi(veri)),
                  );
                },
                child: Card(
                  elevation: 10,
                  shadowColor: Colors.blue,
                  margin: EdgeInsets.all(15),
                  child: Container(
                    width: 150,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Image.network(
                            "${veri.resim_url}",
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 1,
                          right: 2,
                          child: IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.touch_app_outlined,
                              color: Colors.black,
                              size: 30,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyanAccent,
        title: Align(
          alignment: Alignment.center,
          child: Shimmer.fromColors(
            baseColor: Colors.black,
            highlightColor: Colors.white,
            child: Text(
              "Ana Sayfa",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                "Serkan Topbaşı",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              accountEmail: Text(
                "serkan@email.com",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
              currentAccountPicture: GestureDetector(
                onTap: () {
                  profilResmeTiklandi();
                },
                child: CircleAvatar(
                  backgroundImage:
                      profiledosyasi != null
                          ? FileImage(profiledosyasi!)
                          : AssetImage("resimler/pp.jpg"),
                ),
              ),
              decoration: BoxDecoration(color: Colors.cyanAccent),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text("Ana Sayfa"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.history),
              title: Text("Siparişlerim"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Sepet()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("Ayarlar"),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Ayarlar henüz eklenmedi.")),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Çıkış"),
              onTap: () {
                showDialog(
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        title: Text("Çıkış Yap"),
                        content: Text("Uygulamadan çıkmak istiyor musunuz?"),
                        actions: [
                          TextButton(
                            child: Text("İptal"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),

                          TextButton(
                            child: Text("Çık"),
                            onPressed: () {
                              SystemNavigator.pop(); // Buraya çıkış mantığı eklersin (örn. Firebase auth varsa signOut)
                            },
                          ),
                        ],
                      ),
                );
              },
            ),
          ],
        ),
      ),

      backgroundColor: Colors.black,
      body: ListView(
        children: [
          SizedBox(height: 50),
          Center(
            child: Shimmer.fromColors(
              baseColor: Colors.white,
              highlightColor: Colors.green,
              child: Text(
                "Ürünler",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(height: 30),
          Shimmer.fromColors(
            baseColor: Colors.white,
            highlightColor: Colors.blueAccent,
            child: Center(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Text(
                    "Burger Çeşitleri",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
            ),
          ),
          urunGridi(filtrele("1")),
          Shimmer.fromColors(
            baseColor: Colors.white,
            highlightColor: Colors.blueAccent,
            child: Center(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Text(
                    "Pizza Çeşitleri",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
          urunGridi(filtrele("2")),
          Shimmer.fromColors(
            baseColor: Colors.white,
            highlightColor: Colors.blueAccent,
            child: Center(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Text(
                    "Yemek Çeşitleri",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
          urunGridi(filtrele("3")),
          Shimmer.fromColors(
            baseColor: Colors.white,
            highlightColor: Colors.blueAccent,
            child: Center(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Text(
                    "Çorba Çeşitleri",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
          urunGridi(filtrele("4")),
          Shimmer.fromColors(
            baseColor: Colors.white,
            highlightColor: Colors.blueAccent,
            child: Center(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Text(
                    "Tatlı Çeşitleri",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
          urunGridi(filtrele("5")),
          Shimmer.fromColors(
            baseColor: Colors.white,
            highlightColor: Colors.blueAccent,
            child: Center(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Text(
                    "İçecek Çeşitleri",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
          urunGridi(filtrele("6")),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
