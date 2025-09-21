import 'package:chatapp13/GrupEkleDetay.dart';
import 'package:chatapp13/Providerler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'generated/l10n.dart';


class GrupEkle extends StatefulWidget {
  const GrupEkle({super.key});

  @override
  State<GrupEkle> createState() => _GrupEkleState();
}

class _GrupEkleState extends State<GrupEkle> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  var listedeEklenecekKisiVarMi = false;
  bool?
  yuklendiMi; // null = arama yapılmadı, false = bulunamadı, true = bulundu
  late TextEditingController uyeEkle;
  List<Map<String, dynamic>> uyemap = [];
  Map<String, dynamic> kisimap = {};

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

  Future<void> kisiyiDetaylariileAl() async {
    // Bu kişi direkt grup yöneticisi olarak alınacak ve init fon içine yazılır
    await firestore.collection("users").doc(auth.currentUser!.uid).get().then((
      map,
    ) {
      setState(() {
        uyemap.add({
          "name": map["name"],
          "email": map["email"],
          "uid": map["uid"],
          "isAdmin": true,
        });
      });
    });
  }

  Widget kayitliOlan() {
    // Bunlar işlemler sonıcında kayıtlı kalan lar ve en üstte olanalar
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: uyemap.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(10),
          child: ListTile(
            shape: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            tileColor: Colors.grey[800],
            leading: const Icon(Icons.person_outline, color: Colors.white),
            title: Text(
              "  ${uyemap[index]["name"]}",
              style: const TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              "  ${uyemap[index]["email"]}",
              style: const TextStyle(color: Colors.white),
            ),
            trailing: IconButton(
              onPressed: () {
                if (uyemap[index]["uid"] != auth.currentUser!.uid) {
                  setState(() {
                    uyemap.removeAt(index);
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.grey[800],
                      duration: Duration(milliseconds: 2000),
                      content: Text(
                        S.of(context).yoneticiyigrptan_silemezsin,
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  );

                  return;
                }
              },
              icon: Icon(Icons.cancel_outlined, color: Colors.red),
            ),
          ),
        );
      },
    );
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
              for (int i = 0; i < uyemap.length; i++) {
                if (uyemap[i]["uid"] == kisimap["uid"]) {
                  listedeEklenecekKisiVarMi = true;
                }
              }

              if (!listedeEklenecekKisiVarMi) {
                // Kişi listede yoksa ekle
                setState(() {
                  uyemap.add({
                    "name": kisimap["name"],
                    "email": kisimap["email"],
                    "uid": kisimap["uid"],
                    "isAdmin": false,
                  });
                });
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
    super.initState();
    uyeEkle = TextEditingController();
    kisiyiDetaylariileAl();
  }

  @override
  void dispose() {
    uyeEkle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TemaOkuma>(
      builder: (context, temaNesne, child) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(100),
            child: AppBar(
              backgroundColor:
                  temaNesne.temaOku() ? Colors.white : Colors.black,
              shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              title: Text(
                S.of(context).grup_ekle,
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
                  const SizedBox(height: 15),
                  kayitliOlan(),
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
                        hintText: S.of(context).kisiara,
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
          floatingActionButton:
              uyemap.length <= 2
                  ? SizedBox()
                  : FloatingActionButton(
                    backgroundColor: Colors.deepPurple,
                    tooltip: S.of(context).kisi_ekle,
                    child: const Icon(Icons.done, color: Colors.white),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GrupEkleDetay(uyemap),
                        ),
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GrupEkleDetay(uyemap),
                        ),
                      );

                      // Burada Firestore'a gruba ekleme yapılabilir
                      print("Grup üyeleri: $uyemap");
                    },
                  ),
        );
      },
    );
  }
}
