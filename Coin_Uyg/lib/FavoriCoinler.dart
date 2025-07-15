import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kripto_uyg/Coin.dart';
import 'package:kripto_uyg/FavoriCoinCubit.dart';
import 'package:kripto_uyg/Kisi.dart';
import 'package:shimmer/shimmer.dart';

class Favoricoinler extends StatefulWidget {

  @override
  State<Favoricoinler> createState() => _FavoricoinlerState();
}

class _FavoricoinlerState extends State<Favoricoinler> {
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
      body: BlocBuilder<FavoriCoinCubit, List<Coin>>(
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
                  leading: Image.network("${veri}"),
                  title: Shimmer.fromColors(
                    baseColor: Colors.white54,
                    highlightColor: Colors.green,
                    child: Text(
                      veri.isim,
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
                      context.read<FavoriCoinCubit>().veriSil(veri);
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
