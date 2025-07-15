import 'package:flutter/material.dart';
import 'package:kripto_uyg/AnaSayfa.dart';
import 'package:kripto_uyg/CoinArama.dart';
import 'package:kripto_uyg/FavoriCoinler.dart';
import 'package:kripto_uyg/Kisi.dart';

class NavigatorGecissayfasi extends StatefulWidget {
  late Kisi kisiVeriler;

  NavigatorGecissayfasi(this.kisiVeriler);

  @override
  State<NavigatorGecissayfasi> createState() => _NavigatorGecissayfasiState();
}

class _NavigatorGecissayfasiState extends State<NavigatorGecissayfasi> {
  int seciliIndex = 0;
  late List<Widget> sayfalarim;

  @override
  void initState() {
    super.initState();
    sayfalarim = [Anasayfa(widget.kisiVeriler), Favoricoinler(), Coinarama()];
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
            label: "AnaSayfa",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "FavoriCoinler",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "Coin Arama",
          ),
        ],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white54,
        backgroundColor: Colors.black,
      ),
    );
  }
}
