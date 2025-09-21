import 'package:chatapp13/AnaSayfa.dart';
import 'package:chatapp13/GecisSayfasi.dart';
import 'package:chatapp13/Providerler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart';
import 'package:chatapp13/generated/l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  User? currentUser = FirebaseAuth.instance.currentUser;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TemaOkuma()),
        ChangeNotifierProvider(create: (_) => DilOkuma()),
      ],
      child: MyApp(oturumAcikmi: currentUser != null),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool oturumAcikmi;

  const MyApp({required this.oturumAcikmi});

  @override
  Widget build(BuildContext context) {
    return Consumer<DilOkuma>(
      builder: (context, dilNesne, child) {
        return Consumer<TemaOkuma>(
          builder: (context, temaNesne, child) {
            return MaterialApp(
              title: 'Chat App Real Time',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                useMaterial3: true,
                colorScheme: ColorScheme.fromSeed(
                  seedColor: Colors.deepPurple,
                  brightness:
                      temaNesne.temaOku()
                          ? Brightness.dark
                          : Brightness.light, //***********
                ),
                bottomNavigationBarTheme: BottomNavigationBarThemeData(
                  selectedItemColor: Colors.lightBlue, // ************
                  unselectedItemColor: Colors.grey.shade500,
                ),
              ),

              locale: dilNesne.dilOku(),
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
              home:
                  oturumAcikmi
                      ? Gecissayfasi(FirebaseAuth.instance.currentUser)
                      : MyHomePage(),
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
  var girisbuttonseciliMi = true;
  var dilTurkceMi = true;
  var sifregorunsunMu = false;
  var yukleniyorMu = false;
  var yukleniyorMu1 = false;

  late TextEditingController girisMail;
  late TextEditingController girisSifre;
  late TextEditingController kayitisim;

  late TextEditingController kayitMail;
  late TextEditingController kayitSifre;

  late FirebaseMessaging bildirimMesaji = FirebaseMessaging.instance;

  bool mailOlmaSarti(String mail) {
    if (mail.endsWith("@gmail.com")) {
      print("Mail olma sarti saglaniyor");
      return true;
    }
    return false;
  }

  Future<User?> kayitControl(String isim, String mail, String sifre) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      // Kullanıcı oluştur
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: mail,
        password: sifre,
      );

      // Kullanıcı bilgilerini güncelle
      await userCredential.user!.updateDisplayName(isim);
      await userCredential.user!.reload();

      // Güncel kullanıcıyı al
      User? currentUser = auth.currentUser;
      if (currentUser != null) {
        await firestore.collection('users').doc(auth.currentUser!.uid).set({
          "name": isim,
          "email": mail,
          "status": "Unavalibe",
          "uid": auth.currentUser!.uid,
        });
        setState(() {
          yukleniyorMu1 = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: Duration(milliseconds: 2000),
            backgroundColor: Colors.grey,
            content: Text(
              S.of(context).kayitislemi_basarili,
              style: TextStyle(color: Colors.black),
            ),
          ),
        );
      } else {
        setState(() {
          yukleniyorMu1 = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: Duration(milliseconds: 2000),
            backgroundColor: Colors.grey,
            content: Text(
              S.of(context).kayitislemi_basarisiz,

              style: TextStyle(color: Colors.black),
            ),
          ),
        );
      }

      kayitSifre.clear();
      kayitMail.clear();
      kayitisim.clear();

      print("Kayıt edilen kişi: $currentUser");
      return currentUser;
    } catch (e) {
      print("Kayıt hatası: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(milliseconds: 2000),
          backgroundColor: Colors.grey,
          content: Text("${S.of(context).kayitislemi_hataolustu} $e"),
        ),
      );
      kayitSifre.clear();
      kayitMail.clear();
      kayitisim.clear();
      setState(() {
        yukleniyorMu1 = false;
      });
      return null;
    }
  }

  // Giriş Fonksiyonu
  Future<User?> girisControl(String mail, String sifre) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: mail.toLowerCase(),
        password: sifre,
      );

      User? currentUser = userCredential.user;
      if (currentUser != null) {
        setState(() {
          yukleniyorMu = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: Duration(milliseconds: 2000),
            backgroundColor: Colors.grey,
            content: Text(S.of(context).girisislemi_basarili),
          ),
        );

        // Giriş başarılıysa Anasayfa'ya yönlendir
        if (currentUser != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Gecissayfasi(currentUser)),
          );
        } else {
          return null;
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (context) =>
                    Gecissayfasi(currentUser != null ? currentUser : null),
          ),
        );

        return currentUser;
      }
      return null;
    } catch (e) {
      print("Giriş hatası: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(milliseconds: 2000),
          backgroundColor: Colors.grey,
          content: Text("${S.of(context).girisislemi_hataolustu} $e"),
        ),
      );
      setState(() {
        yukleniyorMu = false;
      });
      girisMail.clear();
      girisSifre.clear();
      return null;
    }
  }

  Widget girisKayitButtonlar() {
    return Card(
      shape: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Colors.tealAccent, width: 2.0),
      ),
      color: Colors.blueGrey,
      child: SizedBox(
        height: 65,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Giriş Yap Butonu
            GestureDetector(
              onTap: () {
                setState(() {
                  girisbuttonseciliMi = true;
                });
              },
              child: SizedBox(
                width: 192,
                height: 55,
                child: Card(
                  margin: EdgeInsets.only(left: 5),
                  elevation: 3,
                  shadowColor: Colors.cyan.shade200,
                  shape: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1.5),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  color:
                      girisbuttonseciliMi
                          ? Colors.cyanAccent
                          : Colors.grey.shade300,

                  child: Center(
                    child: Text(
                      S.of(context).girisyap,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Kayıt Yap Butonu
            GestureDetector(
              onTap: () {
                setState(() {
                  girisbuttonseciliMi = false;
                });
              },
              child: SizedBox(
                width: 192,
                height: 55,
                child: Card(
                  margin: EdgeInsets.only(right: 5),
                  elevation: 3,
                  shadowColor: Colors.cyan.shade200,
                  shape: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1.5),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  color:
                      girisbuttonseciliMi
                          ? Colors.grey.shade300
                          : Colors.cyanAccent,
                  child: Center(
                    child: Text(
                      S.of(context).kayityap,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget girisKayitfieldler() {
    return girisbuttonseciliMi
        ? Card(
          shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.tealAccent, width: 1.8),
          ),
          color: Colors.blueGrey,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 10),
                SizedBox(
                  width: 300,
                  child: TextField(
                    maxLength: 25,
                    controller: girisMail,
                    decoration: InputDecoration(
                      label: Text(
                        S.of(context).gecerlimailgir_giris,
                        style: TextStyle(color: Colors.black),
                      ),
                      filled: true,
                      fillColor: Colors.cyan,
                      prefixIcon: Icon(Icons.mail_outline, color: Colors.black),
                    ),
                  ),
                ),
                SizedBox(
                  width: 250,
                  child: TextField(
                    maxLength: 10,
                    controller: girisSifre,
                    obscureText: sifregorunsunMu ? false : true,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      label: Text(
                        S.of(context).gecerlisifregir_giris,
                        style: TextStyle(color: Colors.black),
                      ),
                      filled: true,
                      fillColor: Colors.cyan,
                      prefixIcon: Icon(
                        Icons.lock_open_rounded,
                        color: Colors.black,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            sifregorunsunMu = !sifregorunsunMu;
                          });
                        },
                        icon:
                            sifregorunsunMu
                                ? Icon(
                                  Icons.visibility_outlined,
                                  color: Colors.tealAccent,
                                )
                                : Icon(
                                  Icons.visibility_off_outlined,
                                  color: Colors.black,
                                ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: 200,
                  child:
                      yukleniyorMu
                          ? Lottie.asset("iconlar/yukleniyorMu.json")
                          : ElevatedButton(
                            onPressed: () {
                              if (girisMail.text.trim() == "" ||
                                  girisSifre.text.trim() == "") {
                                setState(() {
                                  yukleniyorMu = false;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    duration: Duration(milliseconds: 2000),
                                    backgroundColor: Colors.grey,
                                    content: Text(S.of(context).bosalanlar_var),
                                  ),
                                );
                                girisMail.clear();
                                girisSifre.clear();
                                return;
                              } else {
                                setState(() {
                                  yukleniyorMu = true;
                                });
                                girisControl(girisMail.text, girisSifre.text);
                              }
                            },
                            child: Text(
                              S.of(context).girisyap,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[800],
                              side: BorderSide(color: Colors.tealAccent),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        )
        : Card(
          shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.tealAccent, width: 1.8),
          ),
          color: Colors.blueGrey,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 15),
                SizedBox(
                  width: 300,
                  child: TextField(
                    maxLength: 25,
                    controller: kayitisim,
                    decoration: InputDecoration(
                      label: Text(
                        S.of(context).isminizi_girin,
                        style: TextStyle(color: Colors.black),
                      ),
                      filled: true,
                      fillColor: Colors.cyan,
                      prefixIcon: Icon(
                        Icons.perm_contact_calendar_outlined,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 275,
                  child: TextField(
                    maxLength: 25,
                    controller: kayitMail,
                    decoration: InputDecoration(
                      label: Text(
                        S.of(context).gecerlimailgir_kayit,
                        style: TextStyle(color: Colors.black),
                      ),
                      filled: true,
                      fillColor: Colors.cyan,
                      prefixIcon: Icon(Icons.mail_outline, color: Colors.black),
                    ),
                  ),
                ),
                SizedBox(
                  width: 250,
                  child: TextField(
                    maxLength: 10,
                    controller: kayitSifre,
                    obscureText: sifregorunsunMu ? false : true,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      label: Text(
                        S.of(context).gecerlisifregir_kayit,
                        style: TextStyle(color: Colors.black),
                      ),
                      filled: true,
                      fillColor: Colors.cyan,
                      prefixIcon: Icon(
                        Icons.lock_open_rounded,
                        color: Colors.black,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            sifregorunsunMu = !sifregorunsunMu;
                          });
                        },
                        icon:
                            sifregorunsunMu
                                ? Icon(
                                  Icons.visibility_outlined,
                                  color: Colors.tealAccent,
                                )
                                : Icon(
                                  Icons.visibility_off_outlined,
                                  color: Colors.black,
                                ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: 200,
                  child:
                      yukleniyorMu1
                          ? Lottie.asset("iconlar/yukleniyorMu.json")
                          : ElevatedButton(
                            onPressed: () {
                              if (kayitisim.text.trim() == "" ||
                                  kayitMail.text.trim() == "" ||
                                  kayitSifre.text.trim() == "") {
                                setState(() {
                                  yukleniyorMu1 = false;
                                });

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    duration: Duration(milliseconds: 2000),
                                    backgroundColor: Colors.grey,
                                    content: Text(S.of(context).bosalanlar_var),
                                  ),
                                );
                                kayitisim.clear();
                                kayitMail.clear();
                                kayitSifre.clear();
                                return;
                              } else {
                                setState(() {
                                  yukleniyorMu1 = true;
                                });
                                kayitControl(
                                  (kayitisim.text[0].toUpperCase() +
                                          kayitisim.text
                                              .substring(1)
                                              .toLowerCase())
                                      .trim(),
                                  (kayitMail.text.toLowerCase()).trim(),
                                  kayitSifre.text.trim(),
                                );
                              }
                            },
                            child: Text(
                              S.of(context).kayityap,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[800],
                              side: BorderSide(color: Colors.tealAccent),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        );
  }

  @override
  void initState() {
    girisMail = TextEditingController();
    girisSifre = TextEditingController();
    kayitisim = TextEditingController();
    kayitMail = TextEditingController();
    kayitSifre = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    girisSifre.dispose();
    girisMail.dispose();
    kayitisim.dispose();
    kayitMail.dispose();
    kayitSifre.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DilOkuma>(
      builder: (context, dilNesne, child) {
        return Consumer<TemaOkuma>(
          builder: (context, temaNesne, child) {
            return Scaffold(
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(90),

                child: AppBar(
                  shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(
                      color: temaNesne.temaOku() ? Colors.white : Colors.black,
                      width: 1.5,
                    ),
                  ),
                  leading:
                      temaNesne.temaOku()
                          ? IconButton(
                            onPressed: () {
                              temaNesne.temaDegis();
                            },
                            icon: Icon(Icons.wb_sunny_outlined, size: 30),
                          )
                          : IconButton(
                            onPressed: () {
                              temaNesne.temaDegis();
                            },
                            icon: Icon(Icons.nights_stay_outlined, size: 30),
                          ),

                  actions: [
                    Card(
                      margin: EdgeInsets.only(top: 7, right: 7),
                      shape: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.lightBlueAccent,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: Colors.grey[800],
                      child: SizedBox(
                        width: 110,
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                dilNesne.dilDegistir(Locale("tr"));

                                setState(() {
                                  dilTurkceMi = true;
                                });
                              },
                              child: SizedBox(
                                width: 55,
                                height: 40,
                                child: Card(
                                  color:
                                      dilTurkceMi
                                          ? Colors.lightGreen
                                          : Colors.red,
                                  shape: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Tr",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                dilNesne.dilDegistir(Locale("en"));

                                setState(() {
                                  dilTurkceMi = false;
                                });
                              },
                              child: SizedBox(
                                width: 55,
                                height: 40,
                                child: Card(
                                  color:
                                      dilTurkceMi
                                          ? Colors.red
                                          : Colors.lightGreen,
                                  shape: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "En",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              body: SingleChildScrollView(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset("iconlar/chat.json"),

                      girisKayitButtonlar(),
                      SizedBox(height: 5),
                      girisKayitfieldler(),
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
}
