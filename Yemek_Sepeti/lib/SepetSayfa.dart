import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:yemek_siparis_uyg/Kisiler2.dart';
import 'package:yemek_siparis_uyg/SepetBlocState.dart';
import 'package:yemek_siparis_uyg/SepetCubit.dart';
import 'package:flutter/material.dart' as badges;

class Sepetsayfa extends StatefulWidget {
  late Kisiler2 kisiler2;

  Sepetsayfa(this.kisiler2);

  @override
  State<Sepetsayfa> createState() => _SepetsayfaState();
}

class _SepetsayfaState extends State<Sepetsayfa> {
  bool Varmi = false;

  Widget sepetTutari() {
    return BlocBuilder<SepetCubit, SepetBlocState>(
      builder: (context, state) {
        return Card(
          shadowColor: Colors.white,
          color: Colors.white,
          elevation: 10,
          shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.green, width: 3.0),
          ),
          child: SizedBox(
            width: 370,
            height: 50,
            child: Center(
              child:
                  Varmi
                      ? Text(
                        "Sepet Tutarı : ${state.toplamTutar - (state.sepetListesi.length * 5)}",
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      )
                      : Text(
                        "Sepet Tutarı : ${state.toplamTutar}",
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
            ),
          ),
        );
      },
    );
  }

  Widget sepettekiVeri() {
    return BlocBuilder<SepetCubit, SepetBlocState>(
      builder: (context, sepetListesi) {
        // sepetlistesi SepetBlock için oluşturulmuş nesnedir
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 10 / 10,
            crossAxisCount: 2,
          ),
          itemCount: sepetListesi.sepetListesi.length,
          itemBuilder: (context, index) {
            var veri = sepetListesi.sepetListesi[index];
            return badges.Badge(
              offset: Offset(-7, 7),
              backgroundColor: Colors.red,
              label: GestureDetector(
                onTap: () {
                  context.read<SepetCubit>().veriSil(veri);
                },
                child: Text(
                  "X",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              child: Card(
                elevation: 10,
                shadowColor: Colors.white,
                shape: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Colors.cyanAccent, width: 3.0),
                ),
                color: Colors.white54,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 120,
                        height: 120,
                        child: Image.network("${veri.strMealThumb}"),
                      ),
                      Text("${veri.strMeal}", overflow: TextOverflow.ellipsis),
                      Text("Fiyat : 40Tl"),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget butonlar() {
    return BlocBuilder<SepetCubit, SepetBlocState>(
      builder: (context, sepetNesne) {
        return SizedBox(
          width: 250,
          child: Card(
            shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.green, width: 3.0),
            ),
            color: Colors.white,
            shadowColor: Colors.white54,
            elevation: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    context.read<SepetCubit>().sepetiTemizle();
                  },
                  icon: Icon(Icons.close, color: Colors.red, size: 30),
                ),
                SizedBox(width: 20),

                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                            "Sepet Onay Sayfası",
                            style: TextStyle(color: Colors.black),
                          ),
                          shape: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                              color: Colors.green,
                              width: 2.0,
                            ),
                          ),
                          shadowColor: Colors.black,
                          backgroundColor: Colors.white,
                          content: SizedBox(
                            width: 320,
                            height: 400,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Varmi
                                      ? Text(
                                        """
             😊 Premium sahibisiniz !
             
Sepetinizde her ürüne 5 TL indirim uygulandı
      ${sepetNesne.sepetListesi.length} adet yemek siparişiniz ${sepetNesne.toplamTutar - (sepetNesne.sepetListesi.length * 5)}
      
                Onaylıyor musunuz ?
                                  
                                  """,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                      )
                                      : Text(
                                        """
             😔 Premium değilsiniz !
             
Sepetinizde hiçbir ürüne herhangi bir indirim uygulanmadı
      ${sepetNesne.sepetListesi.length} adet yemek siparişiniz ${sepetNesne.toplamTutar}
      
                Onaylıyor musunuz ?
                                  
                                  """,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                      ),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          "İptal",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.teal,
                                          shadowColor: Colors.black,
                                          side: BorderSide(
                                            color: Colors.greenAccent,
                                            width: 2.0,
                                          ),
                                          elevation: 10,
                                        ),
                                      ),
                                      SizedBox(width: 20),
                                      ElevatedButton(
                                        onPressed: () {
                                          context
                                              .read<SepetCubit>()
                                              .sepetiTemizle();
                                          Navigator.pop(context);
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                "Sepetiniz onaylandı 30-40 dk içerisinde siparişiniz kapıda",
                                              ),
                                              duration: Duration(
                                                milliseconds: 2000,
                                              ),
                                              backgroundColor: Colors.white,
                                            ),
                                          );
                                        },
                                        child: Text(
                                          "Onayla",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.teal,
                                          shadowColor: Colors.black,
                                          side: BorderSide(
                                            color: Colors.greenAccent,
                                            width: 2.0,
                                          ),
                                          elevation: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  icon: Icon(Icons.check, color: Colors.green, size: 30),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    Varmi = widget.kisiler2.premiumVarmi;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.center,
          child: Text(
            "Sepetim",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Premium satın aldıysanız sipariş başına 5TL indirim yapılacaktır",
                    style: TextStyle(color: Colors.black),
                  ),
                  duration: Duration(milliseconds: 3000),
                  backgroundColor: Colors.white,
                ),
              );
            },
            icon: Icon(Icons.info, color: Colors.green, size: 25),
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            sepetTutari(),

            Expanded(child: sepettekiVeri()), // Burada Expanded ekledik

            butonlar(),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
