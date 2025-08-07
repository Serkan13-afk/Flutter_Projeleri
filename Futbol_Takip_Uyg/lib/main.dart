import 'dart:collection';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:futbol_takipuyg/FavoriTakimCubit.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';

import 'Kisiler.dart';
import 'NavigatorGecissayfasi.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Firebase başlatılıyor

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => FavoriCubit())],
      child: MaterialApp(
        title: 'Futbol Takip Uyg',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: Login(),
      ),
    );
  }
}

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin {
  late Kisiler kisi;
  late Kisiler kisi2;
  late String key1;
  var kisiBulundumu = false;
  var kisiBulundumu2 = false;
  var kulaniciAdiControl = TextEditingController();
  var sifreControl = TextEditingController();
  var kulaniciAdi2Control = TextEditingController();
  var sifre2Control = TextEditingController();

  var kulaniciAdiSifremiUnuttumControl = TextEditingController();
  var sifreSifremiUnuttumControl = TextEditingController();
  var sifreSifremiUnuttum2Control = TextEditingController();

  late Animation<double> animationDegerleri;
  late AnimationController animationController;
  var refKisiler = FirebaseDatabase.instance.ref().child("kisiler_tablo");

  Future<void> kisiEkle(String kulaniciAdi, String sifre) async {
    if (sifre2Control.text.trim().isEmpty ||
        kulaniciAdi2Control.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Boş alanlar var tekrar deneyiniz"),
          backgroundColor: Colors.red,
        ),
      );
      sifre2Control.clear();
      kulaniciAdi2Control.clear();
      return;
    } else {
      var bilgi = HashMap<String, dynamic>();
      bilgi["kulaniciAdi"] = kulaniciAdi;
      bilgi["sifre"] = sifre;
      refKisiler.push().set(bilgi);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Başarılı bir şekilde kayıt yaptırıldı"),
          backgroundColor: Colors.green,
        ),
      );

      sifre2Control.clear();
      kulaniciAdi2Control.clear();
    }
  }

  Future<void> girisKontrolOnce(String kulaniciAdi, String sifre) async {
    refKisiler.onValue.listen((event) {
      var gelenDegerler = event.snapshot.value as dynamic;

      if (gelenDegerler == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Sistemden veriler çekilemedi"),
            backgroundColor: Colors.red,
          ),
        );
        return;
      } else {
        if (kulaniciAdi.isEmpty || sifre.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Boş alanlar var tekrar deneyiniz"),
              backgroundColor: Colors.red,
            ),
          );
          kulaniciAdiControl.clear();
          sifreControl.clear();
          return;
        } else {
          gelenDegerler.forEach((key, nesne) {
            var gelenKisi = Kisiler.fromJson(nesne);
            if (kulaniciAdi == gelenKisi.kulaniciAdi &&
                sifre == gelenKisi.sifre) {
              kisi2 = gelenKisi;
              kisiBulundumu = true;
            }
          });

          if (kisiBulundumu) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Tebrikler giriş yaptınız"),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NavigatorGecissayfasi(kisi2),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Şifreniz veya kulanıcı adınız yanlış"),
                backgroundColor: Colors.red,
              ),
            );
          }

          kulaniciAdiControl.clear();
          sifreControl.clear();
        }
      }
    });
  }

  Future<void> sifreUnuttum(
    String kulaniciAdi,
    String sifre1,
    String sifre2,
  ) async {
    kisiBulundumu = false; // EKLENDİ
    key1 = ""; // EKLENDİ

    if (kulaniciAdi.isEmpty || sifre1.isEmpty || sifre2.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Boş alanlar var"), backgroundColor: Colors.red),
      );
      kulaniciAdiSifremiUnuttumControl.clear();
      sifreSifremiUnuttumControl.clear();
      sifreSifremiUnuttum2Control.clear();
      return;
    }

    refKisiler.once().then((event) {
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

      gelenDegerler.forEach((key, nesne) {
        var gelenKisi = Kisiler.fromJson(nesne);
        if (kulaniciAdi == gelenKisi.kulaniciAdi) {
          kisiBulundumu = true;
          kisi = gelenKisi;
          key1 = key;
        }
      });

      if (kisiBulundumu) {
        if (sifre1 == sifre2) {
          var guncelbilgi = HashMap<String, dynamic>();
          guncelbilgi["kulaniciAdi"] = kisi.kulaniciAdi;
          guncelbilgi["sifre"] = sifre1;
          refKisiler.child(key1).update(guncelbilgi);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Şifreniz başarılı bir şekilde değiştirildi"),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context); // Alert kapanması için
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Şifreler uyuşmuyor tekrar deneyiniz"),
              backgroundColor: Colors.red,
            ),
          );
        }

        kulaniciAdiSifremiUnuttumControl.clear();
        sifreSifremiUnuttumControl.clear();
        sifreSifremiUnuttum2Control.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Böyle bir kullanıcı bulunamadı"),
            backgroundColor: Colors.red,
          ),
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2000),
    );
    animationDegerleri = Tween(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeOut),
    )..addListener(() {
      setState(() {});
    });
    animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF203A43),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 400,
                height: 398,
                child: Lottie.asset("iconlar/futbolcu.json"),
              ),
        
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: SizedBox(
                  width: 400,
                  child: TextField(
                    maxLength: 30,
                    obscureText: false,
                    controller: kulaniciAdiControl,
                    decoration: InputDecoration(
                      label: Text("Kulanıcı Adınızı Giriniz"),
                      labelStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      filled: true,
                      fillColor:Color(0xFF0288D1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: SizedBox(
                  width: 300,
                  child: TextField(
                    maxLength: 10,
                    obscureText: true,
                    controller: sifreControl,
                    decoration: InputDecoration(
                      label: Text("Şifrenizi Giriniz"),
                      labelStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      filled: true,
                      fillColor: Color(0xFF0288D1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              Transform.scale(
                scale: animationDegerleri.value,
                child: SizedBox(
                  width: 200,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {
                      girisKontrolOnce(
                        kulaniciAdiControl.text.trim(),
                        sifreControl.text.trim(),
                      );
                      // Fire base verileri
                    },
                    child: Shimmer.fromColors(
                      baseColor: Colors.black,
                      highlightColor: Colors.white,
                      child: Text(
                        "Giriş Yap",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFF6F00),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 10,
                ),
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Align(
                            alignment: Alignment.center,
                            child: Shimmer.fromColors(
                              baseColor: Colors.white54,
                              highlightColor: Colors.white,
                              child: Text(
                                "Şifremi Unuttum Sayfasi",
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          content: SingleChildScrollView(
                            child: SizedBox(
                              width: 300,
                              height: 500,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 20,
                                      ),
                                      child: SizedBox(
                                        width: 400,
                                        child: TextField(
                                          maxLength: 25,
                                          obscureText: false,
                                          controller:
                                              kulaniciAdiSifremiUnuttumControl,
                                          decoration: InputDecoration(
                                            label: Text(
                                              "Kulanıcı Adınızı Giriniz",
                                            ),
                                            labelStyle: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                            filled: true,
                                            fillColor: Colors.black54,
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                          ),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 20,
                                      ),
                                      child: SizedBox(
                                        width: 300,
                                        child: TextField(
                                          maxLength: 15,
                                          controller:
                                              sifreSifremiUnuttumControl,
                                          decoration: InputDecoration(
                                            label: Text(
                                              "Yeni Şifrenizi Giriniz",
                                            ),
                                            labelStyle: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                            filled: true,
                                            fillColor: Colors.black54,
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                          ),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                    ),
        
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 20,
                                      ),
                                      child: SizedBox(
                                        width: 300,
                                        child: TextField(
                                          maxLength: 15,
                                          obscureText: true,
                                          controller:
                                              sifreSifremiUnuttum2Control,
                                          decoration: InputDecoration(
                                            label: Text(
                                              "Yeni Şifrenizi Tekrar Giriniz",
                                            ),
                                            labelStyle: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                            filled: true,
                                            fillColor: Colors.black54,
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                          ),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        SizedBox(
                                          width: 120,
                                          height: 40,
                                          child: ElevatedButton(
                                            onPressed: () async {
                                              await sifreUnuttum(
                                                kulaniciAdiSifremiUnuttumControl
                                                    .text
                                                    .trim(),
                                                sifreSifremiUnuttumControl
                                                    .text
                                                    .trim(),
                                                sifreSifremiUnuttum2Control
                                                    .text
                                                    .trim(),
                                              );
                                            },
                                            child: Shimmer.fromColors(
                                              baseColor: Colors.black,
                                              highlightColor: Colors.white,
                                              child: Text(
                                                "Tamam",
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight:
                                                      FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Colors.indigo,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 100,
                                          height: 40,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Shimmer.fromColors(
                                                    baseColor:
                                                        Colors.white54,
                                                    highlightColor:
                                                        Colors.white,
                                                    child: Text(
                                                      "Şifre değiştirme işlemi iptal edildi",
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  duration: Duration(
                                                    milliseconds: 3000,
                                                  ),
                                                  backgroundColor:
                                                      Colors.red,
                                                ),
                                              );
                                            },
                                            child: Shimmer.fromColors(
                                              baseColor: Colors.black,
                                              highlightColor: Colors.white,
                                              child: Text(
                                                "İptal",
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight:
                                                      FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Colors.indigo,
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
                          backgroundColor: Colors.blueGrey,
                        );
                      },
                    );
                  },
                  child: Shimmer.fromColors(
                    baseColor: Colors.black,
                    highlightColor: Colors.cyanAccent,
                    child: Text(
                      "Şifrenimi unuttun geri alalım hemen ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                  ),
                ),
              ),
        
              Padding(
                padding: EdgeInsets.only(right: 30, top: 20),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: FloatingActionButton(
                    backgroundColor: Colors.black,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: Colors.blueGrey,
                            title: Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding: EdgeInsets.only(top: 30),
                                child: Text(
                                  "Kayıt Sayfası",
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            content: SizedBox(
                              width: 300,
                              height: 450,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 20),
                                      child: TextField(
                                        controller: kulaniciAdi2Control,
                                        maxLength: 25,
                                        decoration: InputDecoration(
                                          label: Text(
                                            "Geçerli bir mail adresi giriniz",
                                          ),
                                          labelStyle: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                          filled: true,
                                          fillColor: Colors.blue,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                        ),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                    TextField(
                                      controller: sifre2Control,
                                      maxLength: 10,
                                      obscureText: true,
                                      decoration: InputDecoration(
                                        label: Text(
                                          "Geçerli bir şifre giriniz",
                                        ),
                                        labelStyle: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                        filled: true,
                                        fillColor: Colors.blue,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                      ),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    SizedBox(height: 30),
        
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                duration: Duration(
                                                  milliseconds: 3000,
                                                ),
                                                backgroundColor: Colors.red,
                                                content: Text(
                                                  "Kayıt işlemi iptal edildi",
                                                ),
                                              ),
                                            );
                                          },
                                          child: Shimmer.fromColors(
                                            baseColor: Colors.black,
                                            highlightColor: Colors.white,
                                            child: Text(
                                              "İptal",
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.indigo,
                                          ),
                                        ),
        
                                        ElevatedButton(
                                          onPressed: () async {
                                            await kisiEkle(
                                              kulaniciAdi2Control.text,
                                              sifre2Control.text,
                                            );
                                            Navigator.pop(context);
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                duration: Duration(
                                                  milliseconds: 3000,
                                                ),
                                                backgroundColor:
                                                    Colors.green,
                                                content: Text(
                                                  "Kayıt işlemi başarılı bir şekilde yapıldı",
                                                ),
                                              ),
                                            );
                                          },
                                          child: Shimmer.fromColors(
                                            baseColor: Colors.black,
                                            highlightColor: Colors.white,
                                            child: Text(
                                              "Tamam",
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.indigo,
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
                    child: Icon(Icons.add, size: 20, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
