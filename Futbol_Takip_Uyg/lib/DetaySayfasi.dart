import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:futbol_takipuyg/FavoriTakimCubit.dart';
import 'package:futbol_takipuyg/Takim.dart';
import 'package:futbol_takipuyg/WebSayfalari.dart';
import 'package:shimmer/shimmer.dart';

class Detaysayfasi extends StatefulWidget {
  late Takim takimVerileri;

  Detaysayfasi(this.takimVerileri);

  @override
  State<Detaysayfasi> createState() => _DetaysayfasiState();
}

class _DetaysayfasiState extends State<Detaysayfasi>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animationDegerleri;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2500),
    );

    animationDegerleri = Tween(begin: 100.0, end: 0.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.linear),
    )..addListener(() {
      setState(() {});
    });
    animationController.forward();
  }

  var favorilereEklimi = false;

  Widget websayfalar(String gorselUrl, String sosyalMedyaUrl,String sosyalMedyaIsmi) {
    return GestureDetector(
      child: CircleAvatar(
        radius: 30,
        backgroundColor: Colors.white,
        child: ClipOval(child: Image.asset(gorselUrl, width: 40, height: 40)),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Websayfalari(sosyalMedyaUrl,sosyalMedyaIsmi)),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Shimmer.fromColors(
          baseColor: Colors.cyan,
          highlightColor: Colors.black,
          child: Align(
            alignment: Alignment.center,
            child: Text(
              "${widget.takimVerileri.takimAdi}",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
          ),
        ),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Transform.translate(
          offset: Offset(0.0, animationDegerleri.value),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Container(
                    width: 400,
                    height: 150,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 150),
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.cyanAccent.withOpacity(
                                0.2,
                              ),
                              child: ClipOval(
                                child: Image.network(
                                  "${widget.takimVerileri.armasi}",
                                  width: 70,
                                  height: 70,
                                ),
                              ),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "${widget.takimVerileri.takimAdi}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.purpleAccent,
                    ),
                  ),
                ),

                Container(
                  width: 400,
                  padding: EdgeInsets.all(12),
                  margin: EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.indigo,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Kuruluş: ${widget.takimVerileri.kurulusYili} - ${widget.takimVerileri.ulke}",
                        style: TextStyle(fontSize: 17),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Stadyum: ${widget.takimVerileri.stad} (${widget.takimVerileri.stadKapasitesi} kişi)",
                        style: TextStyle(fontSize: 17),
                      ),
                      SizedBox(height: 12),
                      Text(
                        "İngilizce Takım Açıklaması :",
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),

                      Shimmer.fromColors(
                        baseColor: Colors.white,
                        highlightColor: Colors.black,
                        child: Text(
                          "${widget.takimVerileri.aciklamaEN}...",
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 400,
                  padding: EdgeInsets.all(12),
                  margin: EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.teal,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Shimmer.fromColors(
                        baseColor: Colors.white,
                        highlightColor: Colors.black,
                        child: Text(
                          "İletişim Adreslerimiz",
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
                      SizedBox(height: 30),
                      Row(
                        children: [
                          SizedBox(width: 15),
                          websayfalar(
                            "resimler/instagram.jpeg",
                            "https://${widget.takimVerileri.instagram}","Instagram"
                          ),
                          SizedBox(width: 10),

                          websayfalar(
                            "resimler/facebook.jpeg",
                            "https://${widget.takimVerileri.facebook}","Facebook"
                          ),
                          SizedBox(width: 10),

                          websayfalar(
                            "resimler/twetter.png",
                            "https://${widget.takimVerileri.twitter}","Twitter"
                          ),
                          SizedBox(width: 10),

                          websayfalar(
                            "resimler/website.jpeg",
                            "https://${widget.takimVerileri.websitesi}","Web Sayfa"
                          ),
                          SizedBox(width: 10),

                          websayfalar(
                            "resimler/youtube.jpeg",
                            "https://${widget.takimVerileri.youtube}","Youtube"
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),

                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      favorilereEklimi = !favorilereEklimi;
                    });
                    favorilereEklimi
                        ? context.read<FavoriCubit>().veriEkle(
                          widget.takimVerileri,
                        )
                        : context.read<FavoriCubit>().veriSil(
                          widget.takimVerileri,
                        );

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        duration: Duration(milliseconds: 2500),
                        content: Text(
                          favorilereEklimi
                              ? "Favorilere ekleme işlemi başarılı bir şekilde tamamlandı"
                              : "Favorilerden çıkarma işlemi başarılı bir şekilde tamamlandı",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        backgroundColor:
                            favorilereEklimi ? Colors.green : Colors.red,
                      ),
                    );
                  },
                  child: Text(
                    favorilereEklimi ? "Favorilerden çıkar" : "Favorilere ekle",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),

                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        favorilereEklimi ? Colors.red : Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
