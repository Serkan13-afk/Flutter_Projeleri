import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:muzikcalar_app/AramaSayfa.dart';
import 'package:muzikcalar_app/Kutuphane.dart';
import 'package:muzikcalar_app/ProfilSayfa.dart';

import 'AnaSayfa.dart';

class GecisSayfa extends StatefulWidget {
  late User user;

  GecisSayfa(this.user);

  @override
  State<GecisSayfa> createState() => _GecisSayfaState();
}

class _GecisSayfaState extends State<GecisSayfa> {
  int selectedIndex = 0;

  // Sayfa listesi
  late List<Widget> sayfalar = [
    Anasayfa(widget.user),
    Aramasayfa(),
    Kutuphane(),
    Profilsayfa(widget.user),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: sayfalar[selectedIndex],

      bottomNavigationBar: Container(
        height: 90,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.9),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
          backgroundColor: Colors.transparent,
          selectedItemColor: Color(0xFF00FFE1),
          unselectedItemColor: Colors.white54,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 16,
          unselectedFontSize: 12,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Ana Sayfa'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Ara'),
            BottomNavigationBarItem(
              icon: Icon(Icons.library_music),
              label: 'Kütüphane',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
          ],
        ),
      ),
    );
  }
}
