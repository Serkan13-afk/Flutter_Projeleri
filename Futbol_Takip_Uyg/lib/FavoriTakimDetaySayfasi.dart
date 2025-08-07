import 'dart:math';

import 'package:flutter/material.dart';
import 'package:futbol_takipuyg/Takim.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class Favoritakimdetaysayfasi extends StatefulWidget {
  late Takim takim;

  Favoritakimdetaysayfasi(this.takim);

  @override
  State<Favoritakimdetaysayfasi> createState() =>
      _FavoritakimdetaysayfasiState();
}

class _FavoritakimdetaysayfasiState extends State<Favoritakimdetaysayfasi>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animationDegerleri;

  late AnimationController animationController2;
  late Animation<double> animationDegerleri2;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2000),
    );
    animationDegerleri = Tween(begin: 0.6, end: 1.3).animate(
      CurvedAnimation(parent: animationController, curve: Curves.linear),
    )..addListener(() {
      setState(() {});
    });
    animationController2 = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 4000),
    );
    animationDegerleri2 = Tween(begin: 0.0, end: 2 * pi).animate(
      CurvedAnimation(parent: animationController2, curve: Curves.linear),
    )..addListener(() {
      setState(() {});
    });
    animationController2.repeat(reverse: true);

    animationController.forward();
  }

  Widget formaControl() {
    if (widget.takim.ekipman != null) {
      return Transform(
        alignment: Alignment.center,
        transform:
            Matrix4.identity()
              ..setEntry(3, 2, 0.001) //3D görünümü veriyor
              ..rotateY(animationDegerleri2.value),
        //Y ekseninde dönmeyi sağlıyor
        child: Image.network(
          "${widget.takim.ekipman}",
          width: 150,
          height: 150,
        ),
      );
    }
    return Transform(
      alignment: Alignment.center,
      transform:
          Matrix4.identity()
            ..setEntry(3, 2, 0.001) //3D görünümü veriyor
            ..rotateY(animationDegerleri2.value),
      //Y ekseninde dönmeyi sağlıyor
      child: Icon(Icons.remove_circle_outline, size: 50, color: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SayacDinleme(),
      child: Scaffold(
        appBar: AppBar(
          title: Shimmer.fromColors(
            baseColor: Colors.cyan,
            highlightColor: Colors.black,
            child: Align(
              alignment: Alignment.center,
              child: Text(
                "Favori Takım->${widget.takim.takimAdi}",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
            ),
          ),
          backgroundColor: Colors.black,
        ),
        backgroundColor: Colors.cyanAccent,
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20),

                Transform.scale(
                  scale: animationDegerleri.value,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.black,
                    child: Image.network("${widget.takim.armasi}"),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Container(
                    width: 380,
                    height: 150,
                    margin: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.green),
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.black,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Shimmer.fromColors(
                          baseColor: Colors.cyanAccent,
                          highlightColor: Colors.white,
                          child: Text(
                            "Yeni Sezon Formamız",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        formaControl(),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 380,
                  height: 301,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.green),
                    color: Colors.black,
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          """Yeni Sezon Formasıyla Sahadaki Gücü Tribüne Taşı!
      2025-2026 sezonu için tasarlanan yepyeni formamız seni bekliyor.
      Sadece bir forma değil; bu, geçmişin mirası, bugünün mücadelesi ve geleceğin zaferidir.
      Renklerine aşık olanlar için, takımına olan sevdanı göstereceğin en özel parça!
      
      Taraftar sadece izlemez, destek olur!
      Sen de bu sezonun bir parçası ol,
      Formanı giy, takıma güç ver!
      Stoklarla sınırlı, kaçırma!""",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 150,
                      height: 100,
                      child: Card(
                        color: Colors.black,
                        shape: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: SizedBox(
                          width: 150,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Consumer<SayacDinleme>(
                                builder: (context, sayacModelNesne, child) {
                                  return Text(
                                    //Dinleme için
                                    "Forma adedi: ${sayacModelNesne.sayacOku()}",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 200,
                      height: 100,
                      child: Card(
                        color: Colors.black,
                        shape: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: SizedBox(
                          width: 150,
                          child: Row(
                            children: [
                              Consumer<SayacDinleme>(
                                builder: (context, sayacModelNesne, child) {
                                  return Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      //Dinleme için
                                      "Sepet Tutarı: ${sayacModelNesne.toplamFiyatOku()} Tl",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Card(
                      color: Colors.black,
                      shape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: SizedBox(
                        width: 150,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Consumer<SayacDinleme>(
                              //Tetikleme işlem yapılacak
                              builder: (context, sayacModelNesne, child) {
                                return IconButton(
                                  onPressed: () {
                                    sayacModelNesne.sayacArtir();
                                  },
                                  icon: Icon(
                                    Icons.add,
                                    size: 40,
                                    color: Colors.green,
                                  ),
                                );
                              },
                            ),
                            Consumer<SayacDinleme>(
                              //Tetikleme işlem yapılacak
                              builder: (context, sayacModelNesne, child) {
                                return IconButton(
                                  onPressed: () {
                                    sayacModelNesne.sayacAzalt();
                                  },
                                  icon: Icon(
                                    Icons.remove,
                                    size: 40,
                                    color: Colors.red,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      color: Colors.black,
                      shape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: SizedBox(
                        width: 70,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Consumer<SayacDinleme>(
                              //Tetikleme işlem yapılacak
                              builder: (context, sayacModelNesne, child) {
                                return IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text("Sepet Onay sayfası"),
                                          shape: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              15,
                                            ),
                                          ),
                                          content: Text(
                                            "${sayacModelNesne.sayacOku()} adet formayı ${sayacModelNesne.toplamFiyatOku()} Tl karşılığında satın almak istiyormusun",
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                sayacModelNesne.sayacSifirla();
                                                Navigator.pop(context);
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      "İşlem onaylandı",
                                                    ),
                                                    backgroundColor:
                                                        Colors.green,
                                                    duration: Duration(
                                                      milliseconds: 2500,
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Text(
                                                "Onayla",
                                                style: TextStyle(
                                                  color: Colors.green,
                                                ),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text(
                                                "İptal",
                                                style: TextStyle(
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  icon: Icon(
                                    Icons.check_circle_outline_sharp,
                                    size: 40,
                                    color: Colors.green,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SayacDinleme extends ChangeNotifier {
  int sayac = 0;
  int formaFiyati = 4000;

  int sayacOku() {
    return sayac;
  }

  void sayacSifirla() {
    sayac = 0;
    notifyListeners();
  }

  int toplamFiyatOku() {
    return sayac * formaFiyati;
  }

  void sayacArtir() {
    sayac = sayac + 1;
    notifyListeners();
  }

  void sayacAzalt() {
    if (sayacOku() == 0) {
      return;
    } else {
      sayac = sayac - 1;
      notifyListeners();
    }
  }
}
