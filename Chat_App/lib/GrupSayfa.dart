import 'package:chatapp13/GrupEkle.dart';
import 'package:chatapp13/GrupMesajSayfa.dart';
import 'package:chatapp13/Providerler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:chatapp13/generated/l10n.dart';


class Grupsayfa extends StatefulWidget {
  const Grupsayfa({super.key});

  @override
  State<Grupsayfa> createState() => _GrupsayfaState();
}

class _GrupsayfaState extends State<Grupsayfa> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var yuklendiMi = true;
  var grupBosMu = true;
  List grupListesi = [];

  Future<void> grupGetir() async {
    String uid = auth.currentUser!.uid;
    await firestore
        .collection("users")
        .doc(uid)
        .collection("groups")
        .get()
        .then((value) {
          setState(() {
            grupListesi = value.docs;
            yuklendiMi = false;
          });
        });
  }

  @override
  void initState() {
    grupGetir();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TemaOkuma>(
      builder: (context, temaOkuma, child) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(100),
            child: AppBar(
              backgroundColor:
                  temaOkuma.temaOku() ? Colors.white : Colors.black,
              shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => GrupEkle()),
                    );
                  },
                  icon: Icon(
                    Icons.create_outlined,
                    color: temaOkuma.temaOku() ? Colors.black : Colors.white,
                  ),
                ),
              ],
              title: Text(
                S.of(context).gruplarim,
                style: TextStyle(
                  color: temaOkuma.temaOku() ? Colors.black : Colors.white,
                ),
              ),
            ),
          ),
          body:
              grupListesi.isEmpty
                  ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          S.of(context).hicbirgruba_uyedegilsin,
                        ),
                      ],
                    ),
                  )
                  : yuklendiMi
                  ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Lottie.asset("iconlar/yukleniyorMu.json")],
                    ),
                  )
                  : ListView.builder(
                    itemCount: grupListesi.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(5),
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => Grupmesajsayfa(
                                      grupId: grupListesi[index]["id"],
                                      grupIsim: grupListesi[index]["name"],
                                    ),
                              ),
                            );
                          },
                          tileColor: Colors.tealAccent,
                          title: Text(
                            grupListesi[index]["name"],
                            style: TextStyle(color: Colors.black),
                          ),
                          trailing: Icon(
                            Icons.group_add_outlined,
                            color: Colors.black,
                          ),
                          shape: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      );
                    },
                  ),
        );
      },
    );
  }
}
