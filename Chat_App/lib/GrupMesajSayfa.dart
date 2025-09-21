import 'package:chatapp13/GrupBilgiSayfa.dart';
import 'package:chatapp13/Providerler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:chatapp13/generated/l10n.dart';

class Grupmesajsayfa extends StatefulWidget {
  late String grupId;
  late String grupIsim;

  Grupmesajsayfa({required this.grupId, required this.grupIsim});

  @override
  State<Grupmesajsayfa> createState() => _GrupmesajsayfaState();
}

class _GrupmesajsayfaState extends State<Grupmesajsayfa> {
  late TextEditingController textEditingController;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    textEditingController = TextEditingController();
    super.initState();
  }

  // 📌 Mesaj gönderme fonksiyonu
  Future<void> mesajGonder() async {
    if (textEditingController.text.trim().isNotEmpty) {
      await firestore
          .collection("groups")
          .doc(widget.grupId)
          .collection("chats")
          .add({
            "message": textEditingController.text.trim(),
            "sendby": auth.currentUser!.displayName ?? "Bilinmeyen",
            "type": "text",
            "time": FieldValue.serverTimestamp(),
          });

      textEditingController.clear();
    }
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
              title: StreamBuilder<DocumentSnapshot>(
                stream:
                    firestore
                        .collection("groups")
                        .doc(widget.grupId)
                        .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Lottie.asset("iconlar/yukleniyorMu.json")],
                      ),
                    );
                  }
                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return Text(S.of(context).grupBulanamadi);
                  }

                  var grupData = snapshot.data!.data() as Map<String, dynamic>;
                  return Text(
                    grupData["name"] ?? S.of(context).grup,
                    style: TextStyle(
                      color: temaNesne.temaOku() ? Colors.black : Colors.white,
                    ),
                  );
                },
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => Grupbilgisayfa(
                              groupId: widget.grupId,
                              groupIsim: widget.grupIsim,
                            ),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.more_vert,
                    color: temaNesne.temaOku() ? Colors.black : Colors.white,
                  ),
                ),
              ],
            ),
          ),
          body: Column(
            children: [
              // 📌 Mesajlar listesi
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream:
                      firestore
                          .collection("groups")
                          .doc(widget.grupId)
                          .collection("chats")
                          .orderBy("time")
                          .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return  Center(child: Text(S.of(context).henuzmesaj_yok));
                    }

                    var docs = snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        var veri = docs[index].data() as Map<String, dynamic>;
                        bool benimMesajim =
                            veri["sendby"] == auth.currentUser!.displayName;

                        return veri["type"] == "notify"
                            ? Align(
                              alignment: Alignment.center,
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                  vertical: 4,
                                  horizontal: 8,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 14,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.pink,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  veri["message"],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            )
                            : Align(
                              alignment:
                                  benimMesajim
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                  vertical: 4,
                                  horizontal: 8,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 14,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      benimMesajim
                                          ? Colors.blue[300]
                                          : Colors.grey[400],
                                  borderRadius: BorderRadius.only(
                                    topLeft: const Radius.circular(12),
                                    topRight: const Radius.circular(12),
                                    bottomLeft: Radius.circular(
                                      benimMesajim ? 12 : 0,
                                    ),
                                    bottomRight: Radius.circular(
                                      benimMesajim ? 0 : 12,
                                    ),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      veri["sendby"] ?? S.of(context).bilinmeyen,
                                      style: TextStyle(
                                        color:
                                            benimMesajim
                                                ? Colors.white
                                                : Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      veri["message"],
                                      style: TextStyle(
                                        color:
                                            benimMesajim
                                                ? Colors.black
                                                : Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                      },
                    );
                  },
                ),
              ),

              // 📌 Mesaj yazma alanı
              SafeArea(
                child: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.tealAccent,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: textEditingController,
                          decoration:  InputDecoration(
                            hintText: S.of(context).mesaz_yaz,
                            border: InputBorder.none,
                          ),
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: mesajGonder,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
