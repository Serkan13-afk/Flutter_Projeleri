import 'package:flutter/material.dart';
import 'package:movieapp/AnaSayfa.dart';
import 'package:movieapp/AramaSayfa.dart';
import 'package:movieapp/Kayitlilar.dart';
import 'package:movieapp/Kisiler.dart';
import 'package:movieapp/ReklamWidget.dart';
import 'package:movieapp/generated/l10n.dart';

class Gecissayfalari extends StatefulWidget {
  late Kisiler kisiler;

  Gecissayfalari(this.kisiler);

  @override
  State<Gecissayfalari> createState() => _GecissayfalariState();
}

class _GecissayfalariState extends State<Gecissayfalari> {
  int seciliIndex = 0;
  late List<Widget> sayfalarim;

  @override
  void initState() {
    super.initState();
    sayfalarim = [Anasayfa(widget.kisiler), Kayitlilar(), Aramasayfa()];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: sayfalarim[seciliIndex]), // sayfanın içeriği
          Reklamwidget(), // banner reklam burada
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: seciliIndex,
        onTap: (index) {
          setState(() {
            seciliIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            label: S.of(context).anasayfa,
            icon: Icon(Icons.home_outlined, size: 30),
          ),
          BottomNavigationBarItem(
            label: S.of(context).kayitlilar,
            icon: Icon(Icons.save_outlined, size: 30),
          ),
          BottomNavigationBarItem(
            label: S.of(context).arama,
            icon: Icon(Icons.search, size: 30),
          ),
        ],
      ),
    );
  }
}
