import 'dart:collection';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';

import 'Kisiler2.dart';

class Profilsayfa extends StatefulWidget {
  late Kisiler2 kisiler2;

  Profilsayfa(this.kisiler2);

  @override
  State<Profilsayfa> createState() => _ProfilsayfaState();
}

class _ProfilsayfaState extends State<Profilsayfa>
    with TickerProviderStateMixin {
  late TextEditingController eskisifreController;
  late TextEditingController yenisifreController;
  late TextEditingController adresController;

  late AnimationController animationController;
  late Animation<double> animationDegerleri;
  var adres = "";
  var sifregizlimi = true;
  var refKisiler = FirebaseDatabase.instance.ref().child("kisiler_tablo");
  bool premumvarMii = false;

  Future<void> premiumCayma() async {
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
      guncelbilgi["premiumVarmi"] = false;
      guncelbilgi["siparis_Adres"] = bulunanKisi!.siparisAdres;

      await refKisiler.child(key1!).update(guncelbilgi);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Premium firsatından caydınız"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Kullanıcı bulunamadı"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

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
      premumvarMii = bulunanKisi!.premiumVarmi;
    }
  }

  Future<void> adresOkuma() async {
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
      adres = bulunanKisi!.siparisAdres;
    }
  }

  Future<void> sifreUnuttum(String eskisifre, String yenisifre) async {
    if (widget.kisiler2.sifre != eskisifre) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Mevcut şifreler uyuşmuyor"),
          backgroundColor: Colors.red,
        ),
      );
      eskisifreController.clear();
      yenisifreController.clear();
      return;
    }

    if (yenisifre.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Şifre alanı boş bırakılmaz"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

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
      guncelbilgi["sifre"] = yenisifre;
      guncelbilgi["soyad"] = bulunanKisi!.soyad;
      guncelbilgi["premiumVarmi"] = bulunanKisi!.premiumVarmi;
      guncelbilgi["siparis_Adres"] = bulunanKisi!.siparisAdres;

      await refKisiler.child(key1!).update(guncelbilgi);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Şifreniz başarılı bir şekilde değiştirildi"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Kullanıcı bulunamadı"),
          backgroundColor: Colors.red,
        ),
      );
    }

    eskisifreController.clear();
    yenisifreController.clear();
  }

  Future<void> adresEkleveyaGuncelle(String adres) async {
    if (adres.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Adres alanı boş bırakılmaz"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

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
      guncelbilgi["premiumVarmi"] = bulunanKisi!.premiumVarmi;
      guncelbilgi["siparis_Adres"] = adres;

      await refKisiler.child(key1!).update(guncelbilgi);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Adres başarılı bir şekilde değiştirildi"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Kullanıcı bulunamadı"),
          backgroundColor: Colors.red,
        ),
      );
    }

    adresController.clear();
  }

  Widget premiumGorunekmi() {
    if (!premumvarMii) {
      return SizedBox();
    }
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          Shimmer.fromColors(
            baseColor: Colors.white54,
            highlightColor: Colors.white,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Premium Cayma Hakkı ve İptal Koşulları",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(height: 5),
          SizedBox(
            width: 400,
            height: 60,
            child: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      shadowColor: Colors.black,
                      elevation: 10,
                      shape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: Colors.greenAccent,
                          width: 5.0,
                        ),
                      ),
                      backgroundColor: Colors.white,
                      title: Text(
                        "Premium Cayma Sayfası",
                        style: TextStyle(color: Colors.black),
                      ),
                      content: SizedBox(
                        width: 300,
                        height: 600,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                """
       Üyelik İptali ve Cayma Koşulları

Cayma Hakkı: Satın alma tarihinden itibaren 14 gün içinde üyeliğinizi iptal etme hakkınız vardır.

Cayma Bedeli: İptal durumunda kullanılan günler + ₺9,99 işlem masrafı toplam tutardan düşülür. Kalan miktar tarafınıza iade edilir.

14 Gün Sonrası: 14 günü geçen iptallerde ücret iadesi yapılmaz, üyeliğiniz dönem sonuna kadar aktif kalır.

İptal Sonrası Kaybedeceğiniz Avantajlar:

❌ Reklamsız ve kesintisiz kullanım
❌ Tüm özel içeriklere sınırsız erişim
❌ Öncelikli destek hizmeti
❌ Yeni özelliklere erken erişim
❌ Siparişlerinizde 100 TL’ye varan indirim kuponları
                                """,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text("İptal"),
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
                                  SizedBox(width: 30),
                                  TextButton(
                                    onPressed: () {
                                      premiumCayma();
                                      Navigator.pop(context);
                                    },
                                    child: Text("Onayla"),
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Premium ayrıcalığından cayın",
                        style: TextStyle(color: Colors.black, fontSize: 17),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    animationController.dispose();
    eskisifreController.dispose();
    yenisifreController.dispose();
    adresController.dispose();
  }

  @override
  void initState() {
    super.initState();
    eskisifreController = TextEditingController();
    yenisifreController = TextEditingController();
    adresController = TextEditingController();
    adresOkuma();
    premiumOkuma();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );
    animationDegerleri = Tween(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.linear),
    )..addListener(() {
      setState(() {});
    });
    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.center,
          child: Text(
            "Profil Sayfası",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.black,
                child: Transform.scale(
                  scale: animationDegerleri.value,
                  child: ClipOval(child: Image.asset("resimler/prof.png")),
                ),
              ),
              SizedBox(height: 20),
              Shimmer.fromColors(
                baseColor: Colors.white54,
                highlightColor: Colors.white,
                child: Text(
                  "Hoş Geldin ${widget.kisiler2.ad} ${widget.kisiler2.soyad}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),
              ),
              SizedBox(height: 20),

              Text(
                "Mail Adresiniz :",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),

              Align(
                alignment: Alignment.center,
                child: Text(
                  "${widget.kisiler2.mail}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
              Text("---------------------------------------------------"),
              SizedBox(height: 15),
              Shimmer.fromColors(
                baseColor: Colors.white54,
                highlightColor: Colors.white,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Hesap ayarlari",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(
                width: 400,
                height: 60,
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: Colors.white,
                          shape: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.greenAccent,
                              width: 3.0,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          title: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Şifre güncelleme",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          content: SizedBox(
                            width: 300,
                            height: 400,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(height: 100),
                                  TextField(
                                    controller: eskisifreController,
                                    maxLength: 15,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      label: Text(
                                        "Mevcut Şifrenizi giriniz",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      labelStyle: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      prefixIcon: Icon(
                                        Icons.lock_reset_outlined,
                                        color: Colors.black54,
                                      ),
                                      filled: true,
                                      fillColor: Colors.white54,

                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  TextField(
                                    controller: yenisifreController,
                                    maxLength: 15,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      label: Text("Yeni Şifrenizi giriniz"),
                                      labelStyle: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                      prefixIcon: Icon(
                                        Icons.lock,
                                        color: Colors.black54,
                                      ),
                                      filled: true,
                                      fillColor: Colors.white54,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 30),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          "İptal",
                                          style: TextStyle(
                                            fontSize: 18,
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
                                      SizedBox(width: 40),
                                      TextButton(
                                        onPressed: () {
                                          sifreUnuttum(
                                            eskisifreController.text,
                                            yenisifreController.text,
                                          );
                                        },
                                        child: Text(
                                          "Onayla",
                                          style: TextStyle(
                                            fontSize: 18,
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
                    elevation: 10,
                    shadowColor: Colors.white,
                    shape: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.greenAccent),
                    ),
                    color: Colors.white54,
                    child: Center(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Şifrenizi Değiştirin",
                          style: TextStyle(fontSize: 17, color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Shimmer.fromColors(
                baseColor: Colors.white54,
                highlightColor: Colors.white,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Adres Ayarları",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(height: 5),
              SizedBox(
                width: 400,
                height: 60,
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: Colors.white,
                          shadowColor: Colors.black,
                          elevation: 10,
                          shape: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                              color: Colors.greenAccent,
                              width: 3.0,
                            ),
                          ),
                          title: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Adres Ekleme Sayfası",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          content: SizedBox(
                            width: 500,
                            height: 200,
                            child: Center(
                              child: Column(
                                children: [
                                  SizedBox(height: 30),
                                  TextField(
                                    controller: adresController,
                                    maxLength: 100,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      label: Text(
                                        "Mahhale / Cadde / Sokak /Apartman No ",
                                      ),
                                      filled: true,
                                      fillColor: Colors.blueGrey,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                          color: Colors.greenAccent,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 30),
                                  ElevatedButton(
                                    onPressed: () {
                                      adresEkleveyaGuncelle(
                                        adresController.text.trim(),
                                      );
                                    },
                                    child: Text(
                                      "Ekle / Güncelle",
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.black,
                                      ),
                                    ),
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
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Card(
                    shape: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.greenAccent),
                    ),
                    shadowColor: Colors.white,
                    elevation: 10,
                    color: Colors.white54,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add, color: Colors.green, size: 25),
                          SizedBox(width: 15),
                          Text(
                            "Adres Ekle / Adres Güncelle",
                            style: TextStyle(color: Colors.black, fontSize: 17),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 400,
                height: 60,
                child: Card(
                  shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.greenAccent),
                  ),
                  shadowColor: Colors.white,
                  elevation: 10,
                  color: Colors.white54,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Kayıtlı Adres : ${adres}",
                          style: TextStyle(color: Colors.black, fontSize: 17),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              premiumGorunekmi(),
              SizedBox(height: 20),
              Shimmer.fromColors(
                baseColor: Colors.white54,
                highlightColor: Colors.white,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Çıkış",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(height: 5),

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
                        shadowColor: Colors.white,
                        elevation: 10,
                        title: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Çıkış Sayfasi",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        content: SizedBox(
                          width: 350,
                          height: 200,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Uygulamadan çıkmak istiyor musunuz?",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 60),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        "İptal",
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

                                    SizedBox(width: 30),
                                    TextButton(
                                      onPressed: () {
                                        SystemNavigator.pop();
                                      },
                                      child: Text(
                                        "Onayla",
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
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                child: SizedBox(
                  width: 400,
                  height: 60,
                  child: Card(
                    shape: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: Colors.greenAccent,
                        width: 2.0,
                      ),
                    ),
                    elevation: 10,
                    shadowColor: Colors.white,
                    color: Colors.white54,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.logout, color: Colors.redAccent),
                          Text(
                            "Çıkış Yapın",
                            style: TextStyle(color: Colors.black, fontSize: 17),
                          ),
                        ],
                      ),
                    ),
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
