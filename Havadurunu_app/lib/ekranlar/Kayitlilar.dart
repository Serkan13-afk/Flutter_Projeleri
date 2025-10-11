import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:havadurumu_app/Providerler.dart';
import 'package:provider/provider.dart';

class Kayitlilar extends StatefulWidget {
  late User kisi;

  Kayitlilar(this.kisi);

  @override
  State<Kayitlilar> createState() => _KayitlilarState();
}

class _KayitlilarState extends State<Kayitlilar> with TickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController animationController;

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> konumKayitSilme(String silinecekSehir) async {
    QuerySnapshot snapshot = await firestore
        .collection("savelocations")
        .doc(widget.kisi.uid)
        .collection("locations")
        .get();

    String? silinecekDocId;

    snapshot.docs.forEach((doc) {
      if (doc['savecity'] == silinecekSehir) {
        silinecekDocId = doc.id; // DocId'yi kaydet
      }
    });

    if (silinecekDocId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Silinecek konum bulunamadı")));
      return;
    }

    await firestore
        .collection("savelocations")
        .doc(widget.kisi.uid)
        .collection("locations")
        .doc(silinecekDocId)
        .delete();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Konum başarılı bir şekilde kayıtlı listesinden silindi"),
      ),
    );
  }

  Stream<QuerySnapshot> konumStream() {
    return FirebaseFirestore.instance
        .collection("savelocations")
        .doc(widget.kisi.uid)
        .collection("locations")
        .orderBy("timestamp", descending: true) // en son eklenen en üstte
        .snapshots();
  }

  Widget konumListesi() {
    return StreamBuilder<QuerySnapshot>(
      stream: konumStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text("Henüz kayıtlı konum yok"));
        }

        // Tüm konum belgelerini alıyoruz
        var konumlar = snapshot.data!.docs;

        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: konumlar.length,
          itemBuilder: (context, index) {
            var data = konumlar[index].data() as Map<String, dynamic>;
            String docId = konumlar[index].id; // Silmek için lazım
            String sehirAdi = data["savecity"];
            String kullaniciAdi = data["name"];

            return Card(
              margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: ListTile(
                shape: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                tileColor: Colors.tealAccent,
                leading: Icon(Icons.location_on, color: Colors.redAccent),
                title: Text(sehirAdi, style: TextStyle(color: Colors.black)),
                subtitle: Text(
                  "Ekleyen: $kullaniciAdi",
                  style: TextStyle(color: Colors.black),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.grey[700]),
                  onPressed: () async {
                    // Silme fonksiyonu
                    await firestore
                        .collection("savelocations")
                        .doc(widget.kisi.uid)
                        .collection("locations")
                        .doc(docId)
                        .delete();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        duration: Duration(milliseconds: 2000),
                        content: Text("$sehirAdi konumu silindi"),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );
    animation =
        Tween(begin: -100.0, end: 0.0).animate(
          CurvedAnimation(parent: animationController, curve: Curves.linear),
        )..addListener(() {
          setState(() {});
        });
    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TemaOkuma>(
      builder: (context, temaNesne, child) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(100),
            child: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.lightBlueAccent,
              title: Align(
                alignment: Alignment.center,
                child: Text("Kayıtlı Konumlar"),
              ),
            ),
          ),
          body: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: temaNesne.temaOku()
                    ? [Colors.white, Colors.cyanAccent]
                    : [Colors.black, Colors.cyanAccent],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
            child: SingleChildScrollView(
              child: Transform.translate(
                offset: Offset(0, animationController.value),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [SizedBox(height: 50), konumListesi()],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
