import 'package:chatapp13/AnaSayfa.dart';
import 'package:chatapp13/Providerler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:chatapp13/generated/l10n.dart';

class GrupEkleDetay extends StatefulWidget {
  final List<Map<String, dynamic>> uyemap;

  GrupEkleDetay(this.uyemap, {super.key});

  @override
  State<GrupEkleDetay> createState() => _GrupEkleDetayState();
}

class _GrupEkleDetayState extends State<GrupEkleDetay>
    with TickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController animationController;
  late TextEditingController grupAdi;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> grupOlustur() async {
    String groupId = const Uuid().v1();

    // Grup kaydı
    await firestore.collection("groups").doc(groupId).set({
      "members": widget.uyemap,
      "id": groupId,
      "name": grupAdi.text,
      "createdAt": FieldValue.serverTimestamp(),
    });

    await firestore.collection("groups").doc(groupId).collection("chats").add({
      "message": "${auth.currentUser!.displayName} bu grubu oluşturdu",
      "type": "notify",
      "time": FieldValue.serverTimestamp(),
    });

    // Her kullanıcıya grubu ekle
    for (var i = 0; i < widget.uyemap.length; i++) {
      String uid = widget.uyemap[i]["uid"];

      await firestore
          .collection("users")
          .doc(uid)
          .collection("groups")
          .doc(groupId)
          .set({"name": grupAdi.text, "id": groupId});
    }
  }

  @override
  void initState() {
    super.initState();

    grupAdi = TextEditingController();

    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2500),
    );

    animation = Tween(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: animationController, curve: Curves.linear),
    )..addListener(() {
      setState(() {});
    });

    animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    animationController.dispose();

    super.dispose();
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
                S.of(context).grup_olustur,
                style: TextStyle(
                  color: temaNesne.temaOku() ? Colors.black : Colors.white,
                ),
              ),
            ),
          ),
          body: Center(
            child: Column(
              children: [
                SizedBox(height: 100),
                SizedBox(
                  width: 350,
                  child: TextField(
                    maxLength: 25,
                    controller: grupAdi,
                    decoration:  InputDecoration(
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Colors.pink,
                      labelText: S.of(context).grup_adi,
                    ),
                  ),
                ),
                Transform.scale(
                  scale: animation.value,
                  child: SizedBox(
                    width: 170,
                    child: ElevatedButton(
                      onPressed: () {
                        if (grupAdi.text.trim().isNotEmpty) {
                          grupOlustur();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => Anasayfa()),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              duration: Duration(milliseconds: 2000),
                              backgroundColor: Colors.grey[800],
                              content: Text(
                                S.of(context).grup_basarilisekilde_olusturuldu,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        }
                        else{
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              duration: Duration(milliseconds: 2000),
                              backgroundColor: Colors.grey[800],
                              content: Text(
                                S.of(context).grupadi_alani,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        }
                      },
                      child: Text(
                        S.of(context).grup_olustur,
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.greenAccent,
                      ),
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
