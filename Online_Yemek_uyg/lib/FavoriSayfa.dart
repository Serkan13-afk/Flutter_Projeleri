import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gosteris/FavoriCubit.dart';
import 'package:gosteris/YiyecekVeIcecek.dart';
import 'package:shimmer/shimmer.dart';

class Favorisayfa extends StatefulWidget {
  const Favorisayfa({super.key});

  @override
  State<Favorisayfa> createState() => _FavorisayfaState();
}

class _FavorisayfaState extends State<Favorisayfa> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyanAccent,
        title: Align(
          alignment: Alignment.bottomLeft,
          child: Shimmer.fromColors(
            baseColor: Colors.black,
            highlightColor: Colors.white,
            child: Text(
              "Favorilerim",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
          ),
        ),
      ),
      backgroundColor: Colors.black,
      body: BlocBuilder<FavoriCubit, List<YiyecekVeIcecek>>(
        builder: (context, sepetListesi) {
          return ListView.builder(
            itemCount: sepetListesi.length,
            itemBuilder: (context, index) {
              var veri = sepetListesi[index];
              return Card(
                elevation: 10,
                shadowColor: Colors.black,
                margin: const EdgeInsets.all(10.0),
                child: ListTile(
                  leading: Image.network("${veri.resim_url}"),
                  title: Shimmer.fromColors(
                    baseColor: Colors.white54,
                    highlightColor: Colors.green,
                    child: Text(
                      veri.ad,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  subtitle: Text(
                    "${veri.fiyat} ₺",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      context.read<FavoriCubit>().veriSil(veri);
                    },
                  ),
                  tileColor: Colors.cyanAccent,
                  shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
