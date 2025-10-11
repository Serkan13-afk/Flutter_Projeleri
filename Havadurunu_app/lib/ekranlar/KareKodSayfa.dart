import 'package:flutter/material.dart';
import 'package:havadurumu_app/Providerler.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class KareKodSayfa extends StatefulWidget {
  const KareKodSayfa({super.key});

  @override
  State<KareKodSayfa> createState() => _KareKodSayfaState();
}

class _KareKodSayfaState extends State<KareKodSayfa> {
  var url =
      "https://drive.google.com/file/d/19is_REbylze68KZ8ji4E-m9ZWGDu3dql/view?usp=sharing";

  @override
  Widget build(BuildContext context) {
    return Consumer<TemaOkuma>(
      builder: (context, temaNesne, child) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(100),
            child: AppBar(
              backgroundColor: Colors.lightBlueAccent,
              title: Text("Uygulama Kare Kodu"),
            ),
          ),
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: temaNesne.temaOku()
                    ? [Colors.white, Colors.cyanAccent]
                    : [Colors.black, Colors.cyanAccent],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
            child: Center(
              child: QrImageView(
                foregroundColor: temaNesne.temaOku()
                    ? Colors.white
                    : Colors.black,
                backgroundColor: temaNesne.temaOku()
                    ? Colors.black
                    : Colors.white,
                gapless: true,
                size: 350,
                data: url,
              ),
            ),
          ),
        );
      },
    );
  }
}
