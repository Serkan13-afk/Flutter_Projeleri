import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:havadurumu_app/ekranlar/NavigatorGecisSayfa.dart';
import 'package:havadurumu_app/Providerler.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var girisSecilimi = true;

  late TextEditingController girisMailController;
  late TextEditingController girisSifreController;
  late TextEditingController kayitMailController;
  late TextEditingController kayitSifreController;
  late TextEditingController kayitAdController;
  late TextEditingController sifremiUnuttumMailController;

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var kisiKayitEdiliyormu = false;
  var kisiGirisYapiyormu = false;

  late double genislik = MediaQuery.of(context).size.width;
  late double yukseklik = MediaQuery.of(context).size.height;

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

  @override
  void dispose() {
    girisMailController.dispose();
    girisSifreController.dispose();
    kayitMailController.dispose();
    kayitSifreController.dispose();
    kayitAdController.dispose();
    sifremiUnuttumMailController.dispose();
    super.dispose();
  }

  // 🔹 Giriş / Kayıt butonları
  Widget kayitGirisGecisButton() {
    return Consumer<TemaOkuma>(
      builder: (context, temaNesne, child) {
        return SizedBox(
          width: genislik,
          height: yukseklik * 0.08,
          child: Card(
            color: Colors.tealAccent,
            elevation: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Giriş Butonu
                GestureDetector(
                  onTap: () {
                    setState(() {
                      girisSecilimi = true;
                    });
                  },
                  child: SizedBox(
                    width: genislik * 0.47,
                    height: yukseklik * 0.07,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color: girisSecilimi
                          ? Colors.blueAccent
                          : Colors.grey.shade300,
                      child: Center(
                        child: Text(
                          "Giriş",
                          style: TextStyle(
                            color: girisSecilimi
                                ? Colors.white
                                : Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 2),

                // Kayıt Butonu
                GestureDetector(
                  onTap: () {
                    setState(() {
                      girisSecilimi = false;
                    });
                  },
                  child: SizedBox(
                    width: genislik * 0.47,
                    height: yukseklik * 0.07,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color: girisSecilimi
                          ? Colors.grey.shade300
                          : Colors.blueAccent,
                      child: Center(
                        child: Text(
                          "Kayıt",
                          style: TextStyle(
                            color: girisSecilimi
                                ? Colors.black87
                                : Colors.white,
                            fontWeight: FontWeight.bold,
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
      },
    );
  }

  // 🔹 Alan
  Widget kayitGirisGorselAlani() {
    return Card(
      color: Colors.tealAccent,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: girisSecilimi
              ? Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _customTextField(
                girisMailController,
                "Mail adresinizi girin",
                Icons.mail_outline,
                true,
                25,
              ),
              const SizedBox(height: 10),
              _customTextField(
                girisSifreController,
                "Şifre girin",
                Icons.lock_outline,
                false,
                10,
                isPassword: true,
              ),
            ],
          )
              : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _customTextField(
                kayitAdController,
                "Adınızı girin",
                Icons.person_outline,
                true,
                15,
              ),
              const SizedBox(height: 10),
              _customTextField(
                kayitMailController,
                "Mail adresinizi girin",
                Icons.mail_outline,
                true,
                25,
              ),
              const SizedBox(height: 10),
              _customTextField(
                kayitSifreController,
                "Şifre belirleyin",
                Icons.lock_outline,
                false,
                10,
                isPassword: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 Custom TextField
  Widget _customTextField(
      TextEditingController controller,
      String label,
      IconData icon,
      bool klavyetipiyazimi,
      int uzunluk, {
        bool isPassword = false,
      }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      maxLength: uzunluk,
      keyboardType: klavyetipiyazimi
          ? TextInputType.name
          : TextInputType.number,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        labelText: label,
        labelStyle: TextStyle(color: Colors.black),
        filled: true,
        fillColor: Colors.grey.shade100,
        hintStyle: TextStyle(color: Colors.black),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      style: TextStyle(color: Colors.black),
    );
  }

  // 🔹 Giriş işlemi
  Future<void> girisControl(String mail, String sifre) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: mail,
        password: sifre,
      );

      User? currentuser = userCredential.user;
      if (currentuser != null) {
        setState(() {
          kisiGirisYapiyormu = false;
        });

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Navigatorgecissayfa(currentuser),
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Giriş işlemi başarılı bir şekilde yapıldı")),
        );
      }
    } catch (e) {
      setState(() {
        kisiGirisYapiyormu = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Giriş işlemi sırasında hata oluştu")),
      );
    }
  }

  // 🔹 Kayıt işlemi
  Future<void> kayitControl(String ad, String mail, String sifre) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: mail,
        password: sifre,
      );
      await userCredential.user!.updateDisplayName(ad); // isim ver
      await userCredential.user!.reload(); // bilgileri güncelle

      User? currentUser = await auth.currentUser;
      if (currentUser != null) {
        await firestore.collection("users").doc(auth.currentUser!.uid).set({
          "name": ad,
          "email": mail,
          "uid": auth.currentUser!.uid,
        });
        setState(() {
          kisiKayitEdiliyormu = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Kayıt işlemi başarılı bir şekilde yapıldı")),
        );
      } else {
        setState(() {
          kisiKayitEdiliyormu = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Kayıt işlemi başarısız")));
      }
    } catch (e) {
      setState(() {
        kisiKayitEdiliyormu = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("İşlem sırasında hata oluştu")));
    }
  }

  // 🔹 Şifre sıfırlama (Firebase Password Reset)
  Future<void> sifreUnuttum(String mail) async {
    try {
      await auth.sendPasswordResetEmail(email: mail);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Şifre sıfırlama maili gönderildi.")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Mail gönderilirken hata oluştu.")),
      );
    }
  }

  // 🔹 Ekran
  @override
  Widget build(BuildContext context) {
    return Consumer<TemaOkuma>(
      builder: (context, temaNesne, child) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Container(
              width: genislik,
              height: yukseklik,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("resimler/drawergorsel.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 170),
                    kayitGirisGecisButton(),
                    const SizedBox(height: 20),
                    SizedBox(width: genislik, child: kayitGirisGorselAlani()),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: genislik * 0.8,
                      height: yukseklik * 0.06,
                      child: ElevatedButton(
                        onPressed: () {
                          if (girisSecilimi) {
                            girisControl(
                              girisMailController.text.trim(),
                              girisSifreController.text.trim(),
                            );
                          } else {
                            if (kayitMailController.text.trim().endsWith("@gmail.com") &&
                                kayitAdController.text.trim() != "" &&
                                kayitSifreController.text.trim() != "") {
                              kayitControl(
                                kayitAdController.text.trim(),
                                kayitMailController.text.trim(),
                                kayitSifreController.text.trim(),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Geçerli veriler gir")),
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          girisSecilimi ? "Giriş yap" : "Kayıt yap",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                title: Text(
                                  "Şifre Unuttum",
                                  style: TextStyle(
                                    color: Colors.blue.shade700,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _customTextField(
                                      sifremiUnuttumMailController,
                                      "Kayıtlı mail adresinizi giriniz",
                                      Icons.mail_outline,
                                      true,
                                      25,
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      "İptal",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      final mail = sifremiUnuttumMailController.text.trim();
                                      if (mail.isNotEmpty && mail.contains("@")) {
                                        sifreUnuttum(mail);
                                        Navigator.pop(context);
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text("Geçerli bir mail adresi giriniz.")),
                                        );
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blueAccent,
                                    ),
                                    child: Text("Onayla"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Text(
                          "Şifreni mi unuttun?",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.blue.shade700,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
