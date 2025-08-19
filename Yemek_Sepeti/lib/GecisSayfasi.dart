import 'package:flutter/material.dart';
import 'package:yemek_siparis_uyg/AnaSayfa.dart';
import 'package:yemek_siparis_uyg/ProfilSayfa.dart';
import 'package:yemek_siparis_uyg/SepetSayfa.dart';
import 'package:yemek_siparis_uyg/YemekAramaSayfa.dart';

import 'Kisiler2.dart';

class Gecissayfasi extends StatefulWidget {
late Kisiler2 kisiler2;
  Gecissayfasi(this.kisiler2);

  @override
  State<Gecissayfasi> createState() => _GecissayfasiState();
}

class _GecissayfasiState extends State<Gecissayfasi> {
  int seciliindex = 0;

  late List<Widget> sayfalarim;

  @override
  void initState() {
    super.initState();
    sayfalarim = [
      Anasayfa(widget.kisiler2),
      Sepetsayfa(widget.kisiler2),
      Yemekaramasayfa(widget.kisiler2),
      Profilsayfa(widget.kisiler2),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: sayfalarim[seciliindex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: seciliindex,
        onTap: (index) {
          setState(() {
            seciliindex = index;
          });
        },

        items: [
          BottomNavigationBarItem(
            label: "Ana Sayfa",
            icon: Icon(Icons.home_outlined, size: 30),
          ),
          BottomNavigationBarItem(
            label: "Sepetim",
            icon: Icon(Icons.shopping_basket_outlined, size: 30),
          ),
          BottomNavigationBarItem(
            label: "Yemek Arama",
            icon: Icon(Icons.search, size: 30),
          ),
          BottomNavigationBarItem(
            label: "Profil",
            icon: Icon(Icons.person_outline, size: 30),
          ),
        ],
      ),
    );
  }
}
