import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieapp/KayitSepetState.dart';
import 'package:movieapp/KayitliCubit.dart';
import 'package:movieapp/Movie.dart';
import 'package:movieapp/Providerler.dart';
import 'package:movieapp/generated/l10n.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart' as badges;

class Kayitlilar extends StatefulWidget {
  @override
  State<Kayitlilar> createState() => _KayitlilarState();
}

class _KayitlilarState extends State<Kayitlilar> {
  var yuklendiMi = false;
  List<Movie> filmListesi = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<KayitliCubit, KayitSepetState>(
      builder: (context, state) {
        List<Movie> filmListe = state.sepetListe;
        return Consumer<TemaOkuma>(
          builder: (context, temaNesne, child) {
            return Scaffold(
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(100),
                child: AppBar(
                  automaticallyImplyLeading: false, // geri butonunu gizler

                  actions: [
                    IconButton(
                      onPressed: () {
                        context.read<KayitliCubit>().kayitSayfasiniBosalt();
                      },
                      icon: Icon(
                        Icons.remove_circle_outline_outlined,
                        color: Colors.cyanAccent,
                        size: 30,
                      ),
                    ),
                  ],
                  title: Align(
                    alignment: Alignment.center,
                    child: Text(
                      S.of(context).kayitli_filmler,
                      style: TextStyle(
                        color:
                            temaNesne.temaOku() ? Colors.black : Colors.white,
                      ),
                    ),
                  ),
                  backgroundColor:
                      temaNesne.temaOku() ? Colors.white : Colors.black,
                  shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              body: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2 / 2.5,
                ),
                itemCount: filmListe.length,
                itemBuilder: (context, index) {
                  var verim = filmListe[index];
                  return Consumer<TemaOkuma>(
                    builder: (context, temaNesne, child) {
                      return badges.Badge(
                        offset: Offset(-13, 10),
                        backgroundColor: Colors.red,
                        label: GestureDetector(
                          onTap: () {
                            context.read<KayitliCubit>().veriSil(verim);
                          },
                          child: Text(
                            "X",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        child: Card(
                          margin: EdgeInsets.all(8),
                          shape: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.tealAccent,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 10,
                          shadowColor:
                              temaNesne.temaOku() ? Colors.white : Colors.black,
                          color: Colors.blueGrey[700],
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.network(
                                  "https://image.tmdb.org/t/p/w200${verim.posterPath}",
                                  width: 150,
                                  height: 170,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  verim.title!,
                                  style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
