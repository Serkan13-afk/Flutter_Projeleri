import 'dart:collection';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:yemek_siparis_uyg/AnaSayfa.dart';
import 'package:yemek_siparis_uyg/FirsatUrunSayac.dart';
import 'package:yemek_siparis_uyg/GecisSayfasi.dart';
import 'package:yemek_siparis_uyg/SepetCubit.dart';

import 'Kisiler2.dart';
import 'SepetSayac.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Firebase başlatılıyor
  runApp(
    // bU İKİ İFADENİN SIRASI ÖNEMLİDİR
    MultiBlocProvider(
      providers: [BlocProvider(create: (_) => SepetCubit())],
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => SepetSayac()),
          ChangeNotifierProvider(create: (_) => FirsatUrunFirsat()),
          ChangeNotifierProvider(create: (_) => TemaDegisimiOkuma()),
          ChangeNotifierProvider(create: (_) => PuanSayac()),
        ],
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => SepetCubit())],
      child: Consumer<TemaDegisimiOkuma>(
        builder: (context, temaNesne, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              useMaterial3: true, // yeni sürüm için
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.deepPurple,
                brightness:
                    temaNesne.temaOku() ? Brightness.dark : Brightness.light,
              ),
              bottomNavigationBarTheme: BottomNavigationBarThemeData(
                selectedItemColor:
                    temaNesne.temaOku()
                        ? Colors.cyanAccent
                        : Colors.cyanAccent,
                unselectedItemColor:
                    temaNesne.temaOku()
                        ? Colors.grey.shade500
                        : Colors.grey.shade600,
              ),
            ),
            home: MyHomePage(),
          );
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Kisiler2 kisi;

  var kayitsecilimi = false;
  var sifregizliMi = true;
  late TextEditingController girismail;
  late TextEditingController girissifre;
  late TextEditingController kayitad;
  late TextEditingController kayitsoyad;
  late TextEditingController kayitmail;
  late TextEditingController kayitsifre;
  late TextEditingController kayittekrarsifre;
  late TextEditingController sifreunuttummail;
  late TextEditingController sifreunuttumyenisifre;
  var refKisiler = FirebaseDatabase.instance.ref().child("kisiler_tablo");

  Future<void> girisKontrolOnce(String mail, String sifre) async {
    var kisibulundumu = false;

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
        if (mail.isEmpty || sifre.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Boş alanlar var tekrar deneyiniz"),
              backgroundColor: Colors.red,
            ),
          );
          girismail.clear();
          girissifre.clear();
          return;
        } else {
          print(mail + " " + sifre);
          gelenDegerler.forEach((key, nesne) {
            var gelenKisi = Kisiler2.fromJson(nesne);
            print("Selam2");
            if (mail == gelenKisi.mail && sifre == gelenKisi.sifre) {
              kisi = gelenKisi;
              kisibulundumu = true;
              print("Selam3");
            }
          });
          if (kisibulundumu) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Tebrikler giriş yaptınız"),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Gecissayfasi(kisi)),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Şifreniz veya kulanıcı adınız yanlış"),
                backgroundColor: Colors.red,
              ),
            );
          }
          girismail.clear();
          girissifre.clear();
        }
      }
    });
  }

  Future<void> kisiKayit(
    String ad,
    String soyad,
    String mail,
    String sifre,
    String sifreTekrar,
  ) async {
    if (ad.isEmpty ||
        soyad.isEmpty ||
        mail.isEmpty ||
        sifre.isEmpty ||
        sifreTekrar.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Boş alanlar var kontrol edip tekrar deneyin"),
          duration: Duration(milliseconds: 2500),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      var bilgi = HashMap<String, dynamic>();
      bilgi["ad"] = ad;
      bilgi["soyad"] = soyad;
      bilgi["mail"] = mail;
      bilgi["sifre"] = sifre;
      bilgi["siparis_Adres"] = "";
      bilgi["premiumVarmi"] = false;

      refKisiler.push().set(bilgi);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Başarılı bir şekilde kayıt yaptırıldı"),
          backgroundColor: Colors.green,
        ),
      );
    }
    kayitad.clear();
    kayitsoyad.clear();
    kayitmail.clear();
    kayitsifre.clear();
    kayittekrarsifre.clear();
  }

  Future<void> sifreUnuttum(String mail, String sifre) async {
    var kisiBulundumu = false;
    var key1 = "";
    if (mail.isEmpty || sifre.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Boş alanlar mevcut"),
          duration: Duration(milliseconds: 2500),
          backgroundColor: Colors.red,
        ),
      );
      sifreunuttummail.clear();
      sifreunuttumyenisifre.clear();
      return;
    } else {
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
          var gelenKisi = Kisiler2.fromJson(nesne);
          if (mail == gelenKisi.mail) {
            kisiBulundumu = true;
            kisi = gelenKisi;
            key1 = key;
          }
          if (kisiBulundumu) {
            var guncelbilgi = HashMap<String, dynamic>();
            guncelbilgi["ad"] = gelenKisi.ad;
            guncelbilgi["mail"] = mail;
            guncelbilgi["sifre"] = sifre;
            guncelbilgi["soyad"] = gelenKisi.soyad;
            guncelbilgi["siparis_Adres"] = gelenKisi.siparisAdres;
            guncelbilgi["premiumVarmi"] = gelenKisi.premiumVarmi;
            refKisiler.child(key1).update(guncelbilgi);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Şifreniz başarılı bir şekilde değiştirildi"),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          }
        });
      });
      sifreunuttummail.clear();
      sifreunuttumyenisifre.clear();
    }
  }

  @override
  void dispose() {
    super.dispose();
    girismail.dispose();
    girissifre.dispose();
    kayitmail.dispose();
    kayitsifre.dispose();
    kayitad.dispose();
    kayitsoyad.dispose();
    kayittekrarsifre.dispose();
    sifreunuttummail.dispose();
    sifreunuttumyenisifre.dispose();
  }

  @override
  void initState() {
    super.initState();
    girismail = TextEditingController();
    girissifre = TextEditingController();
    kayitmail = TextEditingController();
    kayitsifre = TextEditingController();
    kayitad = TextEditingController();
    kayitsoyad = TextEditingController();

    kayittekrarsifre = TextEditingController();
    sifreunuttummail = TextEditingController();
    sifreunuttumyenisifre = TextEditingController();
  }

  Widget girisVekayitsayfaAcma() {
    if (!kayitsecilimi) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 40),
            SizedBox(
              width: 350,
              child: TextField(
                controller: girismail,
                maxLength: 25,

                decoration: InputDecoration(
                  label: Text("Mail adresinizi giriniz"),
                  labelStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 21,
                  ),
                  prefixIcon: Icon(Icons.mail, color: Colors.black),
                  filled: true,
                  fillColor: Colors.pink,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),

            SizedBox(
              width: 350,
              child: TextField(
                controller: girissifre,
                obscureText: sifregizliMi ? true : false,
                maxLength: 25,

                decoration: InputDecoration(
                  label: Text("Şifrenizi giriniz"),
                  labelStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 21,
                  ),
                  prefixIcon: Icon(Icons.lock, color: Colors.black),
                  suffixIcon:
                      sifregizliMi
                          ? IconButton(
                            onPressed: () {
                              setState(() {
                                sifregizliMi = false;
                              });
                            },
                            icon: Icon(
                              Icons.visibility_off_outlined,
                              color: Colors.white54,
                            ),
                          )
                          : IconButton(
                            onPressed: () {
                              setState(() {
                                sifregizliMi = true;
                              });
                            },
                            icon: Icon(Icons.visibility, color: Colors.white),
                          ),
                  filled: true,
                  fillColor: Colors.pink,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            SizedBox(
              width: 300,
              height: 50,

              child: ElevatedButton(
                onPressed: () {
                  girisKontrolOnce(girismail.text, girissifre.text);
                },
                child: Text("Giriş yap", style: TextStyle(color: Colors.black)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  side: BorderSide(color: Colors.greenAccent),
                  elevation: 10,
                  shadowColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      );
    }
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          SizedBox(
            width: 350,
            child: TextField(
              controller: kayitad,
              maxLength: 15,

              decoration: InputDecoration(
                label: Text("Adınızı giriniz"),
                labelStyle: TextStyle(color: Colors.white, fontSize: 21),
                prefixIcon: Icon(Icons.person, color: Colors.black),
                filled: true,
                fillColor: Colors.pink,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ),
          SizedBox(height: 5),

          SizedBox(
            width: 350,
            child: TextField(
              controller: kayitsoyad,
              maxLength: 15,
              decoration: InputDecoration(
                label: Text("Soyadınızı giriniz"),
                labelStyle: TextStyle(color: Colors.white, fontSize: 21),
                prefixIcon: Icon(Icons.person_outline, color: Colors.black),
                filled: true,
                fillColor: Colors.pink,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ),
          SizedBox(height: 5),
          SizedBox(
            width: 350,
            child: TextField(
              controller: kayitmail,
              maxLength: 25,

              decoration: InputDecoration(
                label: Text("Geçerli bir mail adresi giriniz"),
                labelStyle: TextStyle(color: Colors.white, fontSize: 19),
                prefixIcon: Icon(Icons.mail, color: Colors.black),

                filled: true,
                fillColor: Colors.pink,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ),

          SizedBox(
            width: 350,
            child: TextField(
              controller: kayitsifre,
              obscureText: sifregizliMi ? true : false,
              maxLength: 25,

              decoration: InputDecoration(
                label: Text("Şifrenizi giriniz"),
                labelStyle: TextStyle(color: Colors.white, fontSize: 21),
                prefixIcon: Icon(Icons.lock, color: Colors.black),
                suffixIcon:
                    sifregizliMi
                        ? IconButton(
                          onPressed: () {
                            setState(() {
                              sifregizliMi = false;
                            });
                          },
                          icon: Icon(
                            Icons.visibility_off_outlined,
                            color: Colors.white54,
                          ),
                        )
                        : IconButton(
                          onPressed: () {
                            setState(() {
                              sifregizliMi = true;
                            });
                          },
                          icon: Icon(Icons.visibility, color: Colors.white),
                        ),
                filled: true,
                fillColor: Colors.pink,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ),
          SizedBox(height: 5),
          SizedBox(
            width: 350,
            child: TextField(
              controller: kayittekrarsifre,
              obscureText: true,
              maxLength: 25,

              decoration: InputDecoration(
                label: Text("Şifrenizi tekrar giriniz"),
                labelStyle: TextStyle(color: Colors.white, fontSize: 21),
                prefixIcon: Icon(Icons.lock_reset, color: Colors.black),
                filled: true,
                fillColor: Colors.pink,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 300,
            height: 50,

            child: ElevatedButton(
              onPressed: () {
                kisiKayit(
                  kayitad.text,
                  kayitsoyad.text,
                  kayitmail.text,
                  kayitsifre.text,
                  kayittekrarsifre.text,
                );
              },
              child: Text("Kayıt yap", style: TextStyle(color: Colors.black)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                side: BorderSide(color: Colors.greenAccent, width: 2.0),
                elevation: 10,
                shadowColor: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 15),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset("iconlar/yemekanima.json"),
              SizedBox(height: 40),
              SizedBox(
                width: 200,
                child: Card(
                  shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: Colors.greenAccent,
                      width: 1.0,
                    ),
                  ),
                  shadowColor: Colors.white,
                  color: Colors.black,
                  elevation: 10,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              kayitsecilimi = false;
                            });
                          },
                          icon: Icon(
                            Icons.login_rounded,
                            color: kayitsecilimi ? Colors.red : Colors.green,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              kayitsecilimi = true;
                            });
                          },
                          icon: Icon(
                            Icons.app_registration,
                            color: kayitsecilimi ? Colors.green : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              girisVekayitsayfaAcma(),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        shape: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: Colors.greenAccent,
                            width: 5.0,
                          ),
                        ),
                        backgroundColor: Colors.white,
                        title: Text(
                          "Şifremi Unuttum Sayfası",
                          style: TextStyle(color: Colors.black),
                        ),
                        content: SizedBox(
                          height: 400,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 450,
                                  child: TextField(
                                    controller: sifreunuttummail,
                                    maxLength: 25,
                                    decoration: InputDecoration(
                                      label: Text(
                                        "Sistemde kayıtlı mailinizi giriniz",
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      labelStyle: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 21,
                                      ),
                                      prefixIcon: Icon(
                                        Icons.mail,
                                        color: Colors.black,
                                      ),
                                      filled: true,
                                      fillColor: Colors.pink,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),
                                SizedBox(
                                  width: 450,
                                  child: TextField(
                                    controller: sifreunuttumyenisifre,
                                    obscureText: false,
                                    maxLength: 25,

                                    decoration: InputDecoration(
                                      label: Text(
                                        "Yeni şifrenizi giriniz",
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      labelStyle: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 21,
                                      ),
                                      prefixIcon: Icon(
                                        Icons.lock,
                                        color: Colors.black,
                                      ),

                                      filled: true,
                                      fillColor: Colors.pink,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        "İptal",
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.teal,
                                        side: BorderSide(
                                          color: Colors.greenAccent,
                                        ),
                                        elevation: 10,
                                        shadowColor: Colors.black,
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        sifreUnuttum(
                                          sifreunuttummail.text,
                                          sifreunuttumyenisifre.text,
                                        );
                                      },
                                      child: Text(
                                        "Onayla",
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.teal,
                                        side: BorderSide(
                                          color: Colors.greenAccent,
                                        ),
                                        elevation: 10,
                                        shadowColor: Colors.black,
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

                child: Text(
                  "Şifreni mi unuttun ?",
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}


