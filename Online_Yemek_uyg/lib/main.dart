import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gosteris/AnaSayfa.dart';
import 'package:gosteris/FavoriCubit.dart';
import 'package:gosteris/FavoriSayfa.dart';
import 'package:gosteris/SepetCubit.dart';
import 'package:gosteris/Siparisler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SepetCubit()),
        BlocProvider(create: (context) => FavoriCubit()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: BarSayfa(),
      ),
    );
  }
}

class BarSayfa extends StatefulWidget {
  @override
  State<BarSayfa> createState() => _BarSayfaState();
}

class _BarSayfaState extends State<BarSayfa> {
  int seciliIndex = 0;
  List<Widget> sayfalar = [Anasayfa(), Sepet(), Favorisayfa()];

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
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "AnaSayfa"),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_basket),
            label: "Sepet",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Favori"),
        ],
        selectedItemColor: Colors.green,
        // Seçili ikon ve yazı rengi
        unselectedItemColor: Colors.red,
        // Seçili olmayanların rengi
        backgroundColor: Color(0xFF6A1B9A),
      ),
    );
  }
}
