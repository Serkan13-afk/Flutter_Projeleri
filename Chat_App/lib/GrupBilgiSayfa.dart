import 'generated/l10n.dart';
import 'package:chatapp13/GrupUyeEkle.dart';
import 'package:chatapp13/Providerler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Grupbilgisayfa extends StatefulWidget {
  late String groupId; // ✅ Dinamik grup için
  late String groupIsim;

  Grupbilgisayfa({required this.groupId, required this.groupIsim});

  @override
  State<Grupbilgisayfa> createState() => _GrupbilgisayfaState();
}

class _GrupbilgisayfaState extends State<Grupbilgisayfa> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<bool> cikaracakOlanYoneticiMi() async {
    bool kisiYoneticiMi = false;

    DocumentReference groupRef = firestore
        .collection("groups")
        .doc(widget.groupId);
    DocumentSnapshot groupSnap = await groupRef.get(); // await ekledik

    if (groupSnap.exists) {
      List uyeler = List.from(groupSnap["members"]);
      uyeler.forEach((kisi) {
        if (kisi["uid"] == auth.currentUser!.uid) {
          kisiYoneticiMi = kisi["isAdmin"];
        }
      });
    }

    return kisiYoneticiMi;
  }

  // -------------------- Üyeyi admin çıkarırsa --------------------
  Future<void> gruptanCikar(String isim, String uid) async {
    var cevap = await cikaracakOlanYoneticiMi();

    if (cevap) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(S.of(context).kisiyi_gruptancikar),
            content: Text("$isim ${S.of(context).kisiyi_gruptancikarmakistiyormusun}"),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(S.of(context).iptal),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context); // dialogu kapat

                  DocumentReference groupRef = firestore
                      .collection("groups")
                      .doc(widget.groupId);

                  // 1️⃣ Üyeler listesinden sil (güvenli kopya)
                  DocumentSnapshot groupSnap = await groupRef.get();
                  if (groupSnap.exists) {
                    List members = List.from(groupSnap["members"]);
                    members.removeWhere((m) => m["uid"] == uid);
                    await groupRef.update({"members": members});
                  }

                  // 2️⃣ Notify mesajı
                  await groupRef.collection("chats").add({
                    "message": "$isim gruptan çıkarıldı",
                    "type": "notify",
                    "time": FieldValue.serverTimestamp(),
                  });

                  // 3️⃣ Kullanıcının alt koleksiyonundan grup belgesini sil (var mı kontrol et)
                  DocumentReference userGroupRef = firestore
                      .collection("users")
                      .doc(uid)
                      .collection("groups")
                      .doc(widget.groupId);

                  if ((await userGroupRef.get()).exists) {
                    await userGroupRef.delete();
                  }

                  // 4️⃣ SnackBar göster
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("$isim ${S.of(context).kisiyi_gruptancikartiniz}"),
                      ),
                    );
                  }
                },
                child: Text(S.of(context).onayla),
              ),
            ],
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.grey[800],
          duration: Duration(milliseconds: 2000),
          content: Text(
            S.of(context).yoneticidisinda_kimsecikaramaz,
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }
  }

  // -------------------- Kullanıcı kendi ayrılırsa --------------------
  Future<void> gruptanAyril() async {
    String uid = auth.currentUser!.uid; // aktif kullanıcı id
    DocumentReference groupRef = firestore
        .collection("groups")
        .doc(widget.groupId);

    // 1️⃣ Üyeler listesinden sil
    DocumentSnapshot groupSnap = await groupRef.get();
    if (groupSnap.exists) {
      List members = List.from(groupSnap["members"]);
      members.removeWhere((m) => m["uid"] == uid);
      await groupRef.update({"members": members});
    }

    // 2️⃣ Notify mesajı ekle
    await groupRef.collection("chats").add({
      "message": "${auth.currentUser!.displayName} gruptan ayrıldı",
      "type": "notify",
      "time": FieldValue.serverTimestamp(),
    });

    // 3️⃣ Kullanıcının kendi alt koleksiyonundan grup belgesini sil
    DocumentReference userGroupRef = firestore
        .collection("users")
        .doc(uid)
        .collection("groups")
        .doc(widget.groupId);

    if ((await userGroupRef.get()).exists) {
      await userGroupRef.delete();
    }

    // 4️⃣ SnackBar ve ekran kapatma
    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.grey[800],
          content: Text(
            S.of(context).gruptan_ayrildiniz,
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }
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
              title: StreamBuilder<DocumentSnapshot>(
                stream:
                    firestore
                        .collection("groups")
                        .doc(widget.groupId)
                        .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Text("...");
                  }
                  var groupData = snapshot.data!;
                  return Text(
                    groupData["name"] ?? S.of(context).grup,
                    style: TextStyle(
                      color: temaNesne.temaOku() ? Colors.black : Colors.white,
                    ),
                  );
                },
              ),
              centerTitle: true,
            ),
          ),
          body: StreamBuilder<DocumentSnapshot>(
            stream:
                firestore.collection("groups").doc(widget.groupId).snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              var groupData = snapshot.data!;
              List members = groupData["members"];

              return SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(height: 30),

                      // ✅ Üye sayısı
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.pink,
                        child: Icon(Icons.group_outlined, size: 40),
                      ),
                      SizedBox(height: 14),
                      Text(
                        "${members.length} ${S.of(context).uye}",
                        style: TextStyle(
                          fontSize: 20,
                          color:
                              temaNesne.temaOku() ? Colors.white : Colors.black,
                        ),
                      ),

                      SizedBox(height: 20),

                      // ✅ Üye ekle butonu
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => Grupuyeekle(
                                    uyeler: members,
                                    grupIsmi: widget.groupIsim,
                                    grupId: widget.groupId,
                                  ),
                            ),
                          );
                        },
                        child: SizedBox(
                          width: 340,
                          height: 55,
                          child: Card(
                            color: Colors.deepPurple,
                            shape: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  S.of(context).uyeekle,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(width: 15),
                                Icon(
                                  Icons.person_add_alt_1_outlined,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 30),

                      // ✅ Üye listesi
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: members.length,
                        itemBuilder: (context, index) {
                          var user = members[index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              onTap: () {
                                gruptanCikar(user["name"], user["uid"]);
                              },
                              trailing:
                                  user["isAdmin"]
                                      ? Text(
                                    S.of(context).yonetici,
                                        style: TextStyle(color: Colors.black),
                                      )
                                      : Text(""),
                              shape: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              leading: Icon(
                                Icons.person_outline,
                                color: Colors.black,
                              ),
                              title: Text(
                                user["name"] ?? S.of(context).kulanici,
                                style: TextStyle(color: Colors.black),
                              ),
                              subtitle: Text(user["email"] ?? ""),
                              tileColor: Colors.tealAccent,
                            ),
                          );
                        },
                      ),

                      SizedBox(height: 20),

                      // ✅ Gruptan çıkma
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            S.of(context).gruptan_cik,
                            style: TextStyle(
                              color:
                                  temaNesne.temaOku()
                                      ? Colors.white
                                      : Colors.black,
                            ),
                          ),
                          IconButton(
                            onPressed: gruptanAyril,
                            icon: Icon(
                              Icons.logout_sharp,
                              color: Colors.redAccent,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 30),
                    ],
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
