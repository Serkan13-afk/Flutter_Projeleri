import 'dart:collection';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lottie/lottie.dart';
import 'package:movieapp/GecisSayfalari.dart';
import 'package:movieapp/KayitliCubit.dart';
import 'package:movieapp/generated/l10n.dart';
import 'package:provider/provider.dart';
import 'package:movieapp/Kisiler.dart';
import 'package:movieapp/Providerler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize(); // AdMob başlat
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        BlocProvider(create: (_) => KayitliCubit()),
        // böyle daha sade ve anlaşılır
        ChangeNotifierProvider(create: (_) => TemaOkuma()),
        ChangeNotifierProvider(create: (_) => DilOkuma()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TemaOkuma>(
      builder: (context, temaNesne, child) {
        return Consumer<DilOkuma>(
          builder: (context, dilNesne, child) {
            return MaterialApp(
              title: 'Movie App',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                useMaterial3: true,
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
                          : Colors.grey.shade500,
                ),
              ),

              // Sistem dilini al
              locale: dilNesne.guncelDilOku(),
              // sistem dili
              supportedLocales: S.delegate.supportedLocales,
              // desteklenen diller arb
              localizationsDelegates: const [
                S.delegate,
                // Flutter Intl plugin ile oluşturulan çeviri sınıfı
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              home: MyHomePage(),
            );
          },
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late TextEditingController girisMailController;
  late TextEditingController girisSifreController;
  late TextEditingController kayitMailController;
  late TextEditingController kayitSifreController;
  late TextEditingController kayitSifreTekrarController;
  late TextEditingController sifreMiunuttumMailController;
  late TextEditingController sifreMiunuttumSifreController;
  late TextEditingController kayitAdController;
  late TextEditingController kayitSoyadController;
  var refKisiler = FirebaseDatabase.instance.ref().child("kisiler_tablo");
  late Kisiler kisiler1;
  late Kisiler kisiler2;
  bool girisSecilimi = true;
  bool sifreGorunsunMu = false;
  bool sifreGorunsunMu1 = false;
  var sistemdekulanilacakKey;
  bool diliconuBasildiMi = false;
  bool turkceMi = true;

  Widget temaIconu() {
    return Consumer<TemaOkuma>(
      builder: (context, temaNesne, child) {
        return IconButton(
          onPressed: () {
            temaNesne.temaDegistir();
          },
          icon:
              temaNesne.temaOku()
                  ? Icon(Icons.sunny, color: Colors.yellowAccent, size: 30)
                  : Icon(
                    Icons.nights_stay_outlined,
                    color: Colors.blueGrey,
                    size: 30,
                  ),
        );
      },
    );
  }

  Widget giriskayit() {
    return SizedBox(
      height: 75,
      child: Card(
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.greenAccent, width: 1.5),
        ),
        shadowColor: Colors.white,
        elevation: 10,
        color: Colors.blueGrey,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 55,
                width: 180,
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      girisSecilimi = true;
                    });
                  },
                  child: Text(
                    S.of(context).giris_yap,
                    style: TextStyle(
                      color: girisSecilimi ? Colors.black : Colors.white,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor:
                        girisSecilimi ? Colors.tealAccent : Colors.grey[800],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    side:
                        girisSecilimi
                            ? BorderSide(color: Colors.white)
                            : BorderSide(color: Colors.black),
                  ),
                ),
              ),
              SizedBox(width: 5),
              SizedBox(
                height: 55,
                width: 180,
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      girisSecilimi = false;
                    });
                  },
                  child: Text(
                    S.of(context).kayit_yap,
                    style: TextStyle(
                      color: girisSecilimi ? Colors.white : Colors.black,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor:
                        girisSecilimi ? Colors.grey[800] : Colors.tealAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    side:
                        girisSecilimi
                            ? BorderSide(color: Colors.black)
                            : BorderSide(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget dilIcon() {
    return Consumer<TemaOkuma>(
      builder: (context, temaNesne, child) {
        return Consumer<DilOkuma>(
          builder: (context, dilNesne, child) {
            return SizedBox(
              width: 300,
              child: Card(
                shape: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    color: Colors.yellowAccent,
                    width: 1.5,
                  ),
                ),
                shadowColor: temaNesne.temaOku() ? Colors.white : Colors.black,
                elevation: 10,
                color: Colors.cyan,
                child: Center(
                  child:
                      diliconuBasildiMi
                          ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(width: 60),
                                  Icon(
                                    turkceMi
                                        ? Icons.radio_button_checked
                                        : Icons.radio_button_unchecked,
                                  ),
                                  SizedBox(width: 10),
                                  GestureDetector(
                                    onTap: () {
                                      dilNesne.dilDegis(Locale("tr"));
                                      setState(() {
                                        turkceMi = true;
                                      });
                                    },

                                    child: Text("Türkçe olarak ayarla"),
                                  ),

                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        diliconuBasildiMi = !diliconuBasildiMi;
                                      });
                                    },
                                    icon: Icon(Icons.expand_less),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    turkceMi
                                        ? Icons.radio_button_unchecked
                                        : Icons.radio_button_checked,
                                  ),
                                  SizedBox(width: 10),
                                  GestureDetector(
                                    onTap: () {
                                      dilNesne.dilDegis(Locale("en"));
                                      setState(() {
                                        turkceMi = false;
                                      });
                                    },
                                    child: Text("Set in English"),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                            ],
                          )
                          : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Sistem dili / System language"),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          diliconuBasildiMi =
                                              !diliconuBasildiMi;
                                        });
                                      },
                                      icon: Icon(Icons.expand_more_outlined),
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
    );
  }

  Widget giriskayitekranGoster() {
    return Consumer<TemaOkuma>(
      builder: (context, temaNesne, child) {
        return Card(
          shadowColor: temaNesne.temaOku() ? Colors.white : Colors.black,
          elevation: 10,
          shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.greenAccent, width: 2.5),
          ),
          color: Theme.of(context).scaffoldBackgroundColor,

          child: Center(
            child:
                girisSecilimi
                    ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 10),
                        SizedBox(
                          width: 360,
                          child: TextField(
                            controller: girisMailController,
                            obscureText: false,
                            decoration: InputDecoration(
                              label: Text(S.of(context).mail_adresi_gir_giris),
                              filled: true,
                              fillColor:
                                  temaNesne.temaOku()
                                      ? Colors.grey[800]
                                      : Colors.grey[200],
                              labelStyle: TextStyle(
                                color:
                                    temaNesne.temaOku()
                                        ? Colors.white
                                        : Colors.black,
                              ),
                              prefixIcon: Icon(
                                Icons.mail_outline,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        SizedBox(
                          width: 360,
                          child: TextField(
                            controller: girisSifreController,
                            obscureText: sifreGorunsunMu,
                            decoration: InputDecoration(
                              label: Text(S.of(context).sifre_gir_giris),
                              filled: true,
                              fillColor:
                                  temaNesne.temaOku()
                                      ? Colors.grey[800]
                                      : Colors.grey[200],
                              labelStyle: TextStyle(
                                color:
                                    temaNesne.temaOku()
                                        ? Colors.white
                                        : Colors.black,
                              ),
                              prefixIcon: Icon(
                                Icons.lock_open_rounded,
                                color: Colors.black,
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    sifreGorunsunMu = !sifreGorunsunMu;
                                  });
                                },
                                icon:
                                    sifreGorunsunMu
                                        ? Icon(
                                          Icons.visibility_off_outlined,
                                          color: Colors.grey[600],
                                        )
                                        : Icon(
                                          Icons.visibility_outlined,
                                          color: Colors.tealAccent,
                                        ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        SizedBox(
                          width: 300,
                          child: TextButton(
                            onPressed: () {
                              girisYapControl(
                                girisMailController.text.trim(),
                                girisSifreController.text.trim(),
                              );
                            },
                            child: Text(
                              S.of(context).giris_yap,
                              style: TextStyle(
                                color:
                                    temaNesne.temaOku()
                                        ? Colors.white
                                        : Colors.black,
                              ),
                            ),
                            style: TextButton.styleFrom(
                              backgroundColor:
                                  temaNesne.temaOku()
                                      ? Colors.tealAccent
                                      : Colors.grey[800],
                              side:
                                  temaNesne.temaOku()
                                      ? BorderSide(color: Colors.white)
                                      : BorderSide(color: Colors.black),
                              shadowColor:
                                  temaNesne.temaOku()
                                      ? Colors.white
                                      : Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    )
                    : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 10),
                        SizedBox(
                          width: 360,
                          child: TextField(
                            controller: kayitAdController,
                            obscureText: false,
                            decoration: InputDecoration(
                              label: Text(S.of(context).adini_gir_kayit),
                              filled: true,
                              fillColor:
                                  temaNesne.temaOku()
                                      ? Colors.grey[800]
                                      : Colors.grey[200],
                              labelStyle: TextStyle(
                                color:
                                    temaNesne.temaOku()
                                        ? Colors.white
                                        : Colors.black,
                              ),
                              prefixIcon: Icon(
                                Icons.person_outline,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        SizedBox(
                          width: 360,
                          child: TextField(
                            controller: kayitSoyadController,
                            obscureText: false,
                            decoration: InputDecoration(
                              label: Text(S.of(context).soyadini_gir_kayit),
                              filled: true,
                              fillColor:
                                  temaNesne.temaOku()
                                      ? Colors.grey[800]
                                      : Colors.grey[200],
                              labelStyle: TextStyle(
                                color:
                                    temaNesne.temaOku()
                                        ? Colors.white
                                        : Colors.black,
                              ),

                              prefixIcon: Icon(
                                Icons.badge_outlined,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        SizedBox(
                          width: 360,
                          child: TextField(
                            controller: kayitMailController,
                            obscureText: false,
                            decoration: InputDecoration(
                              label: Text(S.of(context).mail_adresi_gir_kayit),
                              filled: true,
                              fillColor:
                                  temaNesne.temaOku()
                                      ? Colors.grey[800]
                                      : Colors.grey[200],
                              labelStyle: TextStyle(
                                color:
                                    temaNesne.temaOku()
                                        ? Colors.white
                                        : Colors.black,
                              ),
                              prefixIcon: Icon(
                                Icons.mail_outline,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        SizedBox(
                          width: 360,
                          child: TextField(
                            controller: kayitSifreController,
                            obscureText: false,

                            decoration: InputDecoration(
                              label: Text(S.of(context).sifre_gir_kayit),
                              filled: true,
                              fillColor:
                                  temaNesne.temaOku()
                                      ? Colors.grey[800]
                                      : Colors.grey[200],
                              labelStyle: TextStyle(
                                color:
                                    temaNesne.temaOku()
                                        ? Colors.white
                                        : Colors.black,
                              ),
                              prefixIcon: Icon(
                                Icons.lock_open_rounded,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        SizedBox(
                          width: 360,
                          child: TextField(
                            controller: kayitSifreTekrarController,
                            obscureText: sifreGorunsunMu1,

                            decoration: InputDecoration(
                              label: Text(
                                S.of(context).sifrenitekrar_gir_kayit,
                              ),
                              filled: true,
                              fillColor:
                                  temaNesne.temaOku()
                                      ? Colors.grey[800]
                                      : Colors.grey[200],
                              labelStyle: TextStyle(
                                color:
                                    temaNesne.temaOku()
                                        ? Colors.white
                                        : Colors.black,
                              ),
                              prefixIcon: Icon(
                                Icons.lock_reset_outlined,
                                color: Colors.black,
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    sifreGorunsunMu1 = !sifreGorunsunMu1;
                                  });
                                },
                                icon:
                                    sifreGorunsunMu1
                                        ? Icon(
                                          Icons.visibility_off_outlined,
                                          color: Colors.grey[600],
                                        )
                                        : Icon(
                                          Icons.visibility_outlined,
                                          color: Colors.tealAccent,
                                        ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        SizedBox(
                          width: 300,
                          child: TextButton(
                            onPressed: () {
                              kayityapController(
                                kayitAdController.text.trim(),
                                kayitSoyadController.text.trim(),
                                kayitMailController.text.trim(),
                                kayitSifreController.text.trim(),
                                kayitSifreTekrarController.text.trim(),
                              );
                            },
                            child: Text(
                              S.of(context).kayit_yap,
                              style: TextStyle(
                                color:
                                    temaNesne.temaOku()
                                        ? Colors.white
                                        : Colors.black,
                              ),
                            ),
                            style: TextButton.styleFrom(
                              backgroundColor:
                                  temaNesne.temaOku()
                                      ? Colors.tealAccent
                                      : Colors.grey[800],
                              side:
                                  temaNesne.temaOku()
                                      ? BorderSide(color: Colors.white)
                                      : BorderSide(color: Colors.black),
                              shadowColor:
                                  temaNesne.temaOku()
                                      ? Colors.white
                                      : Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
          ),
        );
      },
    );
  }

  Widget sifreMiUnuttumEkraniGoster() {
    return Consumer<TemaOkuma>(
      builder: (context, temaNesne, child) {
        return Align(
          alignment: Alignment.bottomRight,
          child: GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: Colors.greenAccent,
                        width: 3.0,
                      ),
                    ),
                    elevation: 15,
                    shadowColor:
                        temaNesne.temaOku() ? Colors.white : Colors.black,
                    title: Text(
                      S.of(context).sife_unuttum_sayfasi,
                      style: TextStyle(
                        fontSize: 18,
                        color:
                            temaNesne.temaOku() ? Colors.white : Colors.black,
                      ),
                    ),
                    content: SizedBox(
                      height: 200,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 360,
                              child: TextField(
                                controller: sifreMiunuttumMailController,
                                obscureText: false,
                                decoration: InputDecoration(
                                  label: Text(
                                    S.of(context).mail_adresi_gir_sifreunuttum,
                                  ),
                                  filled: true,
                                  fillColor:
                                      temaNesne.temaOku()
                                          ? Colors.grey[800]
                                          : Colors.grey[200],
                                  labelStyle: TextStyle(
                                    color:
                                        temaNesne.temaOku()
                                            ? Colors.white
                                            : Colors.black,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.mail_outline,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            SizedBox(
                              width: 360,
                              child: TextField(
                                controller: sifreMiunuttumSifreController,
                                obscureText: false,

                                decoration: InputDecoration(
                                  label: Text(
                                    S.of(context).sifre_gir_sifreunuttum,
                                  ),
                                  filled: true,
                                  fillColor:
                                      temaNesne.temaOku()
                                          ? Colors.grey[800]
                                          : Colors.grey[200],
                                  labelStyle: TextStyle(
                                    color:
                                        temaNesne.temaOku()
                                            ? Colors.white
                                            : Colors.black,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.lock_reset_outlined,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                sifremiUnuttunControl(
                                  sifreMiunuttumMailController.text.trim(),
                                  sifreMiunuttumSifreController.text.trim(),
                                );
                              },
                              child: Text(
                                S.of(context).sifre_degistir,
                                style: TextStyle(
                                  color:
                                      temaNesne.temaOku()
                                          ? Colors.black
                                          : Colors.white,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    temaNesne.temaOku()
                                        ? Colors.tealAccent
                                        : Colors.grey[800],
                                shadowColor:
                                    temaNesne.temaOku()
                                        ? Colors.white
                                        : Colors.black,
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
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
            child: Text(
              S.of(context).sifrenimi_unuttun,
              style: TextStyle(fontSize: 15),
            ),
          ),
        );
      },
    );
  }

  // Üst bloklar tasarım kısmı alt taraftakiler backend tarafı

  Future<void> girisYapControl(String mail, String sifre) async {
    var kisiBulundumu = false;
    refKisiler.onValue.listen((event) {
      // veriler anlık gelecek runa gerek yok
      var gelenDegerler = event.snapshot.value as dynamic; // değerleri aldık
      if (gelenDegerler == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              S.of(context).maingiris_snackbar_vericekilemedi,
              style: TextStyle(color: Colors.black),
            ),
            duration: Duration(milliseconds: 2000),
            backgroundColor: Colors.grey[600],
          ),
        );
        return;
      } else {
        if (mail.isEmpty || sifre.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                S.of(context).maingiris_snackbar_bosalanvar,
                style: TextStyle(color: Colors.black),
              ),
              duration: Duration(milliseconds: 2000),
              backgroundColor: Colors.grey[600],
            ),
          );

          girisMailController.clear();
          girisSifreController.clear();
          return;
        } else {
          gelenDegerler.forEach((key, nesne) {
            var gelenKisi = Kisiler.fromJson(nesne);
            if (mail == gelenKisi.kisiMail && sifre == gelenKisi.kisiSifre) {
              kisiBulundumu = true;
              kisiler2 = gelenKisi;

            }
          });
          if (kisiBulundumu) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) =>
                        Gecissayfalari(kisiler2),
              ),
            );
            girisMailController.clear();
            girisSifreController.clear();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  S.of(context).maingiris_snackbar_mailveyasifreyanlis,
                  style: TextStyle(color: Colors.black),
                ),
                duration: Duration(milliseconds: 2000),
                backgroundColor: Colors.grey[600],
              ),
            );
            girisMailController.clear();
            girisSifreController.clear();
          }
        }
      }
    });
  }

  bool mailOlmasarti(String mail) {
    List<String> mailindexle = mail.split(",");
    if (mailindexle[0] == "." ||
        mailindexle[0] == "@" ||
        mailindexle[0] == " ") {
      return false;
    }

    if (!mail.endsWith("@gmail.com")) {
      //ile bitmek
      return false;
    }
    return true;
  }

  bool mailAlinmisMi(String mail) {
    var kisiBulundumu = false;

    refKisiler.once().then((event) {
      var gelenDegerler = event.snapshot.value as dynamic; // değerleri aldık
      gelenDegerler.forEach((key, nesne) {
        var gelenKisi = Kisiler.fromJson(nesne);
        if (mail == gelenKisi.kisiMail) {
          kisiBulundumu = true;
        }
      });
    });
    if (kisiBulundumu) {
      return true;
    }
    return false;
  }

  Future<void> kayityapController(
    String ad,
    String soyad,
    String mail,
    String sifre,
    String tekrarSifre,
  ) async {
    if (ad.isEmpty ||
        soyad.isEmpty ||
        mail.isEmpty ||
        sifre.isEmpty ||
        tekrarSifre.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            S.of(context).mainkayit_snackbar_bosalanlarvar,
            style: TextStyle(color: Colors.black),
          ),
          duration: Duration(milliseconds: 2000),
          backgroundColor: Colors.grey[600],
        ),
      );
      return;
    }
    if (sifre != tekrarSifre) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            S.of(context).mainkayit_snackbar_sifreuyusmuyor,
            style: TextStyle(color: Colors.black),
          ),
          duration: Duration(milliseconds: 2000),
          backgroundColor: Colors.grey[600],
        ),
      );
      kayitSifreController.clear();
      kayitSifreTekrarController.clear();
      return;
    }
    if (mailOlmasarti(mail) && !mailAlinmisMi(mail)) {
      var bilgi = HashMap<String, dynamic>();
      bilgi["kisiAd"] = ad;
      bilgi["kisiSoyad"] = soyad;
      bilgi["kisiMail"] = mail;
      bilgi["kisiSifre"] = sifre;
      bilgi["kisiprofilUrl"] = "https://i.imgur.com/Y5vlSnj.png";
      bilgi["kisiStory"] = "...";
      bilgi["kisipremiumVarMi"] = false;
      refKisiler.push().set(bilgi);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            S.of(context).mainkayit_snackbar_kayitbasarili,
            style: TextStyle(color: Colors.black),
          ),
          duration: Duration(milliseconds: 2000),
          backgroundColor: Colors.grey[600],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            S.of(context).mainkayit_snackbar_gecerlimailgir,
            style: TextStyle(color: Colors.black),
          ),
          duration: Duration(milliseconds: 2000),
          backgroundColor: Colors.grey[600],
        ),
      );
    }
    kayitAdController.clear();
    kayitSoyadController.clear();
    kayitMailController.clear();
    kayitSifreController.clear();
    kayitSifreTekrarController.clear();
    kayitMailController.clear();
  }

  Future<void> sifremiUnuttunControl(String mail, String sifre) async {
    var kisiBulundumu = false;
    var key1 = "";
    print("Kontrol1");
    if (mail.isEmpty || sifre.isEmpty) {
      print("Kontrol2");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.of(context).mainsifremiunuttum_snackbar_bosalanvar),
          duration: Duration(milliseconds: 5000),
          backgroundColor: Colors.red,
        ),
      );
      sifreMiunuttumMailController.clear();
      sifreMiunuttumSifreController.clear();
      return;
    } else {
      print("Kontrol3");

      refKisiler.once().then((event) {
        //veri bir kez çekiliyor
        print("Kontrol4");

        var gelenDegerler = event.snapshot.value as dynamic;
        print("Kontrol5");

        if (gelenDegerler == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                S.of(context).mainsifremiunuttum_snackbar_verilercekilemedi,
              ),
              backgroundColor: Colors.red,
            ),
          );
          print("Kontrol6");

          return;
        }
        gelenDegerler.forEach((key, nesne) {
          print("Key${key}");
          var gelenKisi = Kisiler.fromJson(nesne);
          if (mail == gelenKisi.kisiMail) {
            kisiBulundumu = true;
            kisiler1 = gelenKisi;
            key1 = key;
            print("Kontrol8");
          }
          if (kisiBulundumu) {
            var bilgiler = HashMap<String, dynamic>();
            bilgiler["kisiAd"] = kisiler1.kisiAd;
            bilgiler["kisiSoyad"] = kisiler1.kisiSoyad;
            bilgiler["kisiMail"] = kisiler1.kisiMail;
            bilgiler["kisiSifre"] = sifre;
            bilgiler["kisiprofilUrl"] = kisiler1.kisiprofilUrl;
            bilgiler["kisiStory"] = kisiler1.kisiStory;
            bilgiler["kisipremiumVarmi"] = kisiler1.kisipremiumVarMi;
            refKisiler.child(key1).update(bilgiler);
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  S.of(context).mainsifremiunuttum_snackbar_sifreguncellendi,
                  style: TextStyle(color: Colors.black),
                ),
                duration: Duration(milliseconds: 2000),
                backgroundColor: Colors.grey[600],
              ),
            );
          }
        });
      });
      sifreMiunuttumMailController.clear();
      sifreMiunuttumSifreController.clear();
    }
  }

  @override
  void initState() {
    super.initState();
    girisMailController = TextEditingController();
    girisSifreController = TextEditingController();
    kayitMailController = TextEditingController();
    kayitSifreController = TextEditingController();
    kayitAdController = TextEditingController();
    kayitSoyadController = TextEditingController();
    kayitSifreTekrarController = TextEditingController();
    sifreMiunuttumMailController = TextEditingController();
    sifreMiunuttumSifreController = TextEditingController();
  }

  @override
  void dispose() {
    girisMailController = TextEditingController();
    girisSifreController = TextEditingController();
    kayitMailController = TextEditingController();
    kayitSifreController = TextEditingController();
    kayitSifreTekrarController = TextEditingController();
    sifreMiunuttumMailController = TextEditingController();
    sifreMiunuttumSifreController = TextEditingController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [dilIcon(), SizedBox(width: 30), temaIconu()],
              ),

              SizedBox(
                height: 250,
                width: 250,
                child: Lottie.asset("iconlar/Movie.json"),
              ),
              SizedBox(height: 10),
              giriskayit(),
              SizedBox(height: 10),

              giriskayitekranGoster(),
              SizedBox(height: 30),
              Padding(
                padding: EdgeInsets.only(right: 10),
                child: sifreMiUnuttumEkraniGoster(),
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
