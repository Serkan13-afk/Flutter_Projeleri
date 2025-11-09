import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:muzikcalar_app/DilSinif.dart';
import 'package:muzikcalar_app/gecisSayfa.dart';
import 'package:muzikcalar_app/generated/l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DilSinif.dilGetir(); // başta yüklensin dedik
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Apk Spotify',
      debugShowCheckedModeBanner: false,

      locale: DilSinif.varsayilan ?? Locale("tr"),
      supportedLocales: S.delegate.supportedLocales,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: auth.currentUser != null
          ? GecisSayfa(auth.currentUser!)
          : MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  var girissecilimi = true;

  late TextEditingController girisMailController;
  late TextEditingController girisSifreController;
  late TextEditingController kayitMailController;
  late TextEditingController kayitSifreController;
  late TextEditingController kayitAdController;
  late TextEditingController sifremiUnuttumMailController;

  bool mailController(String mail) {
    if (mail.endsWith("@gmail.com") || mail.endsWith("@cloud.com")) {
      return true;
    }
    return false;
  }

  // 🔹 Giriş Kontrolü
  Future<void> girisController(String mail, String sifre) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: mail,
        password: sifre,
      );

      User? user = userCredential.user;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(milliseconds: 1500),
          content: Text("Başarılı bir şekilde giriş yaptınız 🎶"),
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => GecisSayfa(user!)),
      );
    } on FirebaseAuthException catch (e) {
      String mesaj = "Bir hata oluştu";
      if (e.code == 'user-not-found') {
        mesaj = "Bu mail adresine ait bir kullanıcı bulunamadı";
      } else if (e.code == 'wrong-password') {
        mesaj = "Yanlış şifre girdiniz";
      } else if (e.code == 'invalid-email') {
        mesaj = "Geçersiz mail formatı";
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(mesaj)));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Bir hata oluştu: $e")));
    }
  }

  // 🔹 Kayıt Kontrolü
  Future<void> kayitController(String ad, String mail, String sifre) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: mail,
        password: sifre,
      );

      User? user = userCredential.user;
      await user!.updateDisplayName(ad);
      await user.reload();

      // Kullanıcıyı Firestore’a ekleme
      await firestore.collection("kullanicilar").doc(user.uid).set({
        "ad": ad,
        "email": mail,
        "kayitTarihi": DateTime.now(),
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Kayıt işlemi başarılı 🎉")));

      /*Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => GecisSayfa(user)),
      );*/
      kayitAdController.clear();
      kayitSifreController.clear();
      kayitMailController.clear();
    } on FirebaseAuthException catch (e) {
      String mesaj = "Bir hata oluştu";
      if (e.code == 'email-already-in-use') {
        mesaj = "Bu mail adresi zaten kayıtlı";
      } else if (e.code == 'weak-password') {
        mesaj = "Şifre çok zayıf, en az 6 karakter olmalı";
      } else if (e.code == 'invalid-email') {
        mesaj = "Geçersiz mail formatı";
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(mesaj)));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Bir hata oluştu: $e")));
    }
  }

  // 🔹 Şifremi Unuttum
  Future<void> sifremiUnuttumController(String mail) async {
    try {
      await auth.sendPasswordResetEmail(email: mail);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Şifre sıfırlama maili gönderildi 📩")),
      );
    } on FirebaseAuthException catch (e) {
      String mesaj = "Mail gönderilemedi";
      if (e.code == 'user-not-found') {
        mesaj = "Bu mail adresine ait bir hesap yok";
      } else if (e.code == 'invalid-email') {
        mesaj = "Geçersiz mail adresi";
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(mesaj)));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Bir hata oluştu: $e")));
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
    sifremiUnuttumMailController = TextEditingController();
  }

  Widget giriskayitAlanlari() {
    var genislik = MediaQuery.of(context).size.width;

    InputDecoration inputDecoration(String label, IconData icon) {
      return InputDecoration(
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        labelText: label,
        labelStyle: TextStyle(color: Colors.white),
        prefixIcon: Icon(icon, color: Colors.white),
      );
    }

    return Container(
      width: genislik * 0.95,
      padding: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        color: Colors.black38,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (girissecilimi) ...[
            // 🔹 GİRİŞ ALANLARI
            SizedBox(
              width: genislik * 0.85,
              child: TextField(
                controller: girisMailController,
                keyboardType: TextInputType.emailAddress,
                decoration: inputDecoration(
                  "Mail adresinizi girin",
                  Icons.mail_outline,
                ),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: genislik * 0.85,
              child: TextField(
                controller: girisSifreController,
                obscureText: true,
                maxLength: 10,

                decoration: inputDecoration(
                  "Şifrenizi girin",
                  Icons.lock_outline,
                ),
              ),
            ),
            SizedBox(height: 20),

            // 🔹 Şifremi unuttum bağlantısı
            InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (BuildContext context) {
                    return DraggableScrollableSheet(
                      initialChildSize: 0.5,
                      minChildSize: 0.3,
                      maxChildSize: 0.8,
                      builder: (_, controller) {
                        return Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFF00B4DB),
                                Color(0xFF0083B0),
                                Color(0xFF005f73),
                              ],
                            ),
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(25),
                            ),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 25,
                          ),
                          child: SingleChildScrollView(
                            controller: controller,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Container(
                                    width: 50,
                                    height: 5,
                                    decoration: BoxDecoration(
                                      color: Colors.white38,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),
                                Text(
                                  "Şifreni Sıfırla",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 20),
                                TextField(
                                  style: TextStyle(color: Colors.white),
                                  controller: sifremiUnuttumMailController,
                                  decoration: InputDecoration(
                                    hintText: "E-posta adresini gir",
                                    hintStyle: TextStyle(color: Colors.white70),
                                    filled: true,
                                    fillColor: Colors.white.withOpacity(0.1),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide.none,
                                    ),
                                    prefixIcon: Icon(
                                      Icons.email,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: () {
                                    if (sifremiUnuttumMailController.text
                                        .trim()
                                        .isNotEmpty) {
                                      if (mailController(
                                        sifremiUnuttumMailController.text
                                            .trim(),
                                      )) {
                                        sifremiUnuttumController(
                                          sifremiUnuttumMailController.text
                                              .trim(),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              "Geçerli bir mail ile tekrar deneyiniz",
                                            ),
                                          ),
                                        );
                                      }
                                    }
                                    Navigator.pop(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.purpleAccent,
                                    padding: EdgeInsets.symmetric(vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Şifreyi Gönder",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
              child: Text(
                "Şifremi unuttum",
                style: TextStyle(color: Colors.white, fontSize: 17),
              ),
            ),
          ] else ...[
            // 🔹 KAYIT ALANLARI
            SizedBox(
              width: genislik * 0.85,
              child: TextField(
                controller: kayitAdController,
                decoration: inputDecoration(
                  "Adınızı girin",
                  Icons.person_outline,
                ),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: genislik * 0.85,
              child: TextField(
                controller: kayitMailController,
                keyboardType: TextInputType.emailAddress,
                decoration: inputDecoration(
                  "Mail adresinizi girin",
                  Icons.mail_outline,
                ),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: genislik * 0.85,
              child: TextField(
                controller: kayitSifreController,
                obscureText: true,
                maxLength: 10,
                decoration: inputDecoration(
                  "Şifrenizi oluşturun",
                  Icons.lock_outline,
                ),
              ),
            ),
          ],

          SizedBox(height: 30),

          // 🔹 GİRİŞ / KAYIT BUTONU
          Container(
            width: genislik * 0.6,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: LinearGradient(
                colors: [
                  Color(0xFF00B4DB),
                  Color(0xFF0083B0),
                  Color(0xFF005f73),
                ],
              ),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(15),
              onTap: () {
                if (girissecilimi) {
                  if (girisMailController.text.trim().isNotEmpty &&
                      girisSifreController.text.trim().isNotEmpty) {
                    if (mailController(girisMailController.text.trim())) {
                      girisController(
                        girisMailController.text.trim(),
                        girisSifreController.text.trim(),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Geçerli bir mail adresi ile tekrar deneyiniz",
                          ),
                        ),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Boş alanlar var tekrar deneyiniz"),
                      ),
                    );
                  }
                } else {
                  if (kayitMailController.text.trim().isNotEmpty &&
                      kayitSifreController.text.trim().isNotEmpty &&
                      kayitAdController.text.trim().isNotEmpty) {
                    kayitController(
                      kayitAdController.text.trim(),
                      kayitMailController.text.trim(),
                      kayitSifreController.text.trim(),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Boş alanlar var tekrar deneyiniz"),
                      ),
                    );
                  }
                }
              },
              child: Center(
                child: Text(
                  girissecilimi ? "Giriş Yap" : "Kayıt Ol",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Arayüz
  @override
  Widget build(BuildContext context) {
    var genislik = MediaQuery.of(context).size.width;
    var yukseklik = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: genislik,
        height: yukseklik,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF7F00FF), Color(0xFFE100FF), Color(0xFFFFC1E3)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: yukseklik * 0.2),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 16.0,
                  ),
                  child: Text(
                    girissecilimi
                        ? "🎧 Ruhunun ritmini yakala.\nGiriş yap ve müziğin büyüsüne kapıl!"
                        : "🌟 Kendi müzik evrenini oluştur.\nKayıt ol, melodilerinle dünyanı renklendir!",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 40),

                // Giriş / Kayıt geçiş barı
                Container(
                  width: genislik * 0.95,
                  height: yukseklik * 0.08,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.black38,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () => setState(() => girissecilimi = true),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              gradient: girissecilimi
                                  ? LinearGradient(
                                      colors: [
                                        Color(0xFF00B4DB),
                                        Color(0xFF0083B0),
                                        Color(0xFF005f73),
                                      ],
                                    )
                                  : LinearGradient(
                                      colors: [
                                        Colors.transparent,
                                        Colors.transparent,
                                      ],
                                    ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "Giriş",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () => setState(() => girissecilimi = false),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              gradient: !girissecilimi
                                  ? LinearGradient(
                                      colors: [
                                        Color(0xFF00B4DB),
                                        Color(0xFF0083B0),
                                        Color(0xFF005f73),
                                      ],
                                    )
                                  : LinearGradient(
                                      colors: [
                                        Colors.transparent,
                                        Colors.transparent,
                                      ],
                                    ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "Kayıt",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: yukseklik * 0.06),
                giriskayitAlanlari(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
