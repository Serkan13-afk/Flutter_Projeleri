import 'package:chatapp13/Providerler.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:chatapp13/generated/l10n.dart';


class Karekodsayfa extends StatefulWidget {
  const Karekodsayfa({super.key});

  @override
  State<Karekodsayfa> createState() => _KarekodsayfaState();
}

class _KarekodsayfaState extends State<Karekodsayfa> {
  var karekodurl = "https://drive.google.com/file/d/1OzFq7fVaWwPwIm8Yqbvi84G4VG8ZoUaM/view?usp=sharing";

  @override
  Widget build(BuildContext context) {
    return Consumer<TemaOkuma>(
      builder: (context, temaNesne, child) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(100),
            child: AppBar(
              backgroundColor:
                  temaNesne.temaOku() ? Colors.white : Colors.black,
              shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              title: Align(
                alignment: Alignment.center,
                child: Text(
                  S.of(context).karekod,
                  style: TextStyle(
                    color: temaNesne.temaOku() ? Colors.black : Colors.white,
                  ),
                ),
              ),
            ),
          ),
          body: Center(
            child: QrImageView(
              foregroundColor: temaNesne.temaOku() ? Colors.white : Colors.black,
                gapless: true,
                size: 250,
                version: QrVersions.auto,
                data: karekodurl),
          ),
        );
      },
    );
  }
}
