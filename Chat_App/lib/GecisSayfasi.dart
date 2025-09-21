import 'package:chatapp13/AnaSayfa.dart';
import 'package:chatapp13/ProfilSayfa.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chatapp13/generated/l10n.dart';

class Gecissayfasi extends StatefulWidget {
  late User? gelenKisi;

  Gecissayfasi(this.gelenKisi);

  @override
  State<Gecissayfasi> createState() => _GecissayfasiState();
}

class _GecissayfasiState extends State<Gecissayfasi> {
  List<Widget> seciliSayfa = [];
  var seciliIndex = 0;

  @override
  void initState() {
    seciliSayfa = [Anasayfa(), Profilsayfa(widget.gelenKisi)];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: seciliSayfa[seciliIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: seciliIndex,
        onTap: (index) {
          setState(() {
            seciliIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(label: S.of(context).anasayfa, icon: Icon(Icons.home)),
          BottomNavigationBarItem(
            label: S.of(context).profil,
            icon: Icon(Icons.person_outline),
          ),
        ],
      ),
    );
  }
}
