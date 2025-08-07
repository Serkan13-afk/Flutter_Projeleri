import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:futbol_takipuyg/FavoriTakimDetaySayfasi.dart';
import 'package:futbol_takipuyg/Takim.dart';
import 'package:shimmer/shimmer.dart';

import 'FavoriTakimCubit.dart';

class Favoritakimlar extends StatefulWidget {
  @override
  State<Favoritakimlar> createState() => _FavoritakimlarState();
}

class _FavoritakimlarState extends State<Favoritakimlar> {
  var iconBasildiMi = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Shimmer.fromColors(
          baseColor: Colors.cyan,
          highlightColor: Colors.black,
          child: Align(
            alignment: Alignment.center,
            child: Text(
              "Favori Takımlar",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
            ),
          ),
        ),
        actions: [
          // Sol tarafa içerik yerleştirir
          IconButton(
            onPressed: () {
              setState(() {
                iconBasildiMi = !iconBasildiMi;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Bu sayfadaki takımlar favoriler olup anlık durumlarını takip takımlardan oluşmaktadır ",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  duration: Duration(milliseconds: 2500),
                ),
              );
            },
            icon: Icon(
              Icons.info,
              color: iconBasildiMi ? Colors.green : Colors.red,
            ),
          ),
        ],
        backgroundColor: Colors.black,
      ),
      body: BlocBuilder<FavoriCubit, List<Takim>>(
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
                  leading: Image.network("${veri.armasi}"),
                  title: Shimmer.fromColors(
                    baseColor: Colors.white54,
                    highlightColor: Colors.green,
                    child: Text(
                      "${veri.takimAdi}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  subtitle: Text(
                    "${veri.stad}",
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
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Favoritakimdetaysayfasi(veri),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
