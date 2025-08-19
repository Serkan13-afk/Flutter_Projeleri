import 'dart:collection';
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart' as badges;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yemek_siparis_uyg/FirsatUrunSayac.dart';
import 'package:yemek_siparis_uyg/StorySayfa.dart';

import 'Kisiler2.dart';
import 'Meal.dart';

class Anasayfa extends StatefulWidget {
  late Kisiler2 kisiler2;

  Anasayfa(this.kisiler2);

  @override
  State<Anasayfa> createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> with TickerProviderStateMixin {
  late TabController tabController;
  bool basildimi1 = false;
  bool basildimi2 = false;
  bool basildimi3 = false;
  bool basildimi4 = false;
  bool basildimi5 = false;
  var refKisiler = FirebaseDatabase.instance.ref().child("kisiler_tablo");
  bool premiumVarmi1 = false;
  var karekodMesaji = "https://drive.google.com/file/d/1xGQZzCKfGUp9cCdNyqeYvtpwv0OThkEV/view?usp=sharing";
  var bildiriIconuSecilimi = true;
  var cardabasildiMi = false;
  List<dynamic> meals = [];
  final Uri mailUrl = Uri(
    scheme: "mailto",
    path: "serko.131215@gmail.com",
    queryParameters: {
      'subject': 'Konu',
      'body': 'Düşüncelerinizi buraya yazabilirsiniz',
    },
  );

  Future<void> mailControl() async {
    if (await canLaunchUrl(mailUrl)) {
      // yukarıdaki nesneye bakıyor sorun varmı yoksa gir
      await launchUrl(
        mailUrl,
        mode: LaunchMode.externalApplication,
      ); // sonrada bilgileri al gönder
    } else {
      print("Mail gönderilemiyor");
    }
  }

  Future<void> premiumOlma() async {}

  Future<void> premiumOkuma() async {
    var event = await refKisiler.once();
    var gelenDegerler = event.snapshot.value as dynamic;

    if (gelenDegerler == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Sistemden veriler çekilemedi"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    String? key1;
    Kisiler2? bulunanKisi;

    gelenDegerler.forEach((key, nesne) {
      var gelenKisi = Kisiler2.fromJson(nesne);
      if (widget.kisiler2.mail == gelenKisi.mail) {
        key1 = key;
        bulunanKisi = gelenKisi;
      }
    });
    if (key1 != null && bulunanKisi != null) {
      premiumVarmi1 = bulunanKisi!.premiumVarmi;
    }
  }

  Widget premiumGosterme() {
    if (premiumVarmi1) {
      return SizedBox();
    }
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Shimmer.fromColors(
            baseColor: Colors.white54,
            highlightColor: Colors.white,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Premium Fırsatı",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(height: 15),
          cardIcerigigoster(),
        ],
      ),
    );
  }

  Future<void> premiumGuncelle() async {
    var event = await refKisiler.once();
    var gelenDegerler = event.snapshot.value as dynamic;

    if (gelenDegerler == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Sistemden veriler çekilemedi"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    String? key1;
    Kisiler2? bulunanKisi;

    gelenDegerler.forEach((key, nesne) {
      var gelenKisi = Kisiler2.fromJson(nesne);
      if (widget.kisiler2.mail == gelenKisi.mail) {
        key1 = key;
        bulunanKisi = gelenKisi;
      }
    });

    if (key1 != null && bulunanKisi != null) {
      var guncelbilgi = HashMap<String, dynamic>();
      guncelbilgi["ad"] = bulunanKisi!.ad;
      guncelbilgi["mail"] = bulunanKisi!.mail;
      guncelbilgi["sifre"] = bulunanKisi!.sifre;
      guncelbilgi["soyad"] = bulunanKisi!.soyad;
      guncelbilgi["premiumVarmi"] = true;
      guncelbilgi["siparis_Adres"] = bulunanKisi!.siparisAdres;

      await refKisiler.child(key1!).update(guncelbilgi);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Premium satın alma başarılı bir şekilde gerçekleşti"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Kullanıcı bulunıcı bulunamadı"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> favoriTavukgetir() async {
    final url = Uri.parse(
      "https://www.themealdb.com/api/json/v1/1/search.php?s=chicken",
    );
    final cevap = await http.get(url);

    if (cevap.statusCode == 200) {
      final veri = json.decode(cevap.body);

      // JSON içindeki "meals" listesini alıyoruz
      final List<dynamic> mealList = veri['meals'];

      if (mealList.isNotEmpty) {
        // İlk elemanı al
        final firstMealJson = mealList[0];

        // Model sınıfına dönüştür
        final firstMeal = Meal.fromJson(firstMealJson);

        print("İlk yemek adı: ${firstMeal.strMeal}");
        print("Kategori: ${firstMeal.strCategory}");
        print("Youtube Link: ${firstMeal.strYoutube}");

        setState(() {
          meals.add(firstMeal);
        });
      }
    } else {
      print("Veri çekilemedi. Durum kodu: ${cevap.statusCode}");
    }
  }

  Future<void> favoriEtgetir() async {
    final url = Uri.parse(
      "https://www.themealdb.com/api/json/v1/1/search.php?s=eat",
    );
    final cevap = await http.get(url);

    if (cevap.statusCode == 200) {
      final veri = json.decode(cevap.body);

      // JSON içindeki "meals" listesini alıyoruz
      final List<dynamic> mealList = veri['meals'];

      if (mealList.isNotEmpty) {
        // İlk elemanı al
        final firstMealJson = mealList[0];

        // Model sınıfına dönüştür
        final firstMeal = Meal.fromJson(firstMealJson);

        print("İlk yemek adı: ${firstMeal.strMeal}");
        print("Kategori: ${firstMeal.strCategory}");
        print("Youtube Link: ${firstMeal.strYoutube}");

        setState(() {
          meals.add(firstMeal);
        });
      }
    } else {
      print("Veri çekilemedi. Durum kodu: ${cevap.statusCode}");
    }
  }

  Future<void> favoriCorbagetir() async {
    final url = Uri.parse(
      "https://www.themealdb.com/api/json/v1/1/search.php?s=soup",
    );
    final cevap = await http.get(url);

    if (cevap.statusCode == 200) {
      final veri = json.decode(cevap.body);

      // JSON içindeki "meals" listesini alıyoruz
      final List<dynamic> mealList = veri['meals'];

      if (mealList.isNotEmpty) {
        // İlk elemanı al
        final firstMealJson = mealList[0];

        // Model sınıfına dönüştür
        final firstMeal = Meal.fromJson(firstMealJson);

        print("İlk yemek adı: ${firstMeal.strMeal}");
        print("Kategori: ${firstMeal.strCategory}");
        print("Youtube Link: ${firstMeal.strYoutube}");

        setState(() {
          meals.add(firstMeal);
        });
      }
    } else {
      print("Veri çekilemedi. Durum kodu: ${cevap.statusCode}");
    }
  }

  Future<void> favoriTatligetir() async {
    final url = Uri.parse(
      "https://www.themealdb.com/api/json/v1/1/filter.php?c=Dessert",
    );
    final cevap = await http.get(url);

    if (cevap.statusCode == 200) {
      final veri = json.decode(cevap.body);

      // JSON içindeki "meals" listesini alıyoruz
      final List<dynamic> mealList = veri['meals'];

      if (mealList.isNotEmpty) {
        // İlk elemanı al
        final firstMealJson = mealList[0];

        // Model sınıfına dönüştür
        final firstMeal = Meal.fromJson(firstMealJson);

        print("İlk yemek adı: ${firstMeal.strMeal}");
        print("Kategori: ${firstMeal.strCategory}");
        print("Youtube Link: ${firstMeal.strYoutube}");

        setState(() {
          meals.add(firstMeal);
        });
      }
    } else {
      print("Veri çekilemedi. Durum kodu: ${cevap.statusCode}");
    }
  }

  Widget encokTercihEdilen() {
    return SizedBox(
      height: 120, // Sabit bir yükseklik veriyoruz
      child: Card(
        elevation: 10,
        shadowColor: Colors.white,
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.greenAccent, width: 3.0),
        ),
        color: Colors.white54,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: meals.length,
          itemBuilder: (context, index) {
            var meal = meals[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => StorySayfasi(meal)),
                  );
                },
                child: CircleAvatar(
                  radius: 35,
                  backgroundImage: NetworkImage(meal.strMealThumb ?? ''),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget cardIcerigigoster() {
    if (!cardabasildiMi) {
      return Card(
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.greenAccent, width: 2.0),
        ),
        elevation: 10,
        shadowColor: Colors.white,
        color: Colors.white54,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Hemen Premium'u deneyin fırsatları kaçırmayın",
                  overflow: TextOverflow.ellipsis,

                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      cardabasildiMi = !cardabasildiMi;
                    });
                  },
                  icon:
                      cardabasildiMi
                          ? Icon(Icons.expand_less, color: Colors.black)
                          : Icon(Icons.expand_more, color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shadowColor: Colors.black,
              elevation: 20,
              backgroundColor: Colors.white,
              shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.greenAccent, width: 3.0),
              ),
              title: Align(
                alignment: Alignment.center,
                child: Text(
                  "Premium Onay Sayfası",
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
              ),
              content: SizedBox(
                width: 400,
                height: 650,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("""
✅ Reklamsız, kesintisiz kullanım  
✅ Tüm özel içeriklere sınırsız erişim  
✅ Öncelikli destek hizmeti  
✅ Erken erişim: Yeni özellikleri herkesten önce deneyin  
🌟 Siparişlerinizde 100 TL’ye varan geçerli indirim kuponları  

💎 Şimdi Premium’a geçin, farkı hissedin!  
💰 Aylık: ₺19,99 | Yıllık: ₺149,99 (2 ay ücretsiz)  

⚖️ Not: Premium üyeliğinizi 14 gün içerisinde iptal etme ve cayma hakkınız bulunmaktadır.  
❗ Cayma durumunda yalnızca kullandığınız gün sayısı ve işlem masrafı olan ₺9,99 kesintisi yapılır, kalan tutar iade edilir.  

✨ Premium ayrıcalıklarıyla kendinizi özel hissedin: Sizin için hazırlanmış içerikler, kişisel deneyim ve ayrıcalıklı fırsatlar.  
🚀 Daha hızlı, daha güvenli ve sınırsız bir deneyim için Premium sizinle.  
                    """, style: TextStyle(color: Colors.black)),
                      SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("İptal"),
                            style: ElevatedButton.styleFrom(
                              shadowColor: Colors.black,
                              elevation: 10,
                              backgroundColor: Colors.teal,
                              side: BorderSide(
                                color: Colors.greenAccent,
                                width: 2.0,
                              ),
                            ),
                          ),
                          SizedBox(width: 30),
                          ElevatedButton(
                            onPressed: () {
                              premiumGuncelle();
                              Navigator.pop(context);
                            },
                            child: Text("Onayla"),
                            style: ElevatedButton.styleFrom(
                              shadowColor: Colors.black,
                              elevation: 10,
                              backgroundColor: Colors.teal,
                              side: BorderSide(
                                color: Colors.greenAccent,
                                width: 2.0,
                              ),
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
      child: Card(
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.greenAccent, width: 2.0),
        ),
        elevation: 10,
        shadowColor: Colors.white,
        color: Colors.white54,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "\n ✅ Reklamsız, kesintisiz kullanım\n ✅ Tüm özel içeriklere sınırsız erişim\n ✅ Öncelikli destek hizmeti\n ✅ Erken erişim: Yeni özellikleri herkesten önce deneyin\n 🌟 Siparişlerinizde 100Tl ye varan geçerli indirim kuponları\n \n 💎 Şimdi Premium’a geçin, farkı hissedin! \n 💰 Aylık: ₺19,99 | Yıllık: ₺149,99 (2 ay ücretsiz)\n\n",

                maxLines: 10,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12, color: Colors.black),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    cardabasildiMi = !cardabasildiMi;
                  });
                },
                icon:
                    cardabasildiMi
                        ? Icon(Icons.expand_less, color: Colors.black)
                        : Icon(Icons.expand_more, color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget idirimliUrun() {
    return SizedBox(
      width: 380,
      height: 170,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => Scaffold(
                    appBar: AppBar(
                      title: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Fırsat Ürün",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        ),
                      ),
                      actions: [
                        Consumer<FirsatUrunFirsat>(
                          builder: (context, sayacNesne, child) {
                            return badges.Badge(
                              offset: Offset(-5, 5),
                              backgroundColor: Colors.cyanAccent,
                              label: Text(
                                "${sayacNesne.siparisOku()}",
                                style: TextStyle(color: Colors.black),
                              ),
                              child: IconButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text(
                                          "Siparş Onay",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            color: Colors.black,
                                          ),
                                        ),
                                        elevation: 10,
                                        backgroundColor: Colors.white,
                                        shape: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                          borderSide: BorderSide(
                                            color: Colors.cyan,
                                            width: 3.0,
                                          ),
                                        ),
                                        content: SizedBox(
                                          width: 200,
                                          height: 300,
                                          child: Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "${sayacNesne.siparisOku()} adet olan Hamburger siparişinizi ${sayacNesne.siparisSayisi * 25} TL karşılığında satın almak istiyormusuz",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                SizedBox(height: 50),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    TextButton(
                                                      onPressed: () {
                                                        sayacNesne.sifirla();
                                                        Navigator.pop(context);
                                                        ScaffoldMessenger.of(
                                                          context,
                                                        ).showSnackBar(
                                                          SnackBar(
                                                            content: Text(
                                                              "Siparişiniz iptal edildi",
                                                              style: TextStyle(
                                                                fontSize: 22,
                                                                color:
                                                                    Colors
                                                                        .black,
                                                              ),
                                                            ),
                                                            duration: Duration(
                                                              milliseconds:
                                                                  2000,
                                                            ),
                                                            backgroundColor:
                                                                Colors.white,
                                                          ),
                                                        );
                                                      },
                                                      child: Text(
                                                        "İptal",
                                                        style: TextStyle(
                                                          color: Colors.red,
                                                          fontSize: 20,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 30),
                                                    TextButton(
                                                      onPressed: () {
                                                        if (sayacNesne
                                                                .siparisOku() <
                                                            3) {
                                                          ScaffoldMessenger.of(
                                                            context,
                                                          ).showSnackBar(
                                                            SnackBar(
                                                              content: Text(
                                                                "Sepetinizde en az 3 adet ürün bulunmalı",
                                                                style: TextStyle(
                                                                  fontSize: 22,
                                                                  color:
                                                                      Colors
                                                                          .black,
                                                                ),
                                                              ),
                                                              duration: Duration(
                                                                milliseconds:
                                                                    2000,
                                                              ),
                                                              backgroundColor:
                                                                  Colors.white,
                                                            ),
                                                          );
                                                          Navigator.pop(
                                                            context,
                                                          );
                                                        } else {
                                                          sayacNesne.sifirla();
                                                          Navigator.pop(
                                                            context,
                                                          );
                                                          ScaffoldMessenger.of(
                                                            context,
                                                          ).showSnackBar(
                                                            SnackBar(
                                                              content: Text(
                                                                "Siparişiniz onaylandı 30-40 dk içerisinde kapınızda",
                                                                style: TextStyle(
                                                                  fontSize: 22,
                                                                  color:
                                                                      Colors
                                                                          .black,
                                                                ),
                                                              ),
                                                              duration: Duration(
                                                                milliseconds:
                                                                    2000,
                                                              ),
                                                              backgroundColor:
                                                                  Colors.white,
                                                            ),
                                                          );
                                                        }
                                                      },
                                                      child: Text(
                                                        "Onayla",
                                                        style: TextStyle(
                                                          color: Colors.green,
                                                          fontSize: 20,
                                                        ),
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
                                icon: Icon(
                                  Icons.shopping_basket_outlined,
                                  color: Colors.green,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                      leading: IconButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Fırsattan faydalanmak için en az 3 adet sipariş etmeniz gerekiyor",
                              ),
                            ),
                          );
                        },
                        icon: Icon(Icons.info_outline, color: Colors.green),
                      ),
                    ),
                    body: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 10),
                          Card(
                            elevation: 20,
                            shadowColor: Colors.white,
                            shape: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: Colors.greenAccent,
                                width: 3.0,
                              ),
                            ),
                            child: Image.asset(
                              "resimler/burger.png",
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(height: 20),
                          Text("""
                          🔥 Lezzetin En Sıcak Hali! 🔥
%100 dana etiyle hazırlanmış, yumuşacık ekmeğin arasında eriyen cheddar peyniri, taptaze marullar ve özel sosumuzla Burger keyfini zirvede yaşayın!
Her ısırıkta “Bir tane daha isterim” dedirtecek bu lezzeti kaçırmayın! 🥩🧀🥬

✅ Sıcacık
✅ Doyurucu
✅ Tam bir lezzet patlaması

💥 Şimdi sipariş ver, sıcağı sıcağına kapında olsun! 💥
                          """),
                          SizedBox(height: 10),
                          SizedBox(
                            width: 250,
                            child: Card(
                              shape: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                  color: Colors.green,
                                  width: 3.0,
                                ),
                              ),
                              color: Colors.white,
                              shadowColor: Colors.white54,
                              elevation: 10,
                              child: Consumer<FirsatUrunFirsat>(
                                builder: (context, sayacNesne, child) {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          sayacNesne.urunSil();
                                        },
                                        icon: Icon(
                                          Icons.remove,
                                          color: Colors.red,
                                          size: 30,
                                        ),
                                      ),
                                      SizedBox(width: 20),
                                      IconButton(
                                        onPressed: () {
                                          sayacNesne.urunEkle();
                                        },
                                        icon: Icon(
                                          Icons.add,
                                          color: Colors.green,
                                          size: 30,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
            ),
          );
        },
        child: Card(
          elevation: 10,
          shadowColor: Colors.white,
          shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.greenAccent, width: 3.0),
          ),
          color: Colors.white54,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Shimmer.fromColors(
                baseColor: Colors.black,
                highlightColor: Colors.white54,
                child: Text("""
            
            SADECE
               25
               TL
          """, style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
              ),
              SizedBox(width: 50),
              Image.asset("resimler/burger.png"),
            ],
          ),
        ),
      ),
    );
  }

  Widget puanIconu() {
    return Consumer<PuanSayac>(
      builder: (context, puanNesne, child) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    premiumOkuma();
    tabController = TabController(length: 3, vsync: this);
    favoriTavukgetir();
    favoriEtgetir();
    favoriCorbagetir();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.center,
          child: Text(
            "Ana Sayfa",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          ),
        ),
        actions: [
          Consumer<TemaDegisimiOkuma>(
            builder: (context, temaNesne, chid) {
              return IconButton(
                onPressed: () {
                  temaNesne.TemaDegistir();
                },
                icon:
                    temaNesne.temaOku()
                        ? Icon(Icons.wb_sunny, color: Colors.amber, size: 27)
                        : Icon(
                          Icons.nights_stay,
                          color: Colors.blueGrey,
                          size: 27,
                        ),
              );
            },
          ),
        ],
      ),
      backgroundColor: Colors.black,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.cyanAccent),
              child: Text(
                "Ayarlar",
                style: TextStyle(fontSize: 30, color: Colors.black),
              ),
            ),

            ListTile(
              leading: Icon(Icons.home, color: Colors.cyan),
              title: Text("Ana Sayfa"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.qr_code),
              title: Text("Kare Kod"),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      shadowColor: Colors.black,
                      elevation: 10,
                      backgroundColor: Colors.white,
                      shape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: Colors.greenAccent,
                          width: 5.0,
                        ),
                      ),
                      title: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Kare Kod Sayfası",
                          style: TextStyle(fontSize: 30, color: Colors.black),
                        ),
                      ),
                      content: SizedBox(
                        width: 300,
                        height: 400,
                        child: Center(
                          child: QrImageView(
                            data: karekodMesaji,
                            // Qr kod içerisine gönderilecek veri
                            version: QrVersions.auto,
                            //versiyon otomotik ayarlansın
                            size: 250,
                            // boyutu
                            gapless: false, // kareler arası boşluk var
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.info_outline, color: Colors.indigoAccent),
              title: Text("Hakkında"),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Uygulama Hakkında Bilgilendirme",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      shape: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.greenAccent,
                          width: 5.0,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      backgroundColor: Colors.white,
                      content: SizedBox(
                        width: 350,
                        height: 370,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                """
🍔 Yemek Sepeti – Lezzet Avına Hoş Geldin!

🔥 Açlığını Erteleme, Lezzeti Yakala! 🔥
🍕 İster pizza, ister burger, ister tatlı…
🛒 Sepetine ekle → 💳 Öde → 🚀 Kapında!
💎 Özel fırsatlar, indirimler ve taptaze lezzetler seni bekliyor!
                            
                            """,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "Kapat",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                    ),
                                  ),
                                  style: TextButton.styleFrom(
                                    shadowColor: Colors.black,
                                    elevation: 10,
                                    backgroundColor: Colors.teal,
                                    side: BorderSide(
                                      color: Colors.greenAccent,
                                      width: 2.0,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.outgoing_mail, color: Colors.green),
              title: Text("Geri Bildirim"),
              onTap: () {
                mailControl();
              },
            ),
            Consumer<PuanSayac>(
              builder: (context, puanNesne, child) {
                return ListTile(
                  leading: Icon(
                    Icons.star_border_purple500,
                    color: Colors.yellowAccent,
                  ),
                  title: Text("Bize Puan Verin"),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: Colors.white,
                          shadowColor: Colors.black,
                          shape: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                              color: Colors.greenAccent,
                              width: 3.0,
                            ),
                          ),
                          title: Text(
                            "Bize Puan Verin",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          content: SizedBox(
                            width: 500,
                            height: 450,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("""
     ⭐ Uygulamamızı Beğendiniz mi?
Memnuniyetiniz bizim için çok değerli!
Bize puan vererek daha iyi hizmet sunmamıza yardımcı olun. 💛
                          
Eğer biraz daha enerjik ve satış dili gibi olsun istersen:
                          
            🌟 Sizi Seviyoruz!
Eğer siz de bizi seviyorsanız,bize 10 puan verin ve mutluluğumuzu paylaşın! 💫
                                  """, style: TextStyle(color: Colors.black)),
                                  SizedBox(
                                    width: 100,
                                    height: 50,
                                    child: Card(
                                      shadowColor: Colors.black,
                                      elevation: 10,
                                      shape: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: BorderSide(
                                          color: Colors.greenAccent,
                                          width: 2.0,
                                        ),
                                      ),
                                      color: Colors.white60,
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "${puanNesne.puanOku()}/10",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 20,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Card(
                                    shape: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.greenAccent,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    shadowColor: Colors.black,
                                    elevation: 20,
                                    color: Colors.white60,
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              puanNesne.puanSil();
                                            },
                                            icon: Icon(
                                              Icons.remove,
                                              color: Colors.black,
                                              size: 24,
                                            ),
                                            style: IconButton.styleFrom(
                                              side: BorderSide(
                                                color: Colors.black,
                                                width: 2.0,
                                              ),
                                              backgroundColor: Colors.redAccent,
                                            ),
                                          ),
                                          SizedBox(width: 3),
                                          IconButton(
                                            onPressed: () {
                                              puanNesne.puanArtir();
                                            },
                                            icon: Icon(
                                              Icons.add,
                                              color: Colors.black,
                                              size: 24,
                                            ),
                                            style: IconButton.styleFrom(
                                              side: BorderSide(
                                                color: Colors.black,
                                                width: 2.0,
                                              ),
                                              backgroundColor:
                                                  Colors.greenAccent,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                puanNesne.puanSifirla();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Uygulamayı puanladığınız için teşekkür ederiz",
                                      style: TextStyle(
                                        fontSize: 21,
                                        color: Colors.black,
                                      ),
                                    ),
                                    duration: Duration(milliseconds: 2500),
                                    backgroundColor: Colors.white,
                                  ),
                                );
                                Navigator.pop(context);
                              },
                              child: Text(
                                "Gönder",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                              ),
                              style: TextButton.styleFrom(
                                shadowColor: Colors.black,
                                elevation: 10,
                                backgroundColor: Colors.teal,
                                side: BorderSide(
                                  color: Colors.greenAccent,
                                  width: 2.0,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 15),

              Shimmer.fromColors(
                baseColor: Colors.white54,
                highlightColor: Colors.white,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Bugün en çok tercih edilenler",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(height: 15),
              encokTercihEdilen(),
              SizedBox(height: 30),
              Shimmer.fromColors(
                baseColor: Colors.white54,
                highlightColor: Colors.white,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Favori üçlüler",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              TabBar(
                controller: tabController,
                isScrollable: true,
                labelColor: Colors.greenAccent,
                unselectedLabelColor: Colors.white,
                indicatorColor: Colors.greenAccent,
                tabs: const [
                  Tab(text: "Tavuk"),
                  Tab(text: "Et"),
                  Tab(text: "Çorba"),
                ],
              ),
              SizedBox(
                height: 250,
                child: TabBarView(
                  controller: tabController,
                  children: [
                    EncokTercihEdilenWidget(
                      url:
                          "https://www.themealdb.com/api/json/v1/1/search.php?s=chicken",
                    ),
                    EncokTercihEdilenWidget(
                      url:
                          "https://www.themealdb.com/api/json/v1/1/search.php?s=eat",
                    ),
                    EncokTercihEdilenWidget(
                      url:
                          "https://www.themealdb.com/api/json/v1/1/search.php?s=soup",
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),

              premiumGosterme(),
              SizedBox(height: 30),
              Shimmer.fromColors(
                baseColor: Colors.white54,
                highlightColor: Colors.white,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Fırsat Ürün",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(height: 15),
              idirimliUrun(),
              SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}

// 🔹 Ortak Base Widget
class EncokTercihEdilenWidget extends StatefulWidget {
  final String url;

  EncokTercihEdilenWidget({required this.url});

  @override
  State<EncokTercihEdilenWidget> createState() =>
      _EncokTercihEdilenWidgetState();
}

class _EncokTercihEdilenWidgetState extends State<EncokTercihEdilenWidget> {
  List<Meal> yemekListe = [];
  bool yukleniyor = true;

  Future<void> encokaalinanuc() async {
    try {
      var cevap = await http.get(Uri.parse(widget.url));

      if (cevap.statusCode == 200) {
        final jsonVeri = json.decode(cevap.body);
        final mealsJson = jsonVeri["meals"];

        if (mealsJson != null && mealsJson.isNotEmpty) {
          for (var i = 0; i < 3 && i < mealsJson.length; i++) {
            yemekListe.add(Meal.fromJson(mealsJson[i]));
          }
        }
      }
    } catch (e) {
      print("Hata: $e");
    }

    setState(() {
      yukleniyor = false;
    });
  }

  @override
  void initState() {
    super.initState();
    encokaalinanuc();
  }

  @override
  Widget build(BuildContext context) {
    if (yukleniyor) {
      // Bu yapı veriler gelmeden önce çalışıyor
      return Shimmer.fromColors(
        baseColor: Colors.white54,
        highlightColor: Colors.white,
        child: ListView.builder(
          itemCount: 3,
          itemBuilder: (context, index) {
            return ListTile(
              leading: CircleAvatar(radius: 25, backgroundColor: Colors.grey),
              title: Container(height: 15, color: Colors.grey),
              subtitle: Container(height: 12, color: Colors.grey),
            );
          },
        ),
      );
    }

    return ListView.builder(
      // Yüklenme bittiği vakit çalışıcak
      itemCount: yemekListe.length,
      itemBuilder: (context, index) {
        final meal = yemekListe[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(meal.strMealThumb ?? ""),
          ),
          title: Text(meal.strMeal ?? "İsimsiz",style: TextStyle(color: Colors.cyan),),
          subtitle: Text(meal.strCategory ?? "",style: TextStyle(color: Colors.white),),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => StorySayfasi(meal)),
            );
          },
        );
      },
    );
  }
}

class TemaDegisimiOkuma extends ChangeNotifier {
  bool koyuTemami = true;

  bool temaOku() {
    return koyuTemami;
  }

  void TemaDegistir() {
    koyuTemami = !koyuTemami;
    notifyListeners();
  }
}

class PuanSayac extends ChangeNotifier {
  int puan = 0;

  int puanOku() {
    return puan;
  }

  void puanArtir() {
    if (puanOku() >= 0 && puanOku() < 10) {
      puan += 1;
      notifyListeners();
    }
  }

  void puanSil() {
    if (puanOku() > 0 && puanOku() <= 10) {
      puan -= 1;
      notifyListeners();
    }
  }

  void puanSifirla() {
    puan = 0;
    notifyListeners();
  }
}
