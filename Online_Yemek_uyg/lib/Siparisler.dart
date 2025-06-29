import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gosteris/SepetCubit.dart';
import 'package:gosteris/YiyecekVeIcecek.dart';
import 'package:shimmer/shimmer.dart';

class Sepet extends StatefulWidget {
  const Sepet({super.key});

  @override
  State<Sepet> createState() => _SepetState();
}

class _SepetState extends State<Sepet> {
  int siparisTutari(List<YiyecekVeIcecek> sepetListesi) {
    int toplam = 0;
    for (var item in sepetListesi) {
      toplam += int.tryParse(item.fiyat) ?? 0;
    }
    return toplam;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyanAccent,
        title: Shimmer.fromColors(
          baseColor: Colors.black,
          highlightColor: Colors.white,
          child: Text(
            "Siparişlerim",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          ),
        ),
      ),
      backgroundColor: Colors.black,
      body: BlocBuilder<SepetCubit, List<YiyecekVeIcecek>>(
        builder: (context, sepetListesi) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Shimmer.fromColors(
                  baseColor: Colors.white,
                  highlightColor: Colors.green,
                  child: Text(
                    "Toplam Tutar: ${siparisTutari(sepetListesi)} ₺",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
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
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ),
                        subtitle: Text(
                          "${veri.fiyat} ₺",
                          style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            context.read<SepetCubit>().veriSil(veri);
                          },
                        ),
                        tileColor: Colors.cyanAccent,
                        shape: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
