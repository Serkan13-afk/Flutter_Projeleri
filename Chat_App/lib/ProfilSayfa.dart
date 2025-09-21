import 'package:chatapp13/Providerler.dart';
import 'package:chatapp13/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:chatapp13/generated/l10n.dart';


class Profilsayfa extends StatefulWidget {
  late User? gelenKisi;

  Profilsayfa(this.gelenKisi);

  @override
  State<Profilsayfa> createState() => _ProfilsayfaState();
}

class _ProfilsayfaState extends State<Profilsayfa> {
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<User?> cikis() async {
    try {
      // 1️⃣ Çevrimdışı yap
      if (widget.gelenKisi != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.gelenKisi!.uid)
            .update({'status': "Cevrim disi"});
      }
      await auth.signOut();
      await Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MyApp(oturumAcikmi: false)),
        (route) => false,
      ); // login ekranına git ve önceki ekranı temizle
      print("Çıkış yapıldı");
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TemaOkuma>(
      builder: (context, temaNene, child) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(100),
            child: AppBar(
              shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              backgroundColor: temaNene.temaOku() ? Colors.white : Colors.black,
              title: Align(
                alignment: Alignment.center,
                child: Text(
                  S.of(context).profilsayfasi,
                  style: TextStyle(
                    color: temaNene.temaOku() ? Colors.black : Colors.black,
                    fontSize: 25,
                  ),
                ),
              ),
            ),
          ),
          body: Center(
            child: Column(
              children: [
                SizedBox(height: 50),
                CircleAvatar(
                  backgroundColor:
                      temaNene.temaOku() ? Colors.white : Colors.black,
                  radius: 80,
                  child: ClipOval(child: Image.asset("resimler/prof.png")),
                ),
                SizedBox(height: 30),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "${S.of(context).hosgeldin} , ${widget.gelenKisi!.displayName} !  😊",
                    style: TextStyle(
                      color: temaNene.temaOku() ? Colors.white : Colors.black,
                      fontSize: 20,
                    ),
                  ),
                ),
                SizedBox(height: 20),

                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "${widget.gelenKisi!.email}",
                    style: TextStyle(
                      color: temaNene.temaOku() ? Colors.white : Colors.black,
                      fontSize: 19,
                    ),
                  ),
                ),
                SizedBox(height: 50),
                SizedBox(
                  width: 350,
                  child: Card(
                    shape: OutlineInputBorder(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      borderSide: BorderSide(
                        style: BorderStyle.solid,
                        color: Colors.tealAccent,
                        width: 1.5,
                      ),
                    ),
                    color: Colors.pink,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          S.of(context).cikis,
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                        IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  shape: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.lightBlue,
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(30),
                                      topRight: Radius.circular(30),
                                    ),
                                  ),
                                  title: Text("Çıkış Sayfası"),
                                  content: SizedBox(
                                    height: 250,
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            S.of(context).cikisyapmak_istedigineeminmisin,
                                          ),
                                          SizedBox(height: 50),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              ElevatedButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  S.of(context).iptal,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.lightBlue,
                                                ),
                                              ),
                                              SizedBox(width: 20),
                                              ElevatedButton(
                                                onPressed: () {
                                                  cikis();
                                                },
                                                child: Text(
                                                  S.of(context).onayla,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.lightBlue,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          icon: Icon(Icons.logout),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
