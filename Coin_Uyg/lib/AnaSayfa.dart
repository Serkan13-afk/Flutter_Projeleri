import 'dart:io';
import 'package:photo_view/photo_view.dart';
import 'package:shimmer/shimmer.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kripto_uyg/Kisi.dart';

class Anasayfa extends StatefulWidget {
  late Kisi kriptoVerileri;


  Anasayfa(this.kriptoVerileri);

  @override
  State<Anasayfa> createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {
  File? profiledosyasi;

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
              (_) =>
              Scaffold(
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      backgroundColor: Colors.cyan,

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                "${widget.kriptoVerileri.ad} ${widget.kriptoVerileri.soyad}",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              accountEmail: Text(
                "${widget.kriptoVerileri.mail}",
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
                      : AssetImage("resimler/indir.png"),
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
              title: Text("Ayarlar"),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Ayarlar henüz eklenmedi.")),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.info_outline),
              title: Text("Hakkında"),
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
                      (context) =>
                      AlertDialog(
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
                              SystemNavigator
                                  .pop(); // Buraya çıkış mantığı eklersin (örn. Firebase auth varsa signOut)
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
      body: Center(
        child: Text(
          "Ana Sayfa İçeriği",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
