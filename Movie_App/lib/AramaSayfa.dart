import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:movieapp/KayitSepetState.dart';
import 'package:movieapp/KayitliCubit.dart';
import 'package:movieapp/Movie.dart';
import 'package:movieapp/Providerler.dart';
import 'package:movieapp/generated/l10n.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart' as badges;

class Aramasayfa extends StatefulWidget {
  const Aramasayfa({super.key});

  @override
  State<Aramasayfa> createState() => _AramasayfaState();
}

class _AramasayfaState extends State<Aramasayfa> with TickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animationDegerler;
  bool yukleniyormu = true;
  List<Movie> allMovie = [];
  Map<int, bool> secilimi = {};

  Future<void> tumFilmler() async {
    var url = Uri.parse(
      "https://api.themoviedb.org/3/movie/popular?api_key=c2fd7f416e2b96abc7cda7688e2ec59e&language=en-US&page=1",
    );
    var cevap = await http.get(url);

    if (cevap.statusCode == 200) {
      var filmler = json.decode(cevap.body);
      final List<dynamic> movieList = filmler["results"];

      if (movieList.isNotEmpty) {
        allMovie.clear();
        for (var veri in movieList) {
          var filmler = Movie.fromJson(veri);

          allMovie.add(filmler);
        }

        setState(() {
          yukleniyormu = false;
        });
      }
    } else {
      print("Film çekilemedi");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tumFilmler();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2000),
    );
    animationDegerler = Tween(begin: 75.0, end: 0.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.linear),
    )..addListener(() {
      setState(() {});
    });
    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    if (yukleniyormu) {
      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 2 / 3,
          crossAxisCount: 3,
        ),
        itemCount: 20,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(15),
            ),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[400]!,
              highlightColor: Colors.grey[100]!,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 6),
                  Container(width: 20, height: 10, color: Colors.grey),
                  SizedBox(height: 6),

                  Container(
                    width: 100,
                    height: 130,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  SizedBox(height: 4),
                  Container(width: 50, height: 10, color: Colors.grey),
                ],
              ),
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: Consumer<TemaOkuma>(
          builder: (context, temaNesne, child) {
            return AppBar(
              automaticallyImplyLeading: false, // geri butonunu gizler

              backgroundColor:
                  temaNesne.temaOku() ? Colors.white : Colors.black,
              shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              title: Align(
                alignment: Alignment.center,
                child: Text(
                  S.of(context).film_arama,
                  style: TextStyle(
                    fontSize: 24,
                    color: temaNesne.temaOku() ? Colors.black : Colors.white,
                  ),
                ),
              ),
            );
          },
        ),
      ),
      body: BlocBuilder<KayitliCubit, KayitSepetState>(
        builder: (context, state) {
          return Transform.translate(
            offset: Offset(0, animationDegerler.value),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 2 / 3,
                crossAxisCount: 3,
              ),
              itemCount: allMovie.length,
              itemBuilder: (context, index) {
                var filmim = allMovie[index];
                return Container(
                  margin: EdgeInsets.only(top: 10, right: 5),
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.pink[500],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      badges.Badge(
                        offset: Offset(20, -2),
                        backgroundColor: Colors.cyanAccent,
                        label: Text(
                          S.of(context).yeni,
                          style: TextStyle(color: Colors.black),
                        ),
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              secilimi[index] = !(secilimi[index] ?? false);
                            });
                            (secilimi[index] ?? false)
                                ? context.read<KayitliCubit>().veriEkle(filmim)
                                : context.read<KayitliCubit>().veriSil(filmim);
                          },
                          icon: Icon(
                            Icons.save_outlined,
                            color:
                                (secilimi[index] ?? false)
                                    ? Colors.cyanAccent
                                    : Colors.grey,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.black,
                        child: ClipOval(
                          child:
                              (filmim.posterPath != null &&
                                      filmim.posterPath!.isNotEmpty)
                                  ? Image.network(
                                    "https://image.tmdb.org/t/p/w200${filmim.posterPath}",
                                    fit: BoxFit.cover,
                                  )
                                  : Icon(Icons.movie, size: 50),
                        ),
                      ),
                      SizedBox(height: 15),
                      Text(
                        "${filmim.title}",
                        style: TextStyle(fontSize: 14, color: Colors.black),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
