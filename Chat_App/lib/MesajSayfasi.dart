import 'package:chatapp13/Providerler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chatapp13/generated/l10n.dart';


class Mesajsayfasi extends StatefulWidget {
  final Map<String, dynamic> kisiMap;
  final String mesajOdaId;

  Mesajsayfasi(this.kisiMap, this.mesajOdaId, {super.key});

  @override
  State<Mesajsayfasi> createState() => _MesajsayfasiState();
}

class _MesajsayfasiState extends State<Mesajsayfasi> {
  late TextEditingController textEditingController;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    textEditingController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TemaOkuma>(
      builder: (context, temaNesne, child) {
        return Scaffold(
          resizeToAvoidBottomInset: true, // klavye açıldığında yukarı kalksın

          appBar: PreferredSize(
            preferredSize: Size.fromHeight(100),
            child: AppBar(
              backgroundColor:
                  temaNesne.temaOku() ? Colors.white : Colors.black,
              shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              actions: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Image.asset("resimler/prof.png", width: 45),
                ),
              ],
              title: StreamBuilder<DocumentSnapshot>(
                stream:
                    firestore
                        .collection("users")
                        .doc(widget.kisiMap["uid"])
                        .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.data != null) {
                    return ListTile(
                      title: Text(
                        widget.kisiMap["name"] ?? "Name",
                        style: TextStyle(
                          color:
                              temaNesne.temaOku() ? Colors.black : Colors.white,
                        ),
                      ),
                      subtitle: Text(
                        snapshot.data!["status"],
                        style: TextStyle(
                          color:
                              temaNesne.temaOku() ? Colors.black : Colors.white,
                        ),
                      ),
                    );
                  }
                  return SizedBox();
                },
              ),
            ),
          ),

          body: Column(
            children: [
              // 📌 Mesajlar listesi
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream:
                      firestore
                          .collection("messageroom")
                          .doc(widget.mesajOdaId)
                          .collection("messages")
                          .orderBy(
                            "time",
                            descending: false,
                          ) // en yeni mesaj en üstte
                          .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(child: Text(S.of(context).henuzmesaj_yok));
                    }

                    return ListView.builder(
                      reverse: false, // en son mesaj en altta
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var veri = snapshot.data!.docs[index];
                        bool benimMesajim =
                            veri["sendby"] == auth.currentUser!.displayName;

                        return Align(
                          alignment:
                              benimMesajim
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                          child: Container(
                            margin: EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 8,
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 14,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  benimMesajim
                                      ? Colors.blue[300]
                                      : Colors.grey[400],
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                                bottomLeft: Radius.circular(
                                  benimMesajim ? 12 : 0,
                                ),
                                bottomRight: Radius.circular(
                                  benimMesajim ? 0 : 12,
                                ),
                              ),
                            ),
                            child: Text(
                              veri["message"],
                              style: TextStyle(
                                color:
                                    benimMesajim ? Colors.white : Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                    ;
                  },
                ),
              ),

              // 📌 Mesaj yazma alanı
              SafeArea(
                child: Container(
                  margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.tealAccent,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: textEditingController,
                          decoration: InputDecoration(
                            hintText: S.of(context).mesaz_yaz,
                            border: InputBorder.none,
                          ),
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () {
                          if (textEditingController.text.trim().isNotEmpty) {
                            FirebaseFirestore.instance
                                .collection("messageroom")
                                .doc(widget.mesajOdaId)
                                .collection("messages")
                                .add({
                                  "message": textEditingController.text.trim(),
                                  "time": FieldValue.serverTimestamp(),
                                  "sendby": auth.currentUser!.displayName,
                                });
                            textEditingController.clear();
                          }
                        },
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
