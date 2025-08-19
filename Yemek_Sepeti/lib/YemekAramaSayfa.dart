import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as badges;
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:yemek_siparis_uyg/Kisiler2.dart';
import 'package:yemek_siparis_uyg/SepetCubit.dart';
import 'package:yemek_siparis_uyg/SepetSayac.dart';
import 'package:yemek_siparis_uyg/SepetSayfa.dart';

import 'Meal.dart';
import 'YouTubeplayer.dart';

class Yemekaramasayfa extends StatefulWidget {
  late Kisiler2 kisiler2;

  Yemekaramasayfa(this.kisiler2);

  @override
  State<Yemekaramasayfa> createState() => _YemekaramasayfaState();
}

class _YemekaramasayfaState extends State<Yemekaramasayfa>
    with TickerProviderStateMixin {
  late Future<List<Meal>> tumveri;
  bool verilerGeldiMi = false;
  List<String> urller = [
    "https://www.themealdb.com/api/json/v1/1/search.php?s=chicken",
    "https://www.themealdb.com/api/json/v1/1/search.php?s=eat",
    "https://www.themealdb.com/api/json/v1/1/search.php?s=soup",
  ];

  Future<List<Meal>> tumVeriler() async {
    List<Meal> tumveriler = [];
    for (var urller in urller) {
      var cevap = await http.get(Uri.parse(urller));
      if (cevap.statusCode == 200) {
        final jsonVeri = json.decode(cevap.body);
        final mealsJson = jsonVeri["meals"];

        if (mealsJson != null && mealsJson.isNotEmpty) {
          for (var i = 0; i < mealsJson.length; i++) {
            tumveriler.add(Meal.fromJson(mealsJson[i]));
          }
        }
      }
    }
    setState(() {
      verilerGeldiMi = true;
    });
    return tumveriler;
  }

  late Animation<double> animationDegerleri;
  late AnimationController animationController;

  void initState() {
    super.initState();
    tumveri = tumVeriler();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 3000),
    );
    animationDegerleri = Tween(begin: 100.0, end: 0.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeOut),
    )..addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SepetSayac(),
      child: Scaffold(
        appBar: AppBar(
          title: Align(
            alignment: Alignment.center,
            child: Text(
              "Yemek Arama Sayfası",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),

          actions: [
            badges.Badge(
              backgroundColor: Colors.cyanAccent,
              offset: Offset(-5, 5),
              label: Consumer<SepetSayac>(
                builder: (context, sayacModelNesne, child) {
                  return Text(
                    "${sayacModelNesne.komplesayacOku()}",
                    style: TextStyle(color: Colors.black),
                  );
                },
              ),
              child: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Sepetsayfa(widget.kisiler2),
                    ),
                  );
                },
                icon: Icon(Icons.shopping_basket, color: Colors.green),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.black,
        body: FutureBuilder<List<Meal>>(
          future: tumveri,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 3 / 6,
                  crossAxisCount: 3,


                ),
                itemCount: 46,
                itemBuilder: (context, index) {
                  return Shimmer.fromColors(
                    baseColor: Colors.white54,
                    highlightColor: Colors.white,
                    child: Card(
                      shadowColor: Colors.white,
                      elevation: 10,
                      shape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: Colors.greenAccent,
                          width: 2.0,
                        ),
                      ),
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Center(child: Text("Veri yüklenirken hata oluştu"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text("Hiç yemek bulunamadı"));
            }

            var meals = snapshot.data!;

            return GridView.builder(
              padding: EdgeInsets.all(20),

              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // aynı satırda 2 kart
                childAspectRatio: 3 / 6, // kart boy oranı
                crossAxisSpacing: 10, // yatayda boşluk
                mainAxisSpacing: 10, // dikeyde boşluk
              ),
              itemCount: meals.length,
              itemBuilder: (context, index) {
                var meal = meals[index];
                return GestureDetector(
                  onTap: () {
                    if (widget.kisiler2.premiumVarmi) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Youtubeplayer(meal),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Detaylar için premium satın almalısınız",
                            style: TextStyle(fontSize: 17),
                          ),
                          backgroundColor: Colors.white,
                          duration: Duration(milliseconds: 2000),
                        ),
                      );
                    }
                  },
                  child: Transform.translate(
                    offset: Offset(0, animationDegerleri.value),
                    child: badges.Badge(
                      offset: Offset(-8, 5),
                      label: Consumer<SepetSayac>(
                        builder: (context, sayacModelNesne, child) {
                          return Text(
                            "${sayacModelNesne.urunSayaciOku(index)}",
                            style: TextStyle(color: Colors.black),
                          );
                        },
                      ),
                      backgroundColor: Colors.cyanAccent,
                      child: Card(
                        shape: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.greenAccent,
                            width: 2.0,
                          ),
                        ),
                        elevation: 10,
                        shadowColor: Colors.white54,
                        color: Colors.white54,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                width: 100,
                                height: 100,
                                child: Image.network("${meal.strMealThumb}"),
                              ),
                              Text(
                                "${meal.strMeal}",
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text("Fiyat : 40Tl"),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Consumer<SepetSayac>(
                                    builder: (context, sayacNesne, child) {
                                      return IconButton(
                                        onPressed: () {
                                          sayacNesne.urunSil(index);
                                          context.read<SepetCubit>().veriSil(
                                            meal,
                                          );
                                        },
                                        icon: Icon(
                                          Icons.remove,
                                          color: Colors.red,
                                          size: 30,
                                        ),
                                      );
                                    },
                                  ),
                                  Consumer<SepetSayac>(
                                    builder: (context, sayacNesne, child) {
                                      return IconButton(
                                        onPressed: () {
                                          sayacNesne.urunEkle(index);
                                          context.read<SepetCubit>().veriEkle(
                                            meal,
                                          );
                                        },
                                        icon: Icon(
                                          Icons.add,
                                          color: Colors.green,
                                          size: 30,
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
