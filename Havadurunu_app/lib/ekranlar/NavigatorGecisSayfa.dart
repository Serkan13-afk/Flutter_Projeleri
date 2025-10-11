import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:havadurumu_app/ekranlar/AnaSayfa.dart';
import 'package:havadurumu_app/ekranlar/Kayitlilar.dart';

class Navigatorgecissayfa extends StatefulWidget {
  late User gelenuser;

  Navigatorgecissayfa(this.gelenuser);

  @override
  State<Navigatorgecissayfa> createState() => GecisSayfasi();
}

class GecisSayfasi extends State<Navigatorgecissayfa> {
  var seciliIndex = 0;

  late List<Widget> sayfalar = [
    Anasayfa(widget.gelenuser),
    Kayitlilar(widget.gelenuser),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: sayfalar[seciliIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: seciliIndex,
        onTap: (index) {
          setState(() {
            seciliIndex = index;
          });
        },
        items: [
          const BottomNavigationBarItem(
            label: "AnaSayfa",
            icon: Icon(Icons.home_outlined),
          ),

          const BottomNavigationBarItem(
            label: "Kayıtlılar",
            icon: Icon(Icons.save_outlined),
          ),
        ],
      ),
    );
  }
}
