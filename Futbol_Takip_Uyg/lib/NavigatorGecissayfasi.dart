import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:futbol_takipuyg/FavoriTakimlar.dart';
import 'package:futbol_takipuyg/Kisiler.dart';
import 'package:futbol_takipuyg/Takimarama.dart';

import 'AnaSayfa.dart';

class NavigatorGecissayfasi extends StatefulWidget {
  late Kisiler kisiler;


  NavigatorGecissayfasi(this.kisiler);

  @override
  State<NavigatorGecissayfasi> createState() => _NavigatorGecissayfasiState();
}

class _NavigatorGecissayfasiState extends State<NavigatorGecissayfasi> {
  int seciliIndex = 0;
  late List<Widget> sayfalarim;

  @override
  void initState() {
    super.initState();
    sayfalarim = [Anasayfa(widget.kisiler), Favoritakimlar(), Takimarama()];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: sayfalarim[seciliIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: seciliIndex,
        onTap: (index) {
          setState(() {
            seciliIndex = index;
          });
        },

        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: "Ana Sayfa",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "Favori Takımlar",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "Takım Arama",
          ),
        ],
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.red,
        backgroundColor: Colors.black,
      ),
    );
  }
}
