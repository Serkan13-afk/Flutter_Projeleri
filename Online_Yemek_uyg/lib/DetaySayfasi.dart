import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gosteris/FavoriCubit.dart';
import 'package:gosteris/SepetCubit.dart';
import 'package:gosteris/YiyecekVeIcecek.dart';
import 'package:shimmer/shimmer.dart';

class Detaysayfasi extends StatefulWidget {
  late YiyecekVeIcecek yiyecekVeIcecek;

  Detaysayfasi(this.yiyecekVeIcecek);

  @override
  State<Detaysayfasi> createState() => _DetaysayfasiState();
}

class _DetaysayfasiState extends State<Detaysayfasi>
    with TickerProviderStateMixin {
  bool seciliMi = false;
  late Animation<double> animationDegerleri;
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );
    animationDegerleri = Tween(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeOut),
    )
      ..addListener(() {
        setState(() {});
      });
    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Transform.translate(
          offset: Offset(0, animationDegerleri.value),

          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Card(
                  elevation: 10,
                  shadowColor: Colors.black,
                  child: Positioned.fill(
                    child: Image.network(
                      "${widget.yiyecekVeIcecek.resim_url}",
                      fit: BoxFit.cover, //Bulunduğu cardı kapla
                    ),
                  ),
                  color: Colors.blue,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.pink,
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Shimmer.fromColors(
                                baseColor: Colors.grey,
                                highlightColor: Colors.white,
                                child: Text(
                                  "${widget.yiyecekVeIcecek.aciklama}",
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: SizedBox(
                                  width: 200,
                                  child: Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .center,
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              setState(() {
                                                seciliMi = !seciliMi;
                                              });
                                              var mesaj = seciliMi
                                                  ? "Ürün başarılı bir şekilde favorilere eklendi"
                                                  : "Ürün başarılı bir şekilde favorilerden çıkarıldı";

                                              seciliMi
                                                  ? context.read<
                                                  FavoriCubit>().veriEkle(
                                                  widget.yiyecekVeIcecek)
                                                  : context
                                                  .read<FavoriCubit>()
                                                  .veriSil(
                                                  widget.yiyecekVeIcecek);
                                              ScaffoldMessenger
                                                  .of(context)
                                                  .showSnackBar(SnackBar(
                                                content: Shimmer.fromColors(
                                                  baseColor: Colors.grey,
                                                  highlightColor: Colors
                                                      .white,
                                                  child: Text(
                                                    "${mesaj}",
                                                    style: TextStyle(
                                                        fontWeight: FontWeight
                                                            .bold,
                                                        fontSize: 20),),
                                                ), backgroundColor: Colors.blue,
                                              )
                                              );
                                            },
                                            icon: Icon(Icons.favorite,
                                              color: seciliMi ? Colors
                                                  .greenAccent : Colors.red,
                                              size: 20,)
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            context.read<SepetCubit>().veriEkle(
                                              widget.yiyecekVeIcecek,
                                            );
                                            Navigator.pop(context);

                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  "Ürün Başarılı bir şekilde eklendi",
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                backgroundColor:
                                                Colors.lightGreenAccent,
                                              ),
                                            );
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                "Ekle",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 25,
                                                  color: Colors.green,
                                                ),
                                              ),
                                              Icon(
                                                Icons.add,
                                                color: Colors.green,
                                                size: 30,
                                              ),
                                            ],
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.black,
                                          ),
                                        )
                                      ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
