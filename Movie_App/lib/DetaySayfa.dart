import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieapp/KayitSepetState.dart';
import 'package:movieapp/KayitliCubit.dart';
import 'package:movieapp/Movie.dart';
import 'package:movieapp/Providerler.dart';
import 'package:movieapp/ReklamWidget.dart';
import 'package:movieapp/WebSayfasi.dart';
import 'package:movieapp/generated/l10n.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class Detaysayfa extends StatefulWidget {
  late Movie movie;

  Detaysayfa(this.movie);

  @override
  State<Detaysayfa> createState() => _DetaysayfaState();
}

class _DetaysayfaState extends State<Detaysayfa> with TickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animationDegerler;
  bool kayittaBasildiMi = false;
  String mesaj = "";

  Widget urunPuani() {
    int max = 10;
    int tamkisim = double.parse("${widget.movie.voteAverage}").toInt();

    return Consumer<TemaOkuma>(
      builder: (context, temaNesne, child) {
        return SizedBox(
          height: 60,
          width: 300,
          child: Card(
            shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.tealAccent, width: 2.0),
            ),
            shadowColor: temaNesne.temaOku() ? Colors.white : Colors.black,
            elevation: 10,
            color: Colors.blueGrey,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  max,
                  (index) => Icon(
                    Icons.star_border_purple500,
                    color: index < tamkisim ? Colors.yellowAccent : Colors.grey,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2000),
    );
    animationDegerler = Tween(begin: 0.7, end: 1.2).animate(
      CurvedAnimation(parent: animationController, curve: Curves.linear),
    )..addListener(() {
      setState(() {});
    });
    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: Consumer<TemaOkuma>(
          builder: (context, temaNesne, child) {
            return BlocBuilder<KayitliCubit, KayitSepetState>(
              builder: (context, state) {
                return AppBar(
                  title: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "${widget.movie.title}",
                      style: TextStyle(
                        color:
                            temaNesne.temaOku() ? Colors.black : Colors.white,
                      ),
                    ),
                  ),
                  actions: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          kayittaBasildiMi = !kayittaBasildiMi;
                        });

                        kayittaBasildiMi
                            ? mesaj =
                                S.of(context).detaysayfasi_snackbar_mesaj1
                            : mesaj =
                            S.of(context).detaysayfasi_snackbar_mesaj2;
                        kayittaBasildiMi
                            ? context.read<KayitliCubit>().veriEkle(
                              widget.movie,
                            )
                            : context.read<KayitliCubit>().veriSil(
                              widget.movie,
                            );

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              mesaj,
                              style: TextStyle(color: Colors.black),
                            ),
                            duration: Duration(milliseconds: 2000),
                            backgroundColor: Colors.grey,
                          ),
                        );
                      },
                      icon:
                          kayittaBasildiMi
                              ? Icon(
                                Icons.save,
                                color: Colors.green[500],
                                size: 28,
                              )
                              : Icon(Icons.save, color: Colors.red),
                    ),
                  ],
                  shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  backgroundColor:
                      temaNesne.temaOku() ? Colors.white : Colors.black,
                );
              },
            );
          },
        ),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Consumer<TemaOkuma>(
        builder: (context, temaNesne, child) {
          return SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 30),
                  Transform.scale(
                    scale: animationDegerler.value,

                    child: CircleAvatar(
                      radius: 100,
                      backgroundColor: Colors.black,
                      child: ClipOval(
                        child:
                            widget.movie.posterPath != null
                                ? SizedBox(
                                  width: 200,
                                  height: 200,
                                  child: Image.network(
                                    "https://image.tmdb.org/t/p/w200${widget.movie.posterPath}",
                                    fit: BoxFit.cover,
                                  ),
                                )
                                : Icon(Icons.movie),
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  Text(""""
                  ${widget.movie.overview}
                  """),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Shimmer.fromColors(
                        baseColor:
                            temaNesne.temaOku()
                                ? Colors.white60
                                : Colors.black54,
                        highlightColor:
                            temaNesne.temaOku() ? Colors.white : Colors.black,
                        child: Text(
                          S.of(context).film_puan_ortalamasi,
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                      SizedBox(width: 5),

                      Shimmer.fromColors(
                        baseColor:
                            temaNesne.temaOku()
                                ? Colors.white60
                                : Colors.black54,
                        highlightColor:
                            temaNesne.temaOku() ? Colors.white : Colors.black,
                        child: Text(
                          "${S.of(context).puanlama_yapan_kisi_sayisi} :${widget.movie.voteCount}",
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 10),

                  urunPuani(),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 80,
                        width: 196,
                        child: Card(
                          shadowColor:
                              temaNesne.temaOku() ? Colors.white : Colors.black,
                          shape: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                              color: Colors.tealAccent,
                              width: 2.0,
                            ),
                          ),
                          elevation: 10,
                          color: Colors.pink[500],
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "${S.of(context).yayinlanis_tarihi} :${widget.movie.releaseDate}",
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 80,
                        width: 196,
                        child: Card(
                          shadowColor:
                              temaNesne.temaOku() ? Colors.white : Colors.black,
                          shape: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                              color: Colors.tealAccent,
                              width: 2.0,
                            ),
                          ),
                          elevation: 10,
                          color: Colors.pink[500],
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "${S.of(context).populerligi} :${widget.movie.popularity}",
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 18),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Websayfasi(widget.movie.id!),
                        ),
                      );
                    },
                    child: Text(
                      S.of(context).web_sayfasina_bakin,
                      style: TextStyle(color: Colors.black),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple[500],
                      side: BorderSide(color: Colors.tealAccent, width: 2.0),
                      shadowColor:
                          temaNesne.temaOku() ? Colors.white : Colors.black,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 18),

                  SizedBox(height: 200, width: 500, child: Reklamwidget()),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
