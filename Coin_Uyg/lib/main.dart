import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:kripto_uyg/FavoriCoinCubit.dart';
import 'package:kripto_uyg/KisiCevap.dart';
import 'package:shimmer/shimmer.dart';
import 'package:kripto_uyg/Kisi.dart';

import 'Navigator_GecisSayfasi.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => FavoriCoinCubit())
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  var seciliMi = false;

  late AnimationController animationController;
  late AnimationController animationController2;

  late Animation<double> scaleanimationDegerleri;
  late Animation<double> traslateanimationDegerleri;

  var ad_control = TextEditingController();
  var soyad_control = TextEditingController();
  var mail_control = TextEditingController();
  var sifre_control = TextEditingController();
  var mail_control2 = TextEditingController();
  var sifre_control2 = TextEditingController();

  List<Kisi> verilerParse(String cevap) {
    var jsonVeri = json.decode(cevap);
    return KisiCevap.fromJson(jsonVeri).kriptoListesi;
  }

  Future<List<Kisi>> tumkisiler() async {
    var url = Uri.parse("http://10.0.2.2/Kriptolar/tum_bilgiler.php");
    var cevap = await http.get(url);

    return verilerParse(cevap.body);
  }

  Future<void> kisiEkle(
    String ad,
    String soyad,
    String mail,
    String sifre,
  ) async {
    var url = Uri.parse("http://10.0.2.2/Kriptolar/insert_bilgiler.php");
    var veri = {"ad": ad, "soyad": soyad, "mail": mail, "sifre": sifre};
    var cevap = await http.post(url, body: veri); //json formatında veri dönecek
  }

  Future<void> veriKontrol() async {
    bool girisbasarilimi = false;

    try {
      if (mail_control.text.isEmpty || sifre_control.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Gerekli alanları doldurunuz",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            backgroundColor: Colors.grey,
            duration: Duration(milliseconds: 5000),
          ),
        );
        return;
      }

      var veriler = await tumkisiler();

      for (Kisi yaz in veriler) {
        if (mail_control.text.trim() == yaz.mail &&
            sifre_control.text.trim() == yaz.sifre) {
          girisbasarilimi = true;
          Kisi girisYapanKisi = yaz;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NavigatorGecissayfasi(girisYapanKisi),
            ),
          );
          break;
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            girisbasarilimi
                ? "Tebrikler giriş yaptınız"
                : "Bilgileriniz yanlış",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.grey,
          duration: Duration(milliseconds: 2000),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Bir hata oluştu: $e",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.redAccent,
          duration: Duration(milliseconds: 5000),
        ),
      );
    } finally {
      // Hangi durumda olursa olsun temizleme burada çalışır
      mail_control.clear();
      sifre_control.clear();
    }
  }

  Future<void> veriKontrol2() async {
    try {
      if (mounted) {
        if (ad_control.text.trim().isEmpty ||
            soyad_control.text.trim().isEmpty ||
            mail_control.text.trim().isEmpty ||
            sifre_control.text.trim().isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Gerekli alanları doldurunuz",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              backgroundColor: Colors.grey,
              duration: Duration(milliseconds: 5000),
            ),
          );
          return;
        }
      }

      await kisiEkle(
        ad_control.text,
        soyad_control.text,
        mail_control.text,
        sifre_control.text,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Tebrikler kayıt yaptırdınız",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            backgroundColor: Colors.grey,
            duration: Duration(milliseconds: 5000),
          ),
        );
        return;
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Bir hata oluştu: $e",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            backgroundColor: Colors.redAccent,
            duration: Duration(milliseconds: 5000),
          ),
        );
      }
    } finally {
      // Hangi durumda olursa olsun temizleme burada çalışır
      ad_control.clear();
      soyad_control.clear();
      mail_control.clear();
      sifre_control.clear();
    }
  }

  @override
  void dispose() {
    mail_control.dispose();
    sifre_control.dispose();
    mail_control2.dispose();
    sifre_control2.dispose();
    animationController.dispose();
    animationController2.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );

    animationController2 = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );

    scaleanimationDegerleri = Tween(begin: 1.0, end: 0.7).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeInOut),
    )..addListener(() {
      setState(() {});
    });

    traslateanimationDegerleri = Tween(begin: -50.0, end: 50.0).animate(
      CurvedAnimation(parent: animationController2, curve: Curves.easeInOut),
    )..addListener(() {
      setState(() {});
    });
    animationController.repeat(reverse: true);
    animationController2.repeat(reverse: true);
  }

  Widget girisSayfa() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Shimmer.fromColors(
          baseColor: Colors.black,
          highlightColor: Colors.white,
          child: Text(
            "Log in",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 20),
        TextField(
          maxLength: 25,
          controller: mail_control,
          decoration: InputDecoration(
            hintText: "Mail adresinizi giriniz ",
            filled: true,
            fillColor: Colors.white38,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          style: TextStyle(color: Colors.white),
        ),
        TextField(
          maxLength: 10,
          controller: sifre_control,
          decoration: InputDecoration(
            hintText: "Şifre giriniz ",
            filled: true,
            fillColor: Colors.white38,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          style: TextStyle(color: Colors.white),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                veriKontrol();
              },
              child: Shimmer.fromColors(
                baseColor: Colors.black,
                highlightColor: Colors.white,
                child: Text(
                  "Log in",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            ),
            SizedBox(width: 10),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: SizedBox(
                        width: 300,
                        height: 500,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextField(
                              controller: mail_control2,
                              maxLength: 25,
                              decoration: InputDecoration(
                                hintText: "Mail adresinizi giriniz",
                                hintStyle: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                                filled: true,
                                fillColor: Colors.white30,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(height: 24),
                            TextField(
                              controller: sifre_control2,
                              maxLength: 25,
                              decoration: InputDecoration(
                                hintText: "Şifrenizi giriniz",
                                hintStyle: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                                filled: true,
                                fillColor: Colors.white30,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              style: TextStyle(color: Colors.white),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  onPressed: () async {
                                    await veriKontrol2();
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "Tamam",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.greenAccent
                                        .withOpacity(0.6),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "İptal",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.redAccent
                                        .withOpacity(0.6),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      backgroundColor: Colors.black54,
                    );
                  },
                );
              },
              child: Shimmer.fromColors(
                baseColor: Colors.black,
                highlightColor: Colors.white,
                child: Text(
                  "Şifremi Unuttum",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget kayitSayfa() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Shimmer.fromColors(
          baseColor: Colors.black,
          highlightColor: Colors.white,
          child: Text(
            "Sing up",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 30),
        TextField(
          maxLength: 25,
          controller: ad_control,
          decoration: InputDecoration(
            hintText: "Adınızı giriniz ",
            filled: true,
            fillColor: Colors.white38,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          style: TextStyle(color: Colors.white),
        ),
        TextField(
          maxLength: 25,
          controller: soyad_control,
          decoration: InputDecoration(
            hintText: "Soy adınızı giriniz ",
            filled: true,
            fillColor: Colors.white38,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          style: TextStyle(color: Colors.white),
        ),

        TextField(
          maxLength: 25,
          controller: mail_control,
          decoration: InputDecoration(
            hintText: "Mail adresinizi giriniz ",
            filled: true,
            fillColor: Colors.white38,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          style: TextStyle(color: Colors.white),
        ),
        TextField(
          maxLength: 10,
          controller: sifre_control,
          obscureText: true,
          decoration: InputDecoration(
            hintText: "Şifre giriniz ",
            filled: true,
            fillColor: Colors.white38,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          style: TextStyle(color: Colors.white),
        ),

        ElevatedButton(
          onPressed: () {
            veriKontrol2();
          },
          child: Shimmer.fromColors(
            baseColor: Colors.black,
            highlightColor: Colors.white,
            child: Text(
              "Sing up",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("resimler/s1.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: Container(
                width: 350,
                // Genişlik
                height: 650,
                // Yükseklik
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.black26, // Şeffaf arka plan
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      // Siyah gölge, düşük opaklık
                      blurRadius: 10,
                      // Gölge yumuşaklığı
                      spreadRadius: 2,
                      // Gölge yayılma miktarı
                      offset: Offset(0, 5), // Gölgenin yönü: aşağıya doğru
                    ),
                  ],
                  borderRadius: BorderRadius.circular(24), // Yuvarlak köşeler
                  border: Border.all(
                    color: Colors.greenAccent.withOpacity(
                      1,
                    ), // Hafif bir çerçeve
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 120,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                seciliMi = true;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  seciliMi ? Colors.green : Colors.red,
                            ),
                            child: Text(
                              'Log in',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        SizedBox(
                          width: 120,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                seciliMi = false;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  seciliMi ? Colors.red : Colors.green,
                            ),
                            child: Text(
                              'Sing up',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20), // Butonlardan sonra boşluk
                    Expanded(
                      child: SingleChildScrollView(
                        child: seciliMi ? girisSayfa() : kayitSayfa(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
