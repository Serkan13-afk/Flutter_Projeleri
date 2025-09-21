import 'package:chatapp13/Providerler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:chatapp13/generated/l10n.dart';


class Grupuyeekle extends StatefulWidget {
  late String grupIsmi;
  late String grupId;
  late List uyeler;

  Grupuyeekle({
    required this.uyeler,
    required this.grupIsmi,
    required this.grupId,
  });

  @override
  State<Grupuyeekle> createState() => _GrupuyeekleState();
}

class _GrupuyeekleState extends State<Grupuyeekle> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  var listedeEklenecekKisiVarMi = false;
  bool?
  yuklendiMi; // null = arama yapılmadı, false = bulunamadı, true = bulundu
  late TextEditingController uyeEkle;
  List<Map<String, dynamic>> uyemap = [];
  Map<String, dynamic> kisimap = {};

  late List kisiListesi;

  Future<void> kisiArama(String kisi) async {
    // Text field ile kişiyi arıyoruz
    setState(() {
      yuklendiMi = null; // yükleniyor
    });

    var snapshot =
        await firestore
            .collection('users')
            .where("name", isEqualTo: kisi)
            .get();

    if (snapshot.docs.isNotEmpty) {
      // kişi varsa ekelnecek listeye ekle
      setState(() {
        kisimap = snapshot.docs[0].data();
        yuklendiMi = true;
        print("Aranan kişi: $kisimap");
      });
    } else {
      setState(() {
        kisimap = {};
        yuklendiMi = false;
      });
      print("Kişi bulunamadı");
    }
  }

  Widget aramaSonucu() {
    if (yuklendiMi == null) {
      return const SizedBox(); // hiç arama yapılmadı
    } else if (yuklendiMi == true) {
      return Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListTile(
          shape: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          tileColor: Colors.green[700],
          leading: const Icon(Icons.person, color: Colors.white),
          title: Text(
            kisimap["name"] ?? "",
            style: const TextStyle(color: Colors.white),
          ),
          subtitle: Text(
            kisimap["email"] ?? "",
            style: const TextStyle(color: Colors.white),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
              listedeEklenecekKisiVarMi = false; // burada resetle

              for (int i = 0; i < uyemap.length; i++) {
                if (uyemap[i]["uid"] == kisimap["uid"]) {
                  listedeEklenecekKisiVarMi = true;
                }
              }

              if (!listedeEklenecekKisiVarMi) {
                // Kişi listede yoksa ekle

                uyemap.add({
                  "name": kisimap["name"],
                  "email": kisimap["email"],
                  "uid": kisimap["uid"],
                  "isAdmin": false,
                });

                firestore.collection("groups").doc(widget.grupId).update({
                  "members": uyemap,
                });
                firestore
                    .collection("users")
                    .doc(auth.currentUser!.uid)
                    .collection("groups")
                    .doc(widget.grupId)
                    .set({"name": widget.grupIsmi, "id": widget.grupId});
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    duration: const Duration(milliseconds: 2000),
                    backgroundColor: Colors.grey[800],
                    content:  Text(
                      S.of(context).kisieklendi,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                );
              } else {
                print("snakbara girecek");
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    duration: const Duration(milliseconds: 2000),
                    backgroundColor: Colors.grey[800],
                    content:  Text(
                      S.of(context).tikladiginkisi_grupta,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                );
              }
              uyeEkle.clear();
            },
          ),
        ),
      );
    } else {
      return Lottie.asset("iconlar/yukleniyorMu.json", width: 150, height: 150);
    }
  }

  @override
  void initState() {
    uyeEkle = TextEditingController();
    kisiListesi = widget.uyeler;
    uyemap = List<Map<String, dynamic>>.from(widget.uyeler);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TemaOkuma>(
      builder: (context, temaNesne, child) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(100),
            child: AppBar(
              shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              backgroundColor:
                  temaNesne.temaOku() ? Colors.white : Colors.black,
              title: Text(
                " ${widget.grupIsmi} ${S.of(context).grubuna_kisiekle}",
                style: TextStyle(
                  color: temaNesne.temaOku() ? Colors.black : Colors.white,
                ),
              ),
            ),
          ),

          body: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 360,
                    height: 60,
                    child: TextField(
                      controller: uyeEkle,
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          kisiArama(
                            (value[0].toUpperCase() +
                                    value.substring(1).toLowerCase())
                                .trim(),
                          );
                        }
                      },
                      decoration:  InputDecoration(
                        hintText: S.of(context).kisi_ekle,
                        hintStyle: TextStyle(color: Colors.black),
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Colors.pink,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  aramaSonucu(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
